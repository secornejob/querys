-- INSERT INTO [INFORMES3].[dbo].[MAIL_INSTOCK_SUBDEP_2]

SELECT *
--INTO  [INFORMES3].[dbo].[MAIL_INSTOCK_SUBDEP_2_TOP_DIV]
FROM  [INSTOCK_OPT].[dbo].[MAIL_INSTOCK_SUBDEP_2]
WHERE CONVERT(DATE,FECHA_ACTUALIZ)=CONVERT(DATE,GETDATE())