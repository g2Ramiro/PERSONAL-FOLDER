use TechTrack
go
 
 --Prueba PROCEDURE 1
 EXECUTE Alta_ModeloProducto
    @NombreModelo = 'Serie B200',
    @IdCategoria  = 3,
    @IdMarca      = 4,
    @NombreProd   = 'B200 Standard',
    @Descripcion  = 'Edición estándar B200',
    @Precio       = 199.50;

	--Prueba PROCEDURE 2
EXECUTE AltaProductoSucursal
  @Id_Sucursal = 1,
  @Id_Producto = 5,
  @Stock       = 100;

  --Prueba PROCEDURE 3
EXECUTE Alta_OrdenReabastecimiento
    @Fecha        = '2025-05-10',
    @Id_Sucursal  = 1,
    @Id_Empleado  = 2,
    @Id_Proveedor = 3,
    @Id_Producto  = 4,
    @Cantidad     = 2,
	@Prioridad    ='Sin Prioridad',
	@Comentarios  ='Sin Comentarios',
	@Estado = 'Pendiente'

--Prueba PROCEDURE 4
	EXECUTE Finalizar_OrdenReabastecimiento @IdOrden = 14


--Prueba PROCEDURE 5
	EXECUTE Baja_Proveedor @IdProveedor= 9
   
