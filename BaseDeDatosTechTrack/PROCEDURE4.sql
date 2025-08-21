ALTER PROCEDURE Finalizar_OrdenReabastecimiento
    @IdOrden INT
AS
BEGIN
    -- Validar que la orden exista
    IF NOT EXISTS (
        SELECT 1 
          FROM Orden_Reabastecimiento 
         WHERE Id_Orden = @IdOrden
    )
    BEGIN
        RAISERROR('ERROR: No existe la orden con Id = %d.', 16, 1, @IdOrden)
        RETURN;
    END

    -- Actualizar estado a 'Finalizada'
    UPDATE Orden_Reabastecimiento
       SET Estado = 'Finalizada'
     WHERE Id_Orden = @IdOrden;

    -- Devolver la información completa de la orden
    SELECT
        orr.Id_Orden,
        s.Nombre                     AS NombreSucursal,
        orr.FechaCreacion,
        e.Nombre + ' ' + e.Apellido AS NombreEmpleado,
        pr.Nombre                   AS NombreProveedor,
        p.Nombre                    AS NombreProducto,
        op.Cantidad,
        orr.Comentarios,
        orr.Estado
    FROM Orden_Reabastecimiento AS orr
    JOIN Sucursal           AS s  ON orr.Id_Sucursal_FK  = s.IdSucursal
    JOIN Empleado           AS e  ON orr.Id_Empleado_FK  = e.Id_Empleado
    JOIN Proveedor          AS pr ON orr.Id_Proveedor_FK = pr.Id_Proveedor
    JOIN Orden_Producto     AS op ON orr.Id_Orden        = op.Id_Orden
    JOIN Producto           AS p  ON op.Id_Producto      = p.IdProducto
    WHERE orr.Id_Orden = @IdOrden;
END
GO
