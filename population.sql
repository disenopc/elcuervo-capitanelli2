USE elcuervopetshop;

-- Inserts for facturas_de_compra
INSERT INTO facturas_de_compra (nombre_proveedor, fecha_compra, detalle, monto_bruto, impuestos, monto_neto) VALUES
('PetFood Suppliers', '2024-01-15 10:30:00', 'Compra de alimentos para perros', 5000.00, 950.00, 5950.00),
('Animal Accessories Inc', '2024-02-20 14:45:00', 'Compra de accesorios para gatos', 3500.00, 665.00, 4165.00),
('Wild Reptile Supplies', '2024-03-10 09:15:00', 'Compra de alimentos para reptiles', 2800.00, 532.00, 3332.00),
('Fish World Distributors', '2024-04-05 11:20:00', 'Compra de accesorios para pecera', 4200.00, 798.00, 4998.00),
('Small Mammal Solutions', '2024-05-12 15:00:00', 'Compra de alimentos para mamíferos pequeños', 3000.00, 570.00, 3570.00);

-- Inserts for vendedor
INSERT INTO vendedor (nombre_vendedor, cantidad_de_ventas, estado_vendedor) VALUES
('Juan Pérez', 45, 'ACTIVO'),
('María Rodriguez', 62, 'ACTIVO'),
('Carlos Gomez', 38, 'ACTIVO'),
('Ana Martínez', 55, 'ACTIVO'),
('Luis Fernandez', 41, 'INACTIVO');

-- Inserts for cliente
INSERT INTO cliente (nombre_cliente, fecha_de_nacimiento, direccion, email, fecha_de_alta, estado) VALUES
('Roberto Sanchez', '1985-06-15 00:00:00', 'Av. Libertador 1234', 'roberto.sanchez1@email.com', '2024-01-10 10:00:00', 'A TIEMPO'),
('Carolina Lopez', '1990-03-22 00:00:00', 'Mitre 567', 'carolina.lopez1@email.com', '2024-02-15 14:30:00', 'A TIEMPO'),
('Miguel Torres', '1978-11-30 00:00:00', 'San Martin 890', 'miguel.torres1@email.com', '2024-03-20 11:45:00', 'DEUDOR'),
('Sofia Ramirez', '1995-09-10 00:00:00', 'Belgrano 456', 'sofia.ramirez1@email.com', '2024-04-05 09:15:00', 'A TIEMPO'),
('Daniel Morales', '1982-07-05 00:00:00', 'Rivadavia 2345', 'daniel.morales1@email.com', '2024-05-12 16:20:00', 'DEUDOR');

-- Inserts for facturas_de_venta
INSERT INTO facturas_de_venta (nombre_cliente, detalle, monto_bruto, impuestos, monto_neto) VALUES
('Roberto Sanchez', 'Venta de alimento para perro', 2500.00, 475.00, 2975.00),
('Carolina Lopez', 'Venta de accesorios para gato', 1800.00, 342.00, 2142.00),
('Miguel Torres', 'Venta de alimento para reptiles', 1200.00, 228.00, 1428.00),
('Sofia Ramirez', 'Venta de accesorios para pecera', 3000.00, 570.00, 3570.00),
('Daniel Morales', 'Venta de alimento para mamíferos pequeños', 1500.00, 285.00, 1785.00);

-- Inserts for categoria_de_producto
INSERT INTO categoria_de_producto (categoria_de_producto) VALUES
('ALIMENTO DE PERRO'),
('ALIMENTO DE GATO'),
('ALIMENTO DE MAMIFEROS PEQUENOS'),
('ALIMENTO DE REPTILES'),
('ACCESORIOS DE PERRO');

-- Inserts for centro_de_almacenamiento
INSERT INTO centro_de_almacenamiento (nombre_almacen, ubicacion, capacidad, responsable) VALUES
('PETRACCHI', 'Zona Industrial Norte', '1000 m2', 'Carlos Gutierrez'),
('MODULO 2', 'Parque Logístico Este', '800 m2', 'Laura Mendez'),
('PETRACCHI', 'Zona Industrial Sur', '1200 m2', 'Ricardo Fernandez'),
('MODULO 2', 'Parque Logístico Oeste', '900 m2', 'Martina Rodriguez'),
('PETRACCHI', 'Centro Logístico', '1500 m2', 'Diego Martinez');

