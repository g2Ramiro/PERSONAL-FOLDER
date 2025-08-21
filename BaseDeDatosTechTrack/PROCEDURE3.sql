--PROCEDURE 3
ALTER PROCEDURE Alta_OrdenReabastecimiento
    @Fecha        DATETIME,  
    @Id_Sucursal  INT,       
    @Id_Empleado  INT,       
    @Id_Proveedor INT,       
    @Id_Producto  INT,       
    @Cantidad     INT,
	@Prioridad    VARCHAR(10),
	@Comentarios  VARCHAR(20),
	@Estado VARCHAR(10)
	
AS
BEGIN
 --Validar que la sucursal exista
    IF NOT EXISTS (
        SELECT 1 
          FROM Sucursal 
         WHERE IdSucursal = @Id_Sucursal
    )
    BEGIN
        RAISERROR('ERROR: No existe la sucursal con Id = %d.', 16, 1, @Id_Sucursal)
        RETURN
    END

 --Validar que el empleado exista
    IF NOT EXISTS (
        SELECT 1 
          FROM Empleado 
         WHERE Id_Empleado = @Id_Empleado
    )
    BEGIN
        RAISERROR('ERROR: No existe el empleado con Id = %d.', 16, 1, @Id_Empleado)
        RETURN;
    END

 --Validar que el proveedor exista
    IF NOT EXISTS (
        SELECT 1 
          FROM Proveedor 
         WHERE Id_Proveedor = @Id_Proveedor
    )
    BEGIN
        RAISERROR('ERROR: No existe el proveedor con Id = %d.', 16, 1, @Id_Proveedor)
        RETURN;
    END
    DECLARE @NuevoOrden INT = ISNULL(
        (SELECT MAX(Id_Orden) FROM dbo.Orden_Reabastecimiento),
        0
    ) + 1

 -- 3) Insertar cabecera de orden de reabastecimiento
    INSERT INTO Orden_Reabastecimiento
        (Id_Orden, FechaCreacion, Id_Sucursal_FK, Id_Empleado_FK, Id_Proveedor_FK,	Prioridad,
	Comentarios, Estado)
    VALUES
        (@NuevoOrden, @Fecha, @Id_Sucursal, @Id_Empleado, @Id_Proveedor,	@Prioridad   ,
	@Comentarios  ,
	@Estado)

 -- 4) Validar que el producto exista
    IF NOT EXISTS (
        SELECT 1 
          FROM Producto 
         WHERE IdProducto = @Id_Producto
    )
    BEGIN
        RAISERROR('ERROR: No existe el producto con Id = %d.', 16, 1, @Id_Producto)
        RETURN;
    END

 -- 5) Insertar detalle de la orden (Orden_Producto)
    INSERT INTO Orden_Producto
        (Id_Orden, Id_Producto, Cantidad)
    VALUES
        (@NuevoOrden, @Id_Producto, @Cantidad)

 -- 6) Devolver información de la orden y su detalle con nombres
    SELECT
		orr.Id_Orden,
        s.Nombre                     AS NombreSucursal,
        orr.FechaCreacion,
        e.Nombre + ' ' + e.Apellido  AS NombreEmpleado,
        pr.Nombre                    AS NombreProveedor,
        p.Nombre                     AS NombreProducto,
        op.Cantidad
    FROM Orden_Reabastecimiento AS orr
    JOIN Sucursal            AS s   ON orr.Id_Sucursal_FK = s.IdSucursal
    JOIN Empleado            AS e   ON orr.Id_Empleado_FK  = e.Id_Empleado
    JOIN Proveedor           AS pr  ON orr.Id_Proveedor_FK = pr.Id_Proveedor
    JOIN Orden_Producto      AS op  ON orr.Id_Orden        = op.Id_Orden
    JOIN Producto            AS p   ON op.Id_Producto      = p.IdProducto
    WHERE orr.Id_Orden = @NuevoOrden;
END
GO
