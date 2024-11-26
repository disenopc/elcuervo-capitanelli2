-- Procedimiento para insertar un nuevo producto
DELIMITER //
CREATE PROCEDURE InsertarProducto(
    IN p_id_factura_compra INT,
    IN p_id_categoria INT,
    IN p_nombre_producto VARCHAR(200),
    IN p_precio DECIMAL(10,2),
    IN p_cantidad INT
)
BEGIN
    INSERT INTO productos (
        id_numero_de_factura_de_compra, 
        id_categoria_de_producto, 
        nombre_producto, 
        precio, 
        cantidad
    ) VALUES (
        p_id_factura_compra, 
        p_id_categoria, 
        p_nombre_producto, 
        p_precio, 
        p_cantidad
    );
    SELECT LAST_INSERT_ID() AS nuevo_producto_id;
END //
DELIMITER ;

-- Procedimiento para registrar una venta
DELIMITER //
CREATE PROCEDURE RegistrarVenta(
    IN p_id_cliente INT,
    IN p_id_vendedor INT,
    IN p_id_categoria INT,
    IN p_nombre_cliente VARCHAR(200),
    IN p_precio_venta DECIMAL(10,2),
    IN p_cantidad INT
)
BEGIN
    DECLARE v_factura_id INT;
    DECLARE v_venta_id INT;

    -- Insertar factura de venta
    INSERT INTO facturas_de_venta (
        nombre_cliente, 
        detalle, 
        monto_bruto, 
        impuestos, 
        monto_neto
    ) VALUES (
        p_nombre_cliente, 
        'Venta de productos', 
        p_precio_venta * p_cantidad, 
        p_precio_venta * p_cantidad * 0.21, 
        p_precio_venta * p_cantidad * 1.21
    );
    SET v_factura_id = LAST_INSERT_ID();

    -- Insertar venta
    INSERT INTO ventas (
        id_cliente, 
        id_vendedor, 
        id_categoria_de_producto, 
        id_num_factura_venta, 
        nombre_cliente, 
        precio_venta, 
        cantidad, 
        total_venta
    ) VALUES (
        p_id_cliente, 
        p_id_vendedor, 
        p_id_categoria, 
        v_factura_id, 
        p_nombre_cliente, 
        p_precio_venta, 
        p_cantidad, 
        p_precio_venta * p_cantidad
    );
    SET v_venta_id = LAST_INSERT_ID();

    -- Retornar IDs de factura y venta
    SELECT v_factura_id AS factura_id, v_venta_id AS venta_id;
END //
DELIMITER ;

-- Procedimiento para registrar un reclamo de postventa
DELIMITER //
CREATE PROCEDURE RegistrarReclamo(
    IN p_id_venta INT,
    IN p_nombre_cliente VARCHAR(200),
    IN p_tipo_reclamo ENUM("PRODUCTO DEFECTUOSO","RETRASO EN ENTREGA","ERROR DE FACTURACION","EXPECTATIVA NO SATISFECHA"),
    IN p_prioridad ENUM("ALTA","MEDIA","BAJA"),
    IN p_respuesta VARCHAR(200)
)
BEGIN
    INSERT INTO postventa (
        id_venta, 
        nombre_cliente, 
        tipo_de_reclamo, 
        estado_del_reclamo, 
        prioridad, 
        respuesta
    ) VALUES (
        p_id_venta, 
        p_nombre_cliente, 
        p_tipo_reclamo, 
        'EN PROGRESO', 
        p_prioridad, 
        p_respuesta
    );
    SELECT LAST_INSERT_ID() AS nuevo_reclamo_id;
END //
DELIMITER ;

-- Procedimiento para actualizar stock de producto
DELIMITER //
CREATE PROCEDURE ActualizarStock(
    IN p_id_producto INT,
    IN p_id_centro_almacenamiento INT,
    IN p_cantidad INT
)
BEGIN
    -- Actualizar stock existente o insertar nuevo registro
    INSERT INTO stock (
        id_producto, 
        id_centro_de_almacenamiento, 
        cantidad_stock
    ) VALUES (
        p_id_producto, 
        p_id_centro_almacenamiento, 
        p_cantidad
    ) ON DUPLICATE KEY UPDATE 
    cantidad_stock = cantidad_stock + p_cantidad;

    -- Actualizar cantidad en tabla de productos
    UPDATE productos 
    SET cantidad = cantidad + p_cantidad 
    WHERE id_producto = p_id_producto;
END //
DELIMITER ;

-- Procedimiento para obtener ventas por vendedor
DELIMITER //
CREATE PROCEDURE ObtenerVentasPorVendedor(
    IN p_id_vendedor INT,
    IN p_fecha_inicio DATETIME,
    IN p_fecha_fin DATETIME
)
BEGIN
    SELECT 
        v.id_vendedor,
        ve.nombre_vendedor,
        COUNT(v.id_venta) AS total_ventas,
        SUM(v.total_venta) AS monto_total_ventas
    FROM ventas v
    JOIN vendedor ve ON v.id_vendedor = ve.id_vendedor
    WHERE v.id_vendedor = p_id_vendedor
    AND v.id_venta IN (
        SELECT id_venta 
        FROM facturas_de_venta 
        WHERE fecha_compra BETWEEN p_fecha_inicio AND p_fecha_fin
    )
    GROUP BY v.id_vendedor, ve.nombre_vendedor;
END //
DELIMITER ;

-- Procedimiento para registrar nueva compra a proveedor
DELIMITER //
CREATE PROCEDURE RegistrarCompraProveedor(
    IN p_nombre_proveedor VARCHAR(200),
    IN p_id_producto INT,
    IN p_id_categoria INT,
    IN p_cantidad INT,
    IN p_precio DECIMAL(10,2),
    IN p_forma_pago ENUM("CONTADO","A 30 DIAS", "A 60 DIAS")
)
BEGIN
    DECLARE v_factura_compra_id INT;
    DECLARE v_subtotal DECIMAL(10,2);

    -- Calcular subtotal
    SET v_subtotal = p_cantidad * p_precio;

    -- Insertar factura de compra
    INSERT INTO facturas_de_compra (
        nombre_proveedor, 
        detalle, 
        monto_bruto, 
        impuestos, 
        monto_neto
    ) VALUES (
        p_nombre_proveedor, 
        'Compra de productos', 
        v_subtotal, 
        v_subtotal * 0.21, 
        v_subtotal * 1.21
    );
    SET v_factura_compra_id = LAST_INSERT_ID();

    -- Insertar proveedor
    INSERT INTO proveedores (
        id_producto, 
        id_categoria_de_producto, 
        numero_de_pedido, 
        detalles, 
        forma_de_pago, 
        estado_del_pago
    ) VALUES (
        p_id_producto, 
        p_id_categoria, 
        v_factura_compra_id, 
        'Compra de productos', 
        p_forma_pago, 
        'PENDIENTE'
    );

    -- Insertar detalle de compra
    INSERT INTO detalle_de_compra (
        id_numero_de_factura_de_compra, 
        id_producto, 
        cantidad, 
        precio, 
        subtotal
    ) VALUES (
        v_factura_compra_id, 
        p_id_producto, 
        p_cantidad, 
        p_precio, 
        v_subtotal
    );

    -- Retornar ID de factura
    SELECT v_factura_compra_id AS factura_compra_id;
END //
DELIMITER ;