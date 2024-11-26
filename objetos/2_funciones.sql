USE elcuervopetshop;

-- PRIMERA FUNCIÓN: CORROBORAR LA DISPONIBILIDAD DE UN PRODUCTO

DELIMITER $$

DROP FUNCTION IF EXISTS verificar_disponibilidad_producto $$

CREATE FUNCTION verificar_disponibilidad_producto(
    producto_id INT,
    cantidad_deseada INT
) RETURNS VARCHAR(200)
    READS SQL DATA
BEGIN
    DECLARE stock_actual INT;

    -- Obtiene el stock actual del producto (asegurándose de que solo devuelva una fila)
    SELECT cantidad_stock INTO stock_actual
    FROM stock
    WHERE id_producto = producto_id
    LIMIT 1;  -- Agregar LIMIT 1 para garantizar solo una fila

    -- Verifica si hay suficiente stock
    IF stock_actual >= cantidad_deseada THEN
        RETURN 'Stock disponible';
    ELSE
        RETURN CONCAT('Stock insuficiente: Solo hay ', stock_actual, ' unidades disponibles.');
    END IF;
END$$

DELIMITER ;


-- Llamar a la función para probar
SELECT verificar_disponibilidad_producto(1, 10);

SELECT id_producto, COUNT(*) 
FROM stock
GROUP BY id_producto
HAVING COUNT(*) > 1;

--________________________________________________________________________________________________________________________________________________________________

-- SEGUNDA FUNCIÓN: TIEMPO PROMEDIO DE RESOLUCIÓN DE RECLAMOS

DELIMITER $$

DROP FUNCTION IF EXISTS tiempo_promedio_resolucion_reclamos $$

CREATE FUNCTION tiempo_promedio_resolucion_reclamos()
RETURNS DECIMAL(10, 2)
    READS SQL DATA
BEGIN
    DECLARE promedio_resolucion DECIMAL(10, 2);

    SELECT AVG(DATEDIFF(fecha_de_resolucion, fecha_reclamo))
    INTO promedio_resolucion
    FROM postventa
    WHERE estado_del_reclamo = 'RESUELTO';

    RETURN promedio_resolucion;
END$$

DELIMITER ;

-- Llamar a la función para probar
SELECT tiempo_promedio_resolucion_reclamos();

--________________________________________________________________________________________________________________________________________________________________

--TERCERA FUNCIÓN: TASA DE RETENCIÓN DEL CLIENTE

DELIMITER $$

DROP FUNCTION IF EXISTS calcular_tasa_retencion_clientes $$

CREATE FUNCTION calcular_tasa_retencion_clientes()
RETURNS DECIMAL(10, 2)
    READS SQL DATA
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

-- Llamar a la función para probar
SELECT calcular_tasa_retencion_clientes();


--________________________________________________________________________________________________________________________________________________________________

--CUARTA FUNCIÓN: VENDEDOR CON MAYOR CANTIDAD DE VENTAS EJECUTADAS


DELIMITER $$

DROP FUNCTION IF EXISTS vendedor_top_ventas $$

CREATE FUNCTION vendedor_top_ventas()
RETURNS VARCHAR(200)
    READS SQL DATA
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

-- Llamar a la función para probar
SELECT vendedor_top_ventas();



