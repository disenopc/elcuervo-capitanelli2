
USE elcuervopetshop;

-- PRIMER PROCEDIMIENTO: INSERTAR UN NUEVO PRODUCTO
DELIMITER //
DROP PROCEDURE IF EXISTS elcuervopetshop.InsertarProducto //
CREATE PROCEDURE elcuervopetshop.InsertarProducto(
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
--______________________________________________________________________________________________________________________________________________________

-- SEGUNDO PROCEDIMIENTO: REGISTRAR UNA NUEVA VENTA
DELIMITER //
DROP PROCEDURE IF EXISTS elcuervopetshop.RegistrarVenta //
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

    -- INSERTA DATOS DE LA FACTURA DE VENTA
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

    -- INSERTA LA VENTA
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

    -- DEVUELVE ID's DE FACTURA Y VENTA 
    SELECT v_factura_id AS factura_id, v_venta_id AS venta_id;
END //
DELIMITER ;

--______________________________________________________________________________________________________________________________________________________
-- TERCER PROCEDIMIENTO: REGISTRAR UN RECLAMO POSTVENTA
DELIMITER //
DROP PROCEDURE IF EXISTS elcuervopetshop.RegistrarReclamo //
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

   -- ACTUALIZA EL STOCK DE PRODUCTO
DELIMITER //
DROP PROCEDURE IF EXISTS elcuervopetshop.ActualizarStock //
CREATE PROCEDURE ActualizarStock(
    IN p_id_producto INT,
    IN p_id_centro_almacenamiento INT,
    IN p_cantidad INT
)
BEGIN
    -- ACTUALIZA EL STOCK DE PRODUCTO EXISTENTE O NUEVO REGISTRO
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

    -- ACTUALIZAR TABLA DE PRODUCTOS
    UPDATE productos 
    SET cantidad = cantidad + p_cantidad 
    WHERE id_producto = p_id_producto;
END //
DELIMITER ;

--_____________________________________________________________________________________________________________________________________________________

-- CUARTO PROCEDIMIENTO: OBTENER VENTAS POR VENDEDOR CON FILTROS
DELIMITER //

DROP PROCEDURE IF EXISTS elcuervopetshop.ObtenerDetallesVentaConVendedoresFiltrados //

CREATE PROCEDURE ObtenerDetallesVentaConVendedoresFiltrados(
    IN p_tipo_venta VARCHAR(10),
    IN p_estado_vendedor VARCHAR(10),
    IN p_min_cantidad INT,
    IN p_max_cantidad INT
)
BEGIN
    -- Asigna valores predeterminados si son NULL
    IF p_min_cantidad IS NULL THEN
        SET p_min_cantidad = 0;
    END IF;
    IF p_max_cantidad IS NULL THEN
        SET p_max_cantidad = 1000000;
    END IF;

    SELECT 
        dv.id_detalle_de_venta,
        dv.id_venta,
        dv.id_producto,
        dv.id_num_factura_venta,
        dv.cantidad AS cantidad_vendida,
        dv.precio AS precio_venta,
        dv.descuento,
        dv.subtotal,
        dv.tipo_venta,
        dv.nombre_cliente,
        v.id_vendedor,
        v.nombre_vendedor,
        v.cantidad_de_ventas,
        v.estado_vendedor
    FROM 
        detalle_de_venta dv
    LEFT JOIN 
        ventas ve ON dv.id_venta = ve.id_venta
    LEFT JOIN 
        vendedor v ON ve.id_vendedor = v.id_vendedor
    WHERE 
        (p_tipo_venta IS NULL OR dv.tipo_venta = p_tipo_venta)
        AND (p_estado_vendedor IS NULL OR v.estado_vendedor = p_estado_vendedor)
        AND dv.cantidad BETWEEN p_min_cantidad AND p_max_cantidad
    ORDER BY 
        dv.id_detalle_de_venta;
END //

DELIMITER ;
