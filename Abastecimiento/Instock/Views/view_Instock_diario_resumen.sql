SELECT 
	CONVERT(DATE, FECHA_ACTUALIZ) AS FECHA_ACTUALIZ, 
	'COMPAÑÍA' AS [Cuadro Resumen], 
	CONVERT(NUMERIC(12, 1), SUM([NUM_OH_VALORIZADO])/NULLIF (SUM([NUM_VTA_SEM_X_PERFIL]), 0) * 100) AS INSTOCK
FROM [INFORMES3].[dbo].[INSTOCK_NUEVA_PLANILLA]
WHERE ((DIVISION IN ('J01 - PGC COMESTIBLE') 
	AND SIS_REPOSICION IN ('Reposicion x ASR', 'Informar a ASR')) 
	OR (DIVISION IN ('J02 - PGC NO COMESTIBLE') AND SIS_REPOSICION IN ('Reposicion x ASR')) 
	OR (DIVISION IN ('J05 - FLC', 'J06 - PANADERIA Y PASTELERIA', 'J07 - PLATOS PREPARADOS') 
	AND SIS_REPOSICION IN ('Reposicion x ASR')))
	AND COD_LOCAL NOT IN (209, 203, 205, 202, 206, 105, 129, 107, 207)
GROUP BY CONVERT(DATE, FECHA_ACTUALIZ)
UNION
SELECT CONVERT(DATE, FECHA_ACTUALIZ) AS FECHA_ACTUALIZ, 'TOP500' AS [Cuadro Resumen], 
     CONVERT(NUMERIC(12, 1), SUM([NUM_OH_VALORIZADO]) 
     / NULLIF (SUM([NUM_VTA_SEM_X_PERFIL]), 0) * 100) AS INSTOCK
FROM [INFORMES3].[dbo].[INSTOCK_NUEVA_PLANILLA]
WHERE TOP_500 = 'TOP500' AND COD_LOCAL NOT IN (209, 203, 205, 202, 206, 105, 129, 107, 207)
GROUP BY CONVERT(DATE, FECHA_ACTUALIZ)
UNION
SELECT CONVERT(DATE, FECHA_ACTUALIZ) AS FECHA_ACTUALIZ, 'TOP2100' AS [Cuadro Resumen], 
     CONVERT(NUMERIC(12, 1), SUM([NUM_OH_VALORIZADO]) 
     / NULLIF (SUM([NUM_VTA_SEM_X_PERFIL]), 0) * 100) AS INSTOCK
FROM [INFORMES3].[dbo].[INSTOCK_NUEVA_PLANILLA]
WHERE TOP_2100 = 'TOP2100' AND COD_LOCAL NOT IN (209, 203, 205, 202, 206, 105, 129, 107, 207)
GROUP BY CONVERT(DATE, FECHA_ACTUALIZ)
UNION
SELECT CONVERT(DATE, FECHA_ACTUALIZ) AS FECHA_ACTUALIZ, 'PGC' AS [Cuadro Resumen], 
     CONVERT(NUMERIC(12, 1), SUM([NUM_OH_VALORIZADO]) 
     / NULLIF (SUM([NUM_VTA_SEM_X_PERFIL]), 0) * 100) AS INSTOCK
FROM [INFORMES3].[dbo].[INSTOCK_NUEVA_PLANILLA]
WHERE ((DIVISION IN ('J01 - PGC COMESTIBLE') AND SIS_REPOSICION IN ('Reposicion x ASR', 
     'Informar a ASR')) OR
     (DIVISION IN ('J02 - PGC NO COMESTIBLE') AND SIS_REPOSICION IN ('Reposicion x ASR'))) AND 
     COD_LOCAL NOT IN (209, 203, 205, 202, 206, 105, 129, 107, 207)
GROUP BY CONVERT(DATE, FECHA_ACTUALIZ)
UNION
SELECT CONVERT(DATE, FECHA_ACTUALIZ) AS FECHA_ACTUALIZ, 'PERECIBLES' AS [Cuadro Resumen], 
     CONVERT(NUMERIC(12, 1), SUM([NUM_OH_VALORIZADO]) 
     / NULLIF (SUM([NUM_VTA_SEM_X_PERFIL]), 0) * 100) AS INSTOCK
FROM [INFORMES3].[dbo].[INSTOCK_NUEVA_PLANILLA]
WHERE DIVISION IN ('J05 - FLC', 'J06 - PANADERIA Y PASTELERIA', 'J07 - PLATOS PREPARADOS') AND 
     SIS_REPOSICION IN ('Reposicion x ASR') AND COD_LOCAL NOT IN (209, 203, 205, 202, 206, 105, 
     129, 107, 207)
GROUP BY CONVERT(DATE, FECHA_ACTUALIZ)
UNION
SELECT CONVERT(DATE, FECHA_ACTUALIZ) AS FECHA_ACTUALIZ, 'MMPP' AS [Cuadro Resumen], 
     CONVERT(NUMERIC(12, 1), SUM([NUM_OH_VALORIZADO]) 
     / NULLIF (SUM([NUM_VTA_SEM_X_PERFIL]), 0) * 100) AS INSTOCK
FROM [INFORMES3].[dbo].[INSTOCK_NUEVA_PLANILLA]
WHERE MMPP = 'MMPP' AND COD_LOCAL NOT IN (209, 203, 205, 202, 206, 105, 129, 107, 207)
GROUP BY CONVERT(DATE, FECHA_ACTUALIZ)
UNION
SELECT CONVERT(DATE, FECHA_ACTUALIZ) AS FECHA_ACTUALIZ, 'IMPORTADOS' AS [Cuadro Resumen], 
     CONVERT(NUMERIC(12, 1), SUM([NUM_OH_VALORIZADO]) 
     / NULLIF (SUM([NUM_VTA_SEM_X_PERFIL]), 0) * 100) AS INSTOCK
FROM [INFORMES3].[dbo].[INSTOCK_NUEVA_PLANILLA]
WHERE PROCEDENCIA = 'IMPORTADO' AND COD_LOCAL NOT IN (209, 203, 205, 202, 206, 105, 129, 107, 
     207)
GROUP BY CONVERT(DATE, FECHA_ACTUALIZ)
