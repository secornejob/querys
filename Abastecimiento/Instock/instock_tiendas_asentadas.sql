-- Insert rows into table 'TableName'
/* 
INSERT INTO [INFORMES3].[dbo].[TIENDAS_ASENTADAS]
([COD_LOCAL])
VALUES (499), (203), (205), (202), (206), (105), (129), (107), (207) 
*/

-- INSERT INTO [INFORMES3].[dbo].[TIENDAS_ASENTADAS_HISTORIA]

-- SELECT 
-- 	COD_LOCAL,
-- 	CONVERT(DATE, GETDATE()) FECHA
-- -- INTO [INFORMES3].[dbo].[TIENDAS_ASENTADAS_HISTORIA]
-- FROM [INFORMES3].[dbo].[TIENDAS_ASENTADAS]
-- WHERE COD_LOCAL NOT IN (115, 212, 503)
-- ORDER BY 1


-- INSERT INTO [INFORMES3].[dbo].[TIENDAS_ASENTADAS_HISTORIA]
-- SELECT *, CONVERT(DATE, GETDATE())
-- FROM [INFORMES3].[dbo].[TIENDAS_ASENTADAS]
-- WHERE COD_LOCAL NOT IN (115, 212, 503)

SELECT COD_LOCAL, FECHA, COUNT(COD_LOCAL) CUENTA
FROM [INFORMES3].[dbo].[TIENDAS_ASENTADAS_HISTORIA]
GROUP BY  COD_LOCAL, FECHA