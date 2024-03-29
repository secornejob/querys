-- SE EJECUTA EN SERVIDOR CTRL DESARROLLO
-- JOB RESUMEN_INSTOCK_CTRL_DESARROLLO


INSERT INTO [Control_Desarrollo].[dbo].[RESUMEN_SEMANAL_INSTOCK]
           ([CUADRO_RESUMEN]
           ,[SEMANA]
           ,[INSTOCK])

SELECT *
FROM (SELECT 'TOP500' AS CUADRO_RESUMEN
        ,SEMANA
        ,CONVERT(NUMERIC(12,1),SUM([NUM_OH_VALORIZADO])/nullif(SUM([NUM_VTA_SEM_X_PERFIL]),0)*100)		AS INSTOCK
         FROM  [10.195.254.201].[INFORMES3].[dbo].[INSTOCK_NUEVA_PLANILLA_RESUMEN_SEMANA] 
        
         WHERE TOP_500='TOP500' AND SEMANA= (CASE WHEN DATEPART(ww,GETDATE()-7)<10 THEN (select ''+CAST(DATEPART(YYYY,GETDATE()-7) AS NVARCHAR(MAX))+'0'+CAST(DATEPART(ww,GETDATE()-7) AS NVARCHAR(MAX))+'')
										ELSE (select ''+CAST(DATEPART(YYYY,GETDATE()-7) AS NVARCHAR(MAX))+''+CAST(DATEPART(ww,GETDATE()-7) AS NVARCHAR(MAX))+'') END )
group by SEMANA

union all

SELECT 'TOP2100' AS CUADRO_RESUMEN
        ,SEMANA
        ,CONVERT(NUMERIC(12,1),SUM([NUM_OH_VALORIZADO])/nullif(SUM([NUM_VTA_SEM_X_PERFIL]),0)*100)		AS INSTOCK
         FROM  [10.195.254.201].[INFORMES3].[dbo].[INSTOCK_NUEVA_PLANILLA_RESUMEN_SEMANA] 
        
         WHERE TOP_2100='TOP2100' AND SEMANA= (CASE WHEN DATEPART(ww,GETDATE()-7)<10 THEN (select ''+CAST(DATEPART(YYYY,GETDATE()-7) AS NVARCHAR(MAX))+'0'+CAST(DATEPART(ww,GETDATE()-7) AS NVARCHAR(MAX))+'')
										ELSE (select ''+CAST(DATEPART(YYYY,GETDATE()-7) AS NVARCHAR(MAX))+''+CAST(DATEPART(ww,GETDATE()-7) AS NVARCHAR(MAX))+'') END )
group by SEMANA

union all 

SELECT 'CIA' AS CUADRO_RESUMEN
        ,SEMANA
        ,CONVERT(NUMERIC(12,1),SUM([NUM_OH_VALORIZADO])/nullif(SUM([NUM_VTA_SEM_X_PERFIL]),0)*100)		AS INSTOCK
         FROM  [10.195.254.201].[INFORMES3].[dbo].[INSTOCK_NUEVA_PLANILLA_RESUMEN_SEMANA] 
        
         WHERE SEMANA= (CASE WHEN DATEPART(ww,GETDATE()-7)<10 THEN (select ''+CAST(DATEPART(YYYY,GETDATE()-7) AS NVARCHAR(MAX))+'0'+CAST(DATEPART(ww,GETDATE()-7) AS NVARCHAR(MAX))+'')
										ELSE (select ''+CAST(DATEPART(YYYY,GETDATE()-7) AS NVARCHAR(MAX))+''+CAST(DATEPART(ww,GETDATE()-7) AS NVARCHAR(MAX))+'') END )
group by SEMANA

union all 

SELECT 'MMPP' AS CUADRO_RESUMEN
        ,SEMANA
        ,CONVERT(NUMERIC(12,1),SUM([NUM_OH_VALORIZADO])/nullif(SUM([NUM_VTA_SEM_X_PERFIL]),0)*100)		AS INSTOCK
         FROM  [10.195.254.201].[INFORMES3].[dbo].[INSTOCK_NUEVA_PLANILLA_RESUMEN_SEMANA] 
        
         WHERE MMPP='MMPP' AND SEMANA= (CASE WHEN DATEPART(ww,GETDATE()-7)<10 THEN (select ''+CAST(DATEPART(YYYY,GETDATE()-7) AS NVARCHAR(MAX))+'0'+CAST(DATEPART(ww,GETDATE()-7) AS NVARCHAR(MAX))+'')
										ELSE (select ''+CAST(DATEPART(YYYY,GETDATE()-7) AS NVARCHAR(MAX))+''+CAST(DATEPART(ww,GETDATE()-7) AS NVARCHAR(MAX))+'') END )
group by SEMANA) AS T