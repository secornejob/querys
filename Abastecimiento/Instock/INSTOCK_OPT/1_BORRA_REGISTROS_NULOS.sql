DELETE FROM [INSTOCK_OPT].[dbo].[INSTOCK_OPT_BASE]
WHERE 
	NUM_OH_VALORIZADO IS NULL
	AND NUM_VTA_SEM_X_PERFIL IS NULL
	AND VTA_PERDIDA_VP IS NULL
	AND CANTIDAD_SKUS IS NULL