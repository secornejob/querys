  SELECT 
    T.Desc_Localfisico DESC_LOCAL,
    T.COD_LOCALFISICO COD_LOCAL,
    T.CUSTCOL_1 DIVISION,
    T.CUSTCOL_2 DEPARTAMENTO,
    T.CUSTCOL_3 SUBDEPARTAMENTO,
    T.CUSTCOL_4 CLASE,
    T.CUSTCOL_5 SUBCLASE,
    T.CUSTCOL_7 SKU,
    T.DESC_SKU DESC_PRODUCTO,
    T.RUT_RUC_DEF RUT_PROVEEDOR,
    T.DESC_PROVEEDOR_DEF PROVEEDOR,
    T.ID_MARCA MARCA,
    T.COD_ESTADO ESTADO,
    T.ID_UNIDADMEDIDA UN_MEDIDA,
    T.WJXBFS1 COSTO_VENTA,
    T.WJXBFS2 VENTA_SI,
    T.WJXBFS3 VENTA_UN
  from dssmkpmmcl.venta_j01_j01_201812 T