--Query1
SELECT
    P.Nombre AS NombreProducto,
    Mo.Nombre_Modelo AS NombreModelo,
    P.Precio
FROM
    Producto AS P
JOIN
    Modelo AS Mo ON P.Id_Modelo_FK = Mo.Id_Modelo
JOIN
    Marca AS Ma ON Mo.Id_Marca_FK = Ma.Id_Marca
JOIN
    Categoria AS C ON Mo.Id_Categoria_FK = C.Id_Categoria
WHERE
    Ma.Nombre_Categoria = 'Apple'
    AND C.Nombre = 'Celulares'
    AND P.Precio > 20000.00;

--Query2
SELECT
    O.Id_Orden AS IDOrden,
    O.FechaCreacion AS FechaCreacion,
    Prov.Nombre AS NombreProv,
    Emp.Nombre AS NombreEmp,
    Emp.Apellido AS ApellidoEmp
FROM
    Orden_Reabastecimiento AS O
JOIN
    Sucursal AS S ON O.Id_Sucursal_FK = S.IdSucursal
JOIN
    Proveedor AS Prov ON O.Id_Proveedor_FK = Prov.Id_Proveedor
JOIN
    Empleado AS Emp ON O.Id_Empleado_FK = Emp.Id_Empleado
WHERE
    O.Estado = 'Pendiente'
    AND O.Prioridad = 'Alta'
    AND S.Nombre = 'Sucursal Andares';

--Query3
SELECT
    E.Nombre AS NombreEmpleado,
    E.Apellido AS ApellidoEmpleado,
    E.Puesto,
    E.Salario,
    G.Nivel_Gerencial,
    S.Nombre AS NombreSucursal
FROM
    Empleado AS E
JOIN
    Gerente AS G ON E.Id_Empleado = G.Id_Empleado
JOIN
    Sucursal AS S ON E.Id_Sucursal_FK = S.IdSucursal
WHERE
    G.Nivel_Gerencial = 'Senior'
    AND E.Salario > 25000.00
    AND E.Puesto = 'Gerente';

--Query4
SELECT
    P.Nombre AS NombreProd,
    Ma.Nombre_Categoria AS NombreMarca,
    C.Nombre AS NombreCat,
    P.Precio AS PrecioProd
FROM
    Producto AS P
JOIN
    Modelo AS Mo ON P.Id_Modelo_FK = Mo.Id_Modelo
JOIN
    Marca AS Ma ON Mo.Id_Marca_FK = Ma.Id_Marca
JOIN
    Categoria AS C ON Mo.Id_Categoria_FK = C.Id_Categoria
WHERE
    (Ma.Nombre_Categoria = 'ASUS' OR Ma.Nombre_Categoria = 'MSI')
    AND (C.Nombre = 'Tarjetas Gráficas' OR C.Nombre = 'Tarjetas Madre')
    AND P.Precio < 10000.00;

--Query5
SELECT
    Prod.Nombre AS NombreProducto,
    OP.Cantidad AS CantidadOrdenada,
    O.FechaCreacion AS FechaOrden,
    Suc.Nombre AS NombreSucursalDestino
FROM
    Orden_Producto AS OP
JOIN
    Producto AS Prod ON OP.Id_Producto = Prod.IdProducto
JOIN
    Orden_Reabastecimiento AS O ON OP.Id_Orden = O.Id_Orden
JOIN
    Empleado AS Emp ON O.Id_Empleado_FK = Emp.Id_Empleado
JOIN
    Sucursal AS Suc ON O.Id_Sucursal_FK = Suc.IdSucursal
WHERE
    O.Estado = 'Completada'
    AND Emp.Puesto = 'Gerente'
    AND O.Prioridad = 'Media';

