
TRUNCATE TABLE NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_BASE_SUGERIDO_SEMANAL
INSERT INTO NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_BASE_SUGERIDO_SEMANAL
	--?? select * from NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_BASE_SUGERIDO_SEMANAL
	--?? select * from NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_BASE_SUGERIDO_SEMANAL where MIN_PRES_SS is null

	SELECT 
		A.LOCAL
		,M.SUBCLASE
		,M.CASEPACK
		,A.SKU
		,M.NOM_SKU
		,A.dir_cd
		,ISNULL(O.UN_INV, 0) OH_INICIAL
		,ISNULL(VTA.FORECAST_SEM_ACTUAL, 0) FORECAST_SEM_ACTUAL
		,ISNULL(FST.FORECAST_PROM_DIA_SEM_T, 0) FORECAST_PROM_DIA_SEM_T
		,ISNULL(FORECAST_SEM_T, 0) FORECAST_SEM_T
		,ISNULL(MER.MERMA_UNIDADES, 0) MERMA_SEM_ANT
		,ISNULL(VTAANT.VTA_SEM_ANTERIOR, 0) VTA_SEM_ANT
		,LM.LIMITE_MERMA
		,CASE 
			WHEN ISNULL(VTAANT.VTA_SEM_ANTERIOR, 0) > 0 AND ISNULL(ABS(MER.MERMA_UNIDADES), 0) >= LM.LIMITE_MERMA * ISNULL(VTAANT.VTA_SEM_ANTERIOR, 0) THEN 1
			ELSE 0 
		END CRITERIO_MERMA
		,M.CASEPACK * ISNULL(COMP.COMPRAS, 0) COMPRAS_SEMANA_ACTUAL
		,ISNULL(FR.FR_PONDERADO, 0) FR_PONDERADO
		,EFR.PFR EFECTO_FR
		,(1 - (ISNULL(FR.FR_PONDERADO, 0) / 100)) * (1 - EFR.PFR) + (ISNULL(FR.FR_PONDERADO, 0) / 100) FACTOR_FR
		,ISNULL(TRFCD.TRF_CD, 0) TRANSITO_CD
		,0 EN_PROMO
		,isnull(MP.[MIN], 1) MIN_PRES
		,isnull(MP.[MIN], 1) * ISNULL(FST.FORECAST_PROM_DIA_SEM_T, 0) MIN_PRES_UN
		,MPP.[MIN_PROMO] * isnull(MP.[MIN], 1) MIN_PRES_PROMO
		,MPP.[MIN_PROMO] * isnull(MP.[MIN], 1) * M.CASEPACK MIN_PRES_PROMO_UN
		,CASE 
			WHEN 0 = 0 THEN isnull(MP.[MIN], 1)*M.CASEPACK -- CAMBIAR CUANDO SE APLIQUEN PROMOCIONES
			ELSE isnull(MP.[MIN], 1) * isnull(MPP.[MIN_PROMO], 1) * M.CASEPACK
		END MIN_PRES_FINAL_UN
		,VU.VIDA_UTIL
		,isnull(VU.SS, 0) SS
		,ISNULL(FST.FORECAST_PROM_DIA_SEM_T, 0) * isnull(VU.SS, 0) SS_UN   
		,ISNULL(FST.FORECAST_PROM_DIA_SEM_T, 0) * isnull(VU.SS, 0) + (
			CASE 
				WHEN 0 = 0 THEN isnull(MP.[MIN], 1) * M.CASEPACK -- CAMBIAR CUANDO SE APLIQUEN PROMOCIONES
				ELSE isnull(MP.[MIN], 1) * isnull(MPP.[MIN_PROMO], 1)*M.CASEPACK
			END
		) MIN_PRES_SS
		,SP.SEMANA
	--INTO NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_BASE_SUGERIDO_SEMANAL   
	FROM (
		SELECT Codigo SKU, Division DIVISION, Surtido, Sala LOCAL, dir_cd
		FROM NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_SURTIDO_TIENDA
		Where Surtido = 1
	) A
	LEFT JOIN RepNonFood.dbo.MAESTRA_SKU M 
		ON M.SKU = A.SKU 
	LEFT JOIN (
		SELECT 
			[CUSTCOL_7] SKU
			,[COD_LOCALFISICO] COD_LOCAL
			,[UNIDINVDISPOHOY] UN_INV
		FROM [SUGERIDO_COMPRA].[dbo].[FFYVV_ONHAND]
	) O 
		ON O.COD_LOCAL = A.LOCAL 
		AND O.SKU = A.SKU
	LEFT JOIN NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_FILLRATE_SEMANAL_PONDERADO FR 
		ON FR.SUBCLASE = M.SUBCLASE
	LEFT JOIN NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_FORECAST_SEMANA_ACTUAL VTA 
		ON VTA.SKU = A.SKU 
		AND VTA.COD_LOCAL = A.LOCAL
	LEFT JOIN (
		SELECT 
			[CUSTCOL_7] SKU
			,[COD_LOCALFISICO] COD_LOCAL
			,[ID_SEMANACANALISIS] SEMANA
			,SUM(ISNULL([UNIDADES],0)) MERMA_UNIDADES
		FROM [SUGERIDO_COMPRA].[dbo].[FFYVV_MERMA]
		GROUP BY [CUSTCOL_7]
			,[COD_LOCALFISICO] 
			,[ID_SEMANACANALISIS]
	) MER 
		ON MER.COD_LOCAL = A.LOCAL 
		AND MER.SKU = A.SKU
	LEFT JOIN (
		select 
			SKU
			,SALA COD_LOCAL
			,SUM(CAJAS) COMPRAS
		FROM [NUEVO_SUGERIDO_FFVV].[dbo].vw_comprado
		WHERE fecha_entrega_cd >= CONVERT(DATE, GETDATE())
		GROUP BY SKU, SALA
	) COMP 
		ON COMP.COD_LOCAL = A.LOCAL 
		AND COMP.SKU = A.SKU
	LEFT JOIN (
		SELECT 
			SKU
			,TIENDA_RECIBO COD_LOCAL
			,ASIGNADO TRF_CD
		FROM [SUGERIDO_COMPRA].[dbo].[FFYVV_TRFS_TRANSITO]
	) TRFCD 
		ON TRFCD.SKU = A.SKU 
		AND TRFCD.COD_LOCAL = A.LOCAL
	LEFT JOIN (
		SELECT 
			COD_LOCAL
			,SKU
			,VTA_SEM_ANTERIOR
		FROM NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_VENTA_SEM_ANTERIOR
	) VTAANT 
		ON VTAANT.COD_LOCAL = A.LOCAL 
		AND VTAANT.SKU = A.SKU
	LEFT JOIN [NUEVO_SUGERIDO_FFVV].[dbo].[NSFFVV_EFECTO_FILLRATE] EFR 
		ON EFR.SUBCLASE = M.SUBCLASE
	LEFT JOIN [NUEVO_SUGERIDO_FFVV].[dbo].[NSFFVV_LIMITE_MERMA] LM 
		ON LM.COD_LOCAL = A.LOCAL
	LEFT JOIN [NUEVO_SUGERIDO_FFVV].[dbo].[NSFFVV_MIN_PRES] MP 
		ON MP.SKU = M.SKU
		AND MP.COD_LOCAL = A.LOCAL
	LEFT JOIN [NUEVO_SUGERIDO_FFVV].[dbo].[NSFFVV_MIN_PRES_PROMO] MPP 
		ON MPP.SKU = M.SKU
		AND MPP.COD_LOCAL = A.LOCAL 
	LEFT JOIN (
		SELECT VU.CLASE, VU.VIDA_UTIL, ISNULL(SS.ss,0) SS
		FROM [NUEVO_SUGERIDO_FFVV].[dbo].[NSFFVV_VIDA_UTIL] VU
		LEFT JOIN [NUEVO_SUGERIDO_FFVV].dbo.[NSFFVV_CRITERIOS_SS] SS
			ON VU.VIDA_UTIL >= SS.VU_DESDE
			AND VU.VIDA_UTIL <= 
				CASE 
					WHEN SS.VU_HASTA IS NULL THEN (SELECT MAX(VIDA_UTIL) FROM [NUEVO_SUGERIDO_FFVV].[dbo].[NSFFVV_VIDA_UTIL]) 
					ELSE SS.VU_HASTA 
				END
	) VU 
		ON VU.CLASE = M.CLASE  
	LEFT JOIN NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_FORECAST_SEMANA_T FST 
		ON FST.SKU = A.SKU 
		AND FST.COD_LOCAL = A.LOCAL 
	,(SELECT MAX(SEMANA) SEMANA FROM NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_FORECAST_SEMANA_T) SP