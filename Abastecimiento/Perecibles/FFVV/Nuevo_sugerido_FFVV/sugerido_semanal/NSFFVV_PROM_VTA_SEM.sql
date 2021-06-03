
TRUNCATE TABLE NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_PROM_VTA_SEM
INSERT INTO NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_PROM_VTA_SEM

	SELECT 
		V.COD_LOCAL,
		V.SKU,
		M.SUBCLASE,
		M.ESTADO,
		CASE WHEN S.SKU IS NULL AND S.LOCAL IS NULL THEN 0 ELSE 1 END IND_SURTIDO,
		avg(VTA) PROM_SIMPLE,
		ISNULL(STDEV(VTA), 0) DESV_EST
	FROM NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_VENTA_SEMANAL V
	LEFT JOIN [10.195.254.201].RepNonFood.dbo.MAESTRA_SKU M
		ON V.SKU = M.SKU
	LEFT JOIN ( 
		SELECT 
			Codigo SKU, 
			Division DIVISION, 
			Surtido, 
			Sala LOCAL
		FROM [NUEVO_SUGERIDO_FFVV].[dbo].[NSFFVV_SURTIDO_TIENDA]
		WHERE Surtido = 1
	) S
		ON S.LOCAL = V.COD_LOCAL
		AND S.SKU = V.SKU
	WHERE M.DIVISION LIKE 'J04%'
	GROUP BY
		V.COD_LOCAL,
		V.SKU,
		M.SUBCLASE,
		M.ESTADO,
		CASE WHEN S.SKU IS NULL AND S.LOCAL IS NULL THEN 0 ELSE 1 END