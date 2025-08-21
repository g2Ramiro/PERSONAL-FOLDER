--1
create PROCEDURE Alta_ModeloProducto
    @NombreModelo  VARCHAR(100),
    @IdCategoria   INT,
    @IdMarca       INT,
    @NombreProd    VARCHAR(100),
    @Descripcion   VARCHAR(200),
    @Precio        MONEY
AS
BEGIN
    -- 1) Validar existencia de Categoria
    IF NOT EXISTS (
        SELECT 1 FROM dbo.Categoria 
         WHERE Id_Categoria = @IdCategoria
    )
        THROW 50080, 'Categoría no existe.', 1

    -- 2) Validar existencia de Marca
    IF NOT EXISTS (
        SELECT 1 FROM dbo.Marca 
         WHERE Id_Marca = @IdMarca
    )
        THROW 50081, 'Marca no existe.', 1

    -- 3) Verificar duplicado de Modelo
    IF EXISTS (
        SELECT 1 FROM dbo.Modelo
         WHERE Nombre_Modelo   = @NombreModelo
           AND Id_Categoria_FK = @IdCategoria
           AND Id_Marca_FK     = @IdMarca
    )
        THROW 50082, 'Modelo ya existe.', 1

    -- 4) Generar y asignar nuevo Id_Modelo
    DECLARE @NuevoModelo INT = ISNULL(
        (SELECT MAX(Id_Modelo) FROM dbo.Modelo), 
        0
    ) + 1;
    INSERT INTO Modelo
        (Id_Modelo, Especificaciones,Nombre_Modelo, Id_Categoria_FK, Id_Marca_FK)
    VALUES
        (@NuevoModelo,@Descripcion ,@NombreModelo, @IdCategoria, @IdMarca)

    -- 6) Verificar duplicado de Producto
    IF EXISTS (
        SELECT 1 FROM dbo.Producto
         WHERE Nombre       = @NombreProd
           AND Id_Modelo_FK = @NuevoModelo
    )
        THROW 50083, 'Producto ya existe para este modelo.', 1

    -- 7) Generar y asignar nuevo IdProductos
    DECLARE @NuevoProducto INT = ISNULL(
        (SELECT MAX(IdProducto) FROM Producto),
        0
    ) + 1;

    -- 8) Insertar Producto con PK manual
    INSERT INTO Producto
        (IdProducto, Nombre, Descripcion, Precio, Id_Modelo_FK)
    VALUES
        (@NuevoProducto, @NombreProd, @Descripcion, @Precio, @NuevoModelo);

    -- 9) Devolver registros creados
    SELECT
        m.Id_Modelo   ,   
        m.Nombre_Modelo , 
        p.IdProducto  ,
        p.Nombre        ,
        p.Precio
    FROM dbo.Modelo   AS m
    JOIN dbo.Producto AS p
      ON p.Id_Modelo_FK = m.Id_Modelo
    WHERE m.Id_Modelo  = @NuevoModelo
      AND p.IdProducto = @NuevoProducto;
END
GO
