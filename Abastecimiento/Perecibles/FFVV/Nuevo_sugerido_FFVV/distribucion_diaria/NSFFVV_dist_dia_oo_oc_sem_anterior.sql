
-- declare @dia_pedido date = (select MAX(fecha_hora) from NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_SUGERIDO_CALCULADO_F)
declare @dia_pedido date = '2021-04-30';
-- declare @dia_pedido date = getdate();
declare @dia_inicio_compra date = dateadd(day, 8 - datepart(weekday, @dia_pedido), @dia_pedido);
declare @id_semana_pedido int = datepart(year, @dia_inicio_compra) * 100 + datepart(iso_week, @dia_inicio_compra);
declare @id_semana_anterior int = datepart(year, dateadd(day, -7, @dia_inicio_compra)) * 100 + datepart(iso_week, dateadd(day, -7, @dia_inicio_compra));
declare @dia as smallint = datepart(weekday, @dia_inicio_compra);
declare @desviaciones as int;
declare @iteracion as int = 1;
-- select 
-- 	@dia_pedido dia_pedido,
-- 	@dia_inicio_compra dia_inicio_compra,
-- 	@id_semana_pedido id_semana_pedido,
-- 	@id_semana_anterior id_semana_anterior,
-- 	@dia dia,
-- 	@desviaciones desviaciones,
-- 	@iteracion iteracion



/** Calculo on order semana anterior al pedido.
	* Desc:		Suma las cantidades compradas en ordenes de compra pre-distribuidas y estado on order de la semana anterior a la fecha de despacho
	* param:	@id_semana_anterior >> indica la semana anterior a la semana de inicio de pedido
	* param:	@dia_pedido >> filtro para seleccionar las OCs desde el dia en que se corre el pedido en adelante
	* -- ?? select * from [NUEVO_SUGERIDO_FFVV].[dbo].[NSFFVV_dist_dia_oo_oc_sem_anterior]
	* -- !TODO: traer estado desde dwh
	**/
	--!! truncate table [NUEVO_SUGERIDO_FFVV].[dbo].[NSFFVV_dist_dia_oo_oc_sem_anterior]
	--!! insert into [NUEVO_SUGERIDO_FFVV].[dbo].[NSFFVV_dist_dia_oo_oc_sem_anterior]


	SELECT 
		oc.SKU,
		oc.LOCAL_RECIBO cod_local,
		cf.dia_entrega_cd,
		SUM(UNID_SOLIC) on_order
	--into [NUEVO_SUGERIDO_FFVV].[dbo].[NSFFVV_dist_dia_oo_oc_sem_anterior]
	from [NUEVO_SUGERIDO_FFVV].[dbo].[NSFFVV_COMPRA_PREDISTRIBUIDA] oc
	left join [NUEVO_SUGERIDO_FFVV].[dbo].[NSFFVV_CICLO_DIA_FRECUENCIAS] cf
		on cf.cod_local = oc.LOCAL_RECIBO
	where oc.id_semana = @id_semana_anterior
		and cf.id_semana = @id_semana_pedido
		and fecha_esp_recep_sala >= @dia_pedido
		and ESTADO_OC like '%On Order%'
		and LOCAL_ENVIO = 429
	group by
		oc.SKU,
		oc.LOCAL_RECIBO,
		cf.dia_entrega_cd
