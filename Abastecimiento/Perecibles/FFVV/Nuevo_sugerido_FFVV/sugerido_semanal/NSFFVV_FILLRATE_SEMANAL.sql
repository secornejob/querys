
TRUNCATE TABLE NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_FILLRATE_SEMANAL
INSERT INTO NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_FILLRATE_SEMANAL
--?? SELECT * FROM NUEVO_SUGERIDO_FFVV.dbo.NSFFVV_FILLRATE_SEMANAL

	SELECT 
		[SEMANA]
		,SUBCLASE
		,SUM(CAJAS_SOLICITADAS) CAJAS_SOLICITADAS
		,SUM(CAJAS_RECIBIDAS) CAJAS_RECIBIDAS
		,100 * CONVERT(NUMERIC(18,4), CONVERT(NUMERIC(18,2), SUM(CAJAS_RECIBIDAS)) / CONVERT(NUMERIC(18, 2), SUM(CAJAS_SOLICITADAS))) FILLRATE
	FROM (
		SELECT 
			[SEMANA]
			,[DESC_PROV]
			,B.SUBCLASE
			,A.[SKU]      
			,ISNULL(CONVERT(INTEGER, NULLIF([UN_SOLICI], 0) / NULLIF(A.CASE_PACK, 0)), 0) AS CAJAS_SOLICITADAS
			,ISNULL(CONVERT(INTEGER, NULLIF([UN_RECIBI], 0) / NULLIF(A.CASE_PACK, 0)), 0) AS CAJAS_RECIBIDAS
		FROM [INFORMES3].[dbo].[DHW_FILLRATE] A 
		LEFT JOIN [RepNonFood].dbo.MAESTRA_SKU B 
			ON B.SKU = A.SKU
		WHERE B.SUBCLASE LIKE 'J04%'
			AND SEMANA BETWEEN (SELECT DISTINCT SEMANA FROM [INFORMES3].[dbo].[DHW_MES_GC] WHERE FECHA = CONVERT(DATE, GETDATE() - 28))
				AND (SELECT DISTINCT SEMANA FROM [INFORMES3].[dbo].[DHW_MES_GC] WHERE FECHA = CONVERT(DATE, GETDATE() - 7))
	) T
	GROUP BY [SEMANA], SUBCLASE