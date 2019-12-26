DECLARE @nombre_dia TABLE (
	id INT,
	dia VARCHAR(10)
)

INSERT INTO @nombre_dia (id, dia)
VALUES (1, 'Lunes'), (2, 'Martes'), (3, 'Miercoles'), (4, 'Jueves'), (5, 'Viernes'), (6, 'Sabado'), (7, 'Domingo')


	SELECT 
		F.[PLAN],
		'VENTA' [TIPO],
		V.ID_SEMANACANALISIS SEMANA,
		V.ID_DIAANALISIS FECHA,
		DATEPART(DW, V.ID_DIAANALISIS) DIA_SEMANA,
		D.dia DIA,
		DATEPART(WW, V.ID_DIAANALISIS) NUM_SEMANA,
		DATEPART(YY, V.ID_DIAANALISIS) AÑO,
		M.PROCEDENCIA,
		SUM(V.WJXBFS1) VENTA_SI,
		SUM(V.WJXBFS2) COSTO,
		SUM(V.WJXBFS3) UNIDADES,
		NULL COSTO_INV_DISP,
		NULL UN_INV_DISP,
		CASE 
			WHEN V.ID_SEMANACANALISIS BETWEEN F.INICIO AND F.TERMINO THEN 'ACTUAL'
			WHEN V.ID_SEMANACANALISIS BETWEEN F.INICIO-100 AND F.TERMINO-100 THEN 'ANTERIOR'
		END AS PERIODO
	FROM [RepNonFood].[dbo].[SEGUIMIENTO_PLAN_FILTROS] F
	LEFT JOIN [RepNonFood].[dbo].[AA_PRECIO_VTA_2] V
		ON F.CLASES = V.CUSTCOL_4
	LEFT JOIN [RepNonFood].[dbo].[MAESTRA_SKU] M
		ON V.CUSTCOL_7 = M.SKU
	LEFT JOIN @nombre_dia D
		ON D.id = CONVERT(INT, DATEPART(DW, V.ID_DIAANALISIS))
	WHERE (
		V.ID_SEMANACANALISIS BETWEEN F.INICIO AND F.TERMINO
		OR V.ID_SEMANACANALISIS BETWEEN F.INICIO-100 AND F.TERMINO-100
	)
	GROUP BY
		F.[PLAN],
		V.ID_DIAANALISIS,
		V.ID_SEMANACANALISIS,
		M.PROCEDENCIA,
		D.dia,
		F.INICIO,
		F.TERMINO

	UNION

	SELECT
		F.[PLAN],
		'INVENTARIO' [TIPO],
		DATEPART(YY, OH.FECHA) * 100 + DATEPART(WW, OH.FECHA) SEMANA,
		OH.FECHA,
		DATEPART(DW, OH.FECHA) DIA_SEMANA,
		D.dia DIA,
		DATEPART(WW, OH.FECHA) NUM_SEMANA,
		DATEPART(YY, OH.FECHA) AÑO,
		OH.PROCEDENCIA,
		NULL VENTA_SI,
		NULL COSTO,
		NULL UNIDADES,
		SUM(COSTO_INV_DISP_HOY) COSTO_INV_DISP,
		SUM(UN_INV_DISP_HOY) UN_INV_DISP,
		CASE 
			WHEN DATEPART(YY, OH.FECHA)*100 + DATEPART(WW, OH.FECHA) BETWEEN F.INICIO AND F.TERMINO THEN 'ACTUAL'
			WHEN DATEPART(YY, OH.FECHA)*100 + DATEPART(WW, OH.FECHA) BETWEEN F.INICIO-100 AND F.TERMINO-100 THEN 'ANTERIOR'
		END AS PERIODO
	FROM [RepNonFood].[dbo].[SEGUIMIENTO_PLAN_FILTROS] F
	LEFT JOIN [RepNonFood].[dbo].[SEGUIMIENTO_PLAN_HISTORIA_OH] OH
		ON F.CLASES = OH.CLASE
	LEFT JOIN @nombre_dia D
		ON D.id = CONVERT(INT, DATEPART(DW, OH.FECHA))
	WHERE (
		DATEPART(YY, OH.FECHA)*100 + DATEPART(WW, OH.FECHA) BETWEEN F.INICIO AND F.TERMINO
		OR DATEPART(YY, OH.FECHA)*100 + DATEPART(WW, OH.FECHA) BETWEEN F.INICIO-100 AND F.TERMINO-100
	)
	GROUP BY
		F.[PLAN],
		OH.FECHA,
		D.dia,
		OH.PROCEDENCIA,
		F.INICIO,
		F.TERMINO

	UNION

	SELECT 
		[PLAN],
		'PLAN' [TIPO],
		[SEMANA],
		NULL FECHA,
		NUMERO_DIA,
		D.dia DIA,
		CONVERT(INT, RIGHT(SEMANA, 2)) NUM_SEMANA,
		CONVERT(INT, LEFT(SEMANA, 4)) AÑO,
		PROCEDENCIA,
		SUM([MONTO VENTA SI]) VENTA_SI,
		SUM([COSTO VENTA]) COSTO,
		NULL UNIDADES,
		NULL COSTO_INV_DISP,
		NULL UN_INV_DISP,
		'ACTUAL' AS PERIODO
	FROM [RepNonFood].[dbo].[SEGUIMIENTO_PLAN_DETALLE] S
	LEFT JOIN @nombre_dia D
		ON d.id = CONVERT(INT, S.NUMERO_DIA)
	GROUP BY
		[PLAN],
		[SEMANA],
		[NUMERO_DIA],
		[PROCEDENCIA],
		D.dia



-- SELECT DISTINCT
-- 	DIVISION,
-- 	DEPARTAMENTO,
-- 	SUBDEPARTAMENTO,
-- 	CLASE
-- FROM [RepNonFood].[dbo].[MAESTRA_SKU]
-- WHERE 
-- 	SUBDEPARTAMENTO LIKE 'J090103%'
-- 	OR SUBDEPARTAMENTO LIKE 'J090102%'



-- SELECT
-- 	ID_DIAANALISIS,
-- 	-- CUSTCOL_4 CLASE,
-- 	SUM(WJXBFS1) VENTA_SI,
-- 	SUM(WJXBFS2) COSTO,
-- 	SUM(WJXBFS3) UNIDADES
-- FROM [RepNonFood].[dbo].[AA_PRECIO_VTA_2]
-- -- WHERE DATEPART(MM, ID_DIAANALISIS) = 2
-- -- 	AND DATEPART(YY, ID_DIAANALISIS) = 2019
-- -- 	AND CUSTCOL_4 LIKE 'J08%'
-- GROUP BY 
-- 	ID_DIAANALISIS
-- 	-- CUSTCOL_4
-- ORDER BY ID_DIAANALISIS ASC


-- SELECT *
-- FROM [RepNonFood].[dbo].[SEGUIMIENTO_PLAN_HISTORIA_OH]