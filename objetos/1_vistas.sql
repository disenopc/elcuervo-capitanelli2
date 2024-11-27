USE elcuervopetshop;

-- PRIMERA VISTA: Total de Ingresos por categoría
CREATE OR REPLACE VIEW vista_ingresos_por_categoria AS
SELECT 
    cp.categoria_de_producto,
    SUM(v.total_venta) AS total_ingresos,
    COUNT(v.id_venta) AS num_ventas,
    AVG(v.total_venta) AS promedio_transaccion_valor
FROM ventas v
JOIN categoria_de_producto cp ON v.id_categoria_de_producto = cp.id_categoria_de_producto
GROUP BY cp.categoria_de_producto
ORDER BY total_ingresos DESC;
--_______________________________________________________________________________________________________________________________________________

-- SEGUNDA VISTA: Crecimiento de ventas mensuales
CREATE OR REPLACE VIEW vista_mensual_crecimiento_ventas AS
WITH ventas_mensuales AS (
    SELECT 
        YEAR(fecha_de_alta) AS year,
        MONTH(fecha_de_alta) AS month,
        SUM(total_venta) AS total_mensual_ventas
    FROM ventas v
    JOIN cliente c ON v.id_cliente = c.id_cliente
    GROUP BY YEAR(fecha_de_alta), MONTH(fecha_de_alta)
)
SELECT 
    year,
    month,
    total_mensual_ventas,
    LAG(total_mensual_ventas) OVER (ORDER BY year, month) AS previa_mensuales_ventas,
    ROUND(((total_mensual_ventas - LAG(total_mensual_ventas) OVER (ORDER BY year, month)) 
    / LAG(total_mensual_ventas) OVER (ORDER BY year, month)) * 100, 2) AS crecimiento_porcentual
FROM ventas_mensuales;

--_______________________________________________________________________________________________________________________________________________
-- TERCERA VISTA: Análisis de Retención de Clientes
CREATE OR REPLACE VIEW vista_retencion_cliente AS
SELECT 
    c.estado AS estado_cliente,
    COUNT(DISTINCT c.id_cliente) AS total_clientes,
    COUNT(DISTINCT v.id_cliente) AS clientes_activos,
    ROUND(COUNT(DISTINCT v.id_cliente) / COUNT(DISTINCT c.id_cliente) * 100, 2) AS tasa_retención
FROM cliente c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.estado;

--_______________________________________________________________________________________________________________________________________________
-- CUARTA VISTA: Desempeño del proveedor
CREATE OR REPLACE VIEW vista_performance_vendedor AS
SELECT 
    vd.nombre_vendedor,
    vd.estado_vendedor,
    vd.cantidad_de_ventas,
    SUM(v.total_venta) AS total_ventas,
    ROUND(AVG(v.total_venta), 2) AS promedio_valor_ventas,
    COUNT(DISTINCT v.id_venta) AS num_ventas
FROM vendedor vd
JOIN ventas v ON vd.id_vendedor = v.id_vendedor
GROUP BY vd.id_vendedor, vd.nombre_vendedor, vd.estado_vendedor
ORDER BY total_ventas DESC;

--_______________________________________________________________________________________________________________________________________________
-- QUINTA VISTA: Análisis de quejas
CREATE OR REPLACE VIEW vista_analisis_reclamos AS
SELECT 
    tipo_de_reclamo,
    estado_del_reclamo,
    COUNT(*) AS total_reclamos,
    ROUND(COUNT(*) / (SELECT COUNT(*) FROM postventa) * 100, 2) AS porcentajes_reclamos,
    AVG(DATEDIFF(fecha_de_resolucion, fecha_reclamo)) AS promedio_resolucion_tiempo
FROM postventa
GROUP BY tipo_de_reclamo, estado_del_reclamo
ORDER BY total_reclamos DESC;

--_______________________________________________________________________________________________________________________________________________
-- SEXTA VISTA: Rotación de Inventarios
CREATE OR REPLACE VIEW vista_rotacion_inventarios AS
SELECT 
    p.nombre_producto,
    cp.categoria_de_producto,
    s.cantidad_stock AS stock_actual,
    SUM(dv.cantidad) AS total_unidades_vendidas,
    ROUND(SUM(dv.cantidad) / s.cantidad_stock, 2) AS tasa_rotacion
FROM productos p
JOIN stock s ON p.id_producto = s.id_producto
JOIN categoria_de_producto cp ON p.id_categoria_de_producto = cp.id_categoria_de_producto
JOIN detalle_de_venta dv ON p.id_producto = dv.id_producto
GROUP BY p.id_producto, p.nombre_producto, cp.categoria_de_producto, s.cantidad_stock
ORDER BY tasa_rotacion DESC;