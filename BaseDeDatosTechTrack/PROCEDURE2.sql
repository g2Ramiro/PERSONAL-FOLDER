CREATE PROCEDURE AltaProductoSucursal
    @Id_Sucursal INT,
    @Id_Producto INT,
    @Stock       INT
AS
BEGIN
 --Verificar que la sucursal exista
    IF NOT EXISTS (
        SELECT 1
          FROM Sucursal
         WHERE IdSucursal = @Id_Sucursal
    )
    BEGIN
        RAISERROR(
          'ERROR: No existe la sucursal con Id = %d.',
          16, 1,
          @Id_Sucursal
        )
        RETURN
    END

--Verificar que el producto exista
    IF NOT EXISTS (
        SELECT 1
          FROM Producto
         WHERE IdProducto = @Id_Producto
    )
    BEGIN
        RAISERROR(
          'ERROR: No existe el producto con Id = %d.',
          16, 1,
          @Id_Producto
        )
        RETURN
    END

 --Si ya hay registro, actualizar stock; si no, insertar nuevo
    IF EXISTS (
        SELECT 1
          FROM Sucursal_Producto
         WHERE Id_Sucursal = @Id_Sucursal
           AND Id_Producto = @Id_Producto
    )
    BEGIN
        UPDATE Sucursal_Producto
           SET Stock = Stock + @Stock
         WHERE Id_Sucursal = @Id_Sucursal
           AND Id_Producto = @Id_Producto;
    END
    ELSE
    BEGIN
        INSERT INTO Sucursal_Producto
            (Id_Sucursal, Id_Producto, Stock)
        VALUES
            (@Id_Sucursal, @Id_Producto, @Stock)
    END
--Devolver nombre de sucursal, nombre de producto y stock total
    SELECT 
        s.Nombre      AS NombreSucursal,
        p.Nombre      AS NombreProducto,
        sp.Stock      AS StockTotal
    FROM Sucursal_Producto AS sp
    JOIN Sucursal           AS s
      ON sp.Id_Sucursal = s.IdSucursal
    JOIN dbo.Producto           AS p
      ON sp.Id_Producto = p.IdProducto
    WHERE sp.Id_Sucursal = @Id_Sucursal
      AND sp.Id_Producto = @Id_Producto;
END
GO