-- Inserts for productos
INSERT INTO productos (id_numero_de_factura_de_compra, id_categoria_de_producto, nombre_producto, precio, cantidad) VALUES
(1, 1, 'Alimento Premium para Perros Adultos', 45.50, 100),
(2, 2, 'Snacks para Gatos Salmon', 32.75, 80),
(3, 4, 'Alimento para Iguana', 55.20, 50),
(4, 5, 'Collar Reflectivo para Perros', 18.90, 120),
(5, 3, 'Alimento Balanceado para Hamsters', 26.60, 75);

-- Inserts for detalle_de_compra
INSERT INTO detalle_de_compra (id_numero_de_factura_de_compra, id_producto, cantidad, precio, subtotal) VALUES
(1, 1, 100, 45.50, 4550.00),
(2, 2, 80, 32.75, 2620.00),
(3, 3, 50, 55.20, 2760.00),
(4, 4, 120, 18.90, 2268.00),
(5, 5, 75, 26.60, 1995.00);

-- Inserts for proveedores
INSERT INTO proveedores (id_producto, id_categoria_de_producto, fecha, numero_de_pedido, detalles, forma_de_pago, estado_del_pago) VALUES
(1, 1, '2024-01-15 10:30:00', 12345, 'Pedido de alimentos para perros', 'CONTADO', 'PAGADO'),
(2, 2, '2024-02-20 14:45:00', 12346, 'Pedido de snacks para gatos', 'A 30 DIAS', 'PENDIENTE'),
(3, 4, '2024-03-10 09:15:00', 12347, 'Pedido de alimentos para reptiles', 'A 60 DIAS', 'PENDIENTE'),
(4, 5, '2024-04-05 11:20:00', 12348, 'Pedido de accesorios para perros', 'CONTADO', 'PAGADO'),
(5, 3, '2024-05-12 15:00:00', 12349, 'Pedido de alimentos para mamíferos pequeños', 'A 30 DIAS', 'PENDIENTE');

-- Inserts for stock
INSERT INTO stock (id_producto, id_centro_de_almacenamiento, precio, cantidad_stock) VALUES
(1, 1, 45.50, 100),
(2, 2, 32.75, 80),
(3, 3, 55.20, 50),
(4, 4, 18.90, 120),
(5, 5, 26.60, 75);

-- Inserts for ventas
INSERT INTO ventas (id_cliente, id_vendedor, id_categoria_de_producto, id_num_factura_venta, nombre_cliente, precio_venta, cantidad, total_venta) VALUES
(1, 1, 1, 1, 'Roberto Sanchez', 45.50, 2, 91.00),
(2, 2, 2, 2, 'Carolina Lopez', 32.75, 3, 98.25),
(3, 3, 4, 3, 'Miguel Torres', 55.20, 1, 55.20),
(4, 4, 5, 4, 'Sofia Ramirez', 18.90, 4, 75.60),
(5, 5, 3, 5, 'Daniel Morales', 26.60, 2, 53.20);

-- Inserts for postventa
INSERT INTO postventa (id_venta, nombre_cliente, tipo_de_reclamo, estado_del_reclamo, prioridad, cantidad_de_reclamos, respuesta) VALUES
(1, 'Roberto Sanchez', 'PRODUCTO DEFECTUOSO', 'RESUELTO', 'BAJA', 1, 'Se realizó cambio del producto'),
(2, 'Carolina Lopez', 'RETRASO EN ENTREGA', 'EN PROGRESO', 'MEDIA', 2, 'Investigando el motivo del retraso'),
(3, 'Miguel Torres', 'ERROR DE FACTURACION', 'EN ESPERA', 'ALTA', 3, 'Pendiente de revisión contable'),
(4, 'Sofia Ramirez', 'EXPECTATIVA NO SATISFECHA', 'RESUELTO', 'BAJA', 1, 'Se ofreció explicación y solución'),
(5, 'Daniel Morales', 'PRODUCTO DEFECTUOSO', 'EN PROGRESO', 'MEDIA', 2, 'Evaluando condición del producto');

-- Inserts for detalle_de_venta
INSERT INTO detalle_de_venta (id_venta, id_producto, id_num_factura_venta, cantidad, precio, descuento, subtotal, tipo_venta, nombre_cliente) VALUES
(1, 1, 1, 2, 45.50, 0.00, 91.00, 'FISICA', 'Roberto Sanchez'),
(2, 2, 2, 3, 32.75, 5.00, 93.25, 'ONLINE', 'Carolina Lopez'),
(3, 3, 3, 1, 55.20, 0.00, 55.20, 'FISICA', 'Miguel Torres'),
(4, 4, 4, 4, 18.90, 10.00, 65.60, 'ONLINE', 'Sofia Ramirez'),
(5, 5, 5, 2, 26.60, 0.00, 53.20, 'FISICA', 'Daniel Morales');
