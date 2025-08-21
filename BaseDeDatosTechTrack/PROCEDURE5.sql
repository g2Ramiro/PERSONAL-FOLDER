CREATE PROCEDURE Baja_Proveedor
    @IdProveedor INT
AS
BEGIN
    -- Verificar que el proveedor exista y obtener sus datos
    IF NOT EXISTS (
        SELECT 1 FROM Proveedor WHERE Id_Proveedor = @IdProveedor
    )
    BEGIN
        RAISERROR('ERROR: No existe el proveedor con Id = %d.', 16, 1, @IdProveedor)
        RETURN;
    END

    -- Validar que no tenga órdenes de reabastecimiento
    IF EXISTS (
        SELECT 1 FROM Orden_Reabastecimiento WHERE Id_Proveedor_FK = @IdProveedor
    )
    BEGIN
        RAISERROR('ERROR: El proveedor tiene órdenes de reabastecimiento asociadas.', 16, 1)
        RETURN;
    END

    -- Validar que no esté asignado a productos
    IF EXISTS (
        SELECT 1 FROM Producto_Proveedor WHERE Id_Proveedor = @IdProveedor
    )
    BEGIN
        RAISERROR('ERROR: El proveedor tiene productos asignados.', 16, 1)
        RETURN;
    END

    -- Obtener datos del proveedor antes de eliminar
    SELECT * 
    INTO #DatosProveedor
    FROM Proveedor
    WHERE Id_Proveedor = @IdProveedor;

    -- Eliminar de Proveedor_Nacional si aplica
    DELETE FROM Proveedor_Nacional WHERE Id_Proveedor = @IdProveedor;

    -- Eliminar de Proveedor_Internacional si aplica
    DELETE FROM Proveedor_Internacional WHERE Id_Proveedor = @IdProveedor;

    -- Eliminar de Proveedor
    DELETE FROM Proveedor WHERE Id_Proveedor = @IdProveedor;

    -- Devolver los datos eliminados
    SELECT * FROM #DatosProveedor;

    -- Eliminar tabla temporal
    DROP TABLE #DatosProveedor;
END
GO
