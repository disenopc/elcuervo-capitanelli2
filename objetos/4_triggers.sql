USE elcuervopetshop;

--___________________________________________________________________________________________________________________________________________________
-- PRIMER TRIGGER: OBJETIVO - ACTUALIZAR LA CANTIDAD DE VENTAS DE UN VENDEDOR DESPUÉS DE CADA VENTA.
DELIMITER //
CREATE TRIGGER actualizar_cantidad_postventa
AFTER INSERT ON ventas
FOR EACH ROW
BEGIN
    UPDATE vendedor 
    SET cantidad_de_ventas = cantidad_de_ventas + 1
    WHERE id_vendedor = NEW.id_vendedor;
END //
DELIMITER ;

--___________________________________________________________________________________________________________________________________________________

-- SEGUNDO TRIGGER: OBJETIVO - ACTUALIZAR STOCK DE PRODUCTOS DESPÚES DE CADA VENTA 
DELIMITER //
CREATE TRIGGER actualizar_stock_postventa
AFTER INSERT ON detalle_de_venta
FOR EACH ROW
BEGIN
    -- Reducir la cantidad de productos en la tabla productos
    UPDATE productos 
    SET cantidad = cantidad - NEW.cantidad
    WHERE id_producto = NEW.id_producto;

    -- Reducir la cantidad de stock en la tabla stock
    UPDATE stock 
    SET cantidad_stock = cantidad_stock - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END //
DELIMITER ;

--___________________________________________________________________________________________________________________________________________________

-- TERCER TRIGGER: OBJETIVO - MANEJO DE RECLAMOS Y ACTUALIZACIÓN CONTADOR DE RECLAMOS DEL CLIENTE
DELIMITER //
CREATE TRIGGER actualizar_stock_devolución
AFTER INSERT ON postventa
FOR EACH ROW
BEGIN
    -- Variable para almacenar el ID del cliente
    DECLARE v_cliente_id INT;

    -- Obtener el ID del cliente a partir de la venta
    SELECT id_cliente INTO v_cliente_id
    FROM ventas
    WHERE id_venta = NEW.id_venta;

    -- Actualizar estado del cliente si tiene muchos reclamos
    IF (SELECT COUNT(*) FROM postventa 
        WHERE id_venta IN (SELECT id_venta FROM ventas WHERE id_cliente = v_cliente_id)) > 3 THEN
        UPDATE cliente
        SET estado = 'DEUDOR'
        END//
        DELIMITER ;