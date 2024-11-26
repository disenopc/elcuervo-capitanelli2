USE elcuervopetshop;


-- PRIMERA FUNCIÓN: Corroborar la disponibilidad de un producto
DELIMITER-$$
DROP FUNCTION IF EXISTS elcuervopetshop.verificar_disponibilidad_producto()
CREATE FUNCTION verificar_disponibilidad_producto(
    producto_id INT,
    cantidad_deseada INT
) RETURNS VARCHAR(200)
BEGIN
    DECLARE stock_actual INT;
    
    -- Obtiene el stock actual del producto

    SELECT cantidad_stock INTO stock_actual
    FROM stock
    WHERE id_producto = producto_id;

    -- Verifica si hay suficiente stock

    IF stock_actual >= cantidad_deseada THEN
        RETURN 'Stock disponible';
    ELSE
        RETURN CONCAT('Stock insuficiente: Solo hay ', stock_actual, ' unidades disponibles.');
    END IF;
END$$

DELIMITER ;

SELECT verificar_disponibilidad_producto(1, 10);


-- SEGUNDA FUNCIÓN: tiempo promedio en resolución de reclamos

DELIMITER $$

CREATE FUNCTION tiempo_promedio_resolucion_reclamos()
RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE promedio_resolucion DECIMAL(10, 2);

    SELECT AVG(DATEDIFF(fecha_de_resolucion, fecha_reclamo))
    INTO promedio_resolucion
    FROM postventa
    WHERE estado_del_reclamo = 'RESUELTO';

    RETURN promedio_resolucion;
END$$

DELIMITER ;

SELECT tiempo_promedio_resolucion_reclamos();


--TERCERA FUNCIÓN: tasa de retención de clientes
DELIMITER $$

CREATE FUNCTION calcular_tasa_retencion_clientes()
RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE total_clientes INT;
    DECLARE clientes_activos INT;

    -- Calcula el total de clientes
    SELECT COUNT(*) INTO total_clientes
    FROM cliente;

    -- Calcula los clientes que tienen ventas asociadas (clientes activos)
    SELECT COUNT(DISTINCT id_cliente) INTO clientes_activos
    FROM ventas;

    -- Retorna el porcentaje de clientes activos
    RETURN ROUND((clientes_activos / total_clientes) * 100, 2);
END$$

DELIMITER ;

SELECT calcular_tasa_retencion_clientes();


--CUARTA FUNCIÓN: vendedor con mayor cantidad de ventas ejecutadas

DELIMITER $$

CREATE FUNCTION vendedor_top_ventas()
RETURNS VARCHAR(200)
BEGIN
    DECLARE nombre_vendedor_top VARCHAR(200);

    -- Busca el vendedor con más ventas
    SELECT nombre_vendedor
    INTO nombre_vendedor_top
    FROM vendedor
    ORDER BY cantidad_de_ventas DESC
    LIMIT 1;

    RETURN nombre_vendedor_top;
END$$

DELIMITER ;

SELECT vendedor_top_ventas();



