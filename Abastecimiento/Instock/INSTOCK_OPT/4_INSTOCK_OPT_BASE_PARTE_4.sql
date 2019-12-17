-- TRUNCATE TABLE [INSTOCK_OPT].[dbo].[INSTOCK_OPT_BASE_PARTE_4]

-- INSERT INTO [INSTOCK_OPT].[dbo].[INSTOCK_OPT_BASE_PARTE_4]

SELECT 
	[NOM_PRODUCTO]
	,A.[SKU]
	,[CANTIDAD]
	,[COD_CLASIFICACION_SKU]
	,[ABC_2018]
	,[ABC_CL_2018]
	,[SKU_TOP_TICKET]
	,[SKU_PALLET_READY]
	,[INV_IMPORTADOS]
	,[TOP_2100]
	,[TOP_500]
	,[MMPP]
	,[IND_SURTIDO]
	,[ESTADO]
	,A.[NOM_LOCAL]
	,A.[COD_LOCAL]
	,C.[TIPO] AS [TIPO_TIENDA]
	,C.[NOMBRE_TIPO] AS [NOMBRE_TIPO_TIENDA]
	,[DIVISION]
	,[DEPARTAMENTO]
	,[SUBDEP]
	,[CLASE]
	,[SUBCLASE]
	,[COD_PROV]
	,[NOM_PROV]
	,[RUT]
	,[MARCA]
	,[METOD_ABAST]
	,[COSTO_INV_DISP_HOY]
	,[UN_INV_DISP_HOY]
	,B.[MONTO_VTA]
	,B.[UN_VTA]
	,[INV_NEGATIVO]
	,[NUM_OH_VALORIZADO]
	,CASE
		WHEN [NUM_OH_VALORIZADO] = 0 AND [NUM_VTA_SEM_X_PERFIL] = 0 THEN 0
		WHEN [NUM_VTA_SEM_X_PERFIL] = 0 AND [NUM_OH_VALORIZADO] > 0 THEN 1
		WHEN [NUM_OH_VALORIZADO] < [NUM_VTA_SEM_X_PERFIL] THEN 0
		ELSE 1
	END AS [NUM_OH_BINARIO_]
	,[NUM_VTA_SEM_X_PERFIL]
	,[VTA_PERDIDA_VP]
	,[OH_QUIEBRE]
	,[CANTIDAD_SKUS]
	,[DEMANDA_SEMANAL]
	,[FECHA_ACTUALIZ]
	,[SIS_REPOSICION]
	,[PROCEDENCIA]
	,[RESPONSABLE]
--INTO [INSTOCK_OPT].[dbo].[INSTOCK_OPT_BASE_PARTE_4]
FROM [INSTOCK_OPT].[dbo].[INSTOCK_OPT_BASE_PARTE_3] AS A
	LEFT JOIN [INSTOCK_OPT].dbo.VTA_INSTOCK AS B
		ON B.[SKU] = A.[SKU]
		AND B.[COD_LOCAL] = A.[COD_LOCAL]
	LEFT JOIN [INSTOCK_OPT].dbo.CLUSTERS AS C
		ON C.[TIENDA] = A.[COD_LOCAL]