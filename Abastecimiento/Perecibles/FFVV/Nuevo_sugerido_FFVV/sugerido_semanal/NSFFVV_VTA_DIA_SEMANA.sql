
TRUNCATE TABLE NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_VTA_DIA_SEMANA
INSERT INTO NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_VTA_DIA_SEMANA

	SELECT 
		V.[COD_LOCAL]
		,M.SUBCLASE
		,M.ESTADO
		,CASE WHEN S.SKU IS NULL AND S.LOCAL IS NULL THEN 0 ELSE 1 END IND_SURTIDO
		,SUM([VTA]) VTA
		,DATEPART(WEEKDAY, DIA) DIA_SEMANA
		,SEMANA
	--INTO NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_VTA_DIA_SEMANA
	FROM NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_VENTA_DIARIA V
	LEFT JOIN RepNonFood.dbo.MAESTRA_SKU M
		ON V.SKU = M.SKU
	LEFT JOIN (
			SELECT Codigo SKU, Division DIVISION, Surtido, Sala LOCAL
			FROM [NUEVO_SUGERIDO_FFVV].[dbo].[NSFFVV_SURTIDO_TIENDA]
			WHERE Surtido = 1
	) S
		ON S.LOCAL = V.COD_LOCAL
		AND S.SKU = V.SKU
	WHERE M.DIVISION LIKE 'J04%'
	GROUP BY 
		V.COD_LOCAL,
		M.SUBCLASE,
		DATEPART(WEEKDAY, DIA),
		SEMANA,
		M.ESTADO,
		CASE WHEN S.SKU IS NULL AND S.LOCAL IS NULL THEN 0 ELSE 1 END