DROP DATABASE IF EXISTS elcuervopetshop;

CREATE DATABASE elcuervopetshop;

USE elcuervopetshop;

-- TABLAS SIN FK

--TABLA FACTURAS DE COMPRA
CREATE TABLE facturas_de_compra(
id_numero_de_factura_de_compra INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre_proveedor VARCHAR(200),
fecha_compra DATETIME DEFAULT(CURRENT_TIMESTAMP),
detalle VARCHAR(200),
monto_bruto DECIMAL(10,2),
impuestos DECIMAL (10,2),
monto_neto DECIMAL(10,2)
);

--TABLA VENDEDORES
CREATE TABLE vendedor(
id_vendedor INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre_vendedor VARCHAR(200),
cantidad_de_ventas INT,
estado_vendedor ENUM("ACTIVO","INACTIVO")
);

--TABLA CLIENTES
CREATE TABLE cliente(
id_cliente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre_cliente VARCHAR(200),
fecha_de_nacimiento DATETIME DEFAULT(CURRENT_TIMESTAMP),
direccion VARCHAR(200),
email VARCHAR(200) UNIQUE,
fecha_de_alta DATETIME DEFAULT(CURRENT_TIMESTAMP),
estado ENUM("DEUDOR","A TIEMPO")
);


--TABLA FACTURAS DE VENTA
CREATE TABLE facturas_de_venta(
id_num_factura_venta INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre_cliente VARCHAR(200),
detalle VARCHAR(200),
monto_bruto DECIMAL(10,2),
impuestos DECIMAL(10,2),
monto_neto DECIMAL(10,2)
);

--TABLA CATEGORIA DE PRODUCTO
CREATE TABLE categoria_de_producto(
id_categoria_de_producto INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
categoria_de_producto ENUM("ALIMENTO DE PERRO","ALIMENTO DE GATO","ALIMENTO DE MAMIFEROS PEQUENOS","ALIMENTO DE REPTILES","ALIMENTO DE PECES","ACCESORIOS DE PERRO","ACCESORIOS DE GATO","ACCESORIOS DE AVE","ACCESORIOS PARA PECERA","ACCESORIOS MAMIFEROS PEQUENOS","ACCESORIOS DE REPTILES")
);

--TABLA CENTRO ALMACENAMIENTO
CREATE TABLE centro_de_almacenamiento(
id_centro_de_almacenamiento INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre_almacen ENUM("PETRACCHI","MODULO 2"),
ubicacion VARCHAR(200),
capacidad VARCHAR(200),
responsable VARCHAR(200)
);

-- TABLAS CON FK

--TABLA PRODUCTOS
CREATE TABLE productos(
id_producto INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_numero_de_factura_de_compra INT,
id_categoria_de_producto INT,
nombre_producto VARCHAR(200) NOT NULL,
precio DECIMAL (10,2),
cantidad INT,
FOREIGN KEY (id_numero_de_factura_de_compra) REFERENCES facturas_de_compra(id_numero_de_factura_de_compra),
FOREIGN KEY (id_categoria_de_producto) REFERENCES categoria_de_producto(id_categoria_de_producto)
);

--TABLA DETALLE DE COMPRA
CREATE TABLE detalle_de_compra(
id_detalle_compra INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_numero_de_factura_de_compra INT,
id_producto INT,
cantidad INT,
precio DECIMAL(10,2),
subtotal DECIMAL (10,2),
FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
FOREIGN KEY (id_numero_de_factura_de_compra) REFERENCES facturas_de_compra(id_numero_de_factura_de_compra)
);

--TABLA PROVEEDORES
CREATE TABLE proveedores(
id_proveedor INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_producto INT,
id_categoria_de_producto INT,
fecha DATETIME DEFAULT(CURRENT_TIMESTAMP),
numero_de_pedido INT,
detalles VARCHAR(200),
forma_de_pago ENUM ("CONTADO","A 30 DIAS", "A 60 DIAS"),
estado_del_pago ENUM("PAGADO","PENDIENTE"),
FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
FOREIGN KEY (id_categoria_de_producto) REFERENCES categoria_de_producto(id_categoria_de_producto)
);

--TABLA STOCK
CREATE TABLE stock(
id_stock INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_producto INT,
id_centro_de_almacenamiento INT,
precio DECIMAL(10,2),
cantidad_stock INT,
FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
FOREIGN KEY (id_centro_de_almacenamiento) REFERENCES centro_de_almacenamiento(id_centro_de_almacenamiento)
);

--TABLA VENTAS
CREATE TABLE ventas(
id_venta INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_cliente INT,
id_vendedor INT,
id_categoria_de_producto INT,
id_num_factura_venta INT,
nombre_cliente VARCHAR(200),
precio_venta DECIMAL(10,2),
cantidad INT,
total_venta DECIMAL(10,2),
FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
FOREIGN KEY (id_categoria_de_producto) REFERENCES categoria_de_producto(id_categoria_de_producto),
FOREIGN KEY (id_vendedor) REFERENCES vendedor(id_vendedor),
FOREIGN KEY (id_num_factura_venta) REFERENCES facturas_de_venta(id_num_factura_venta)
);

--TABLA RECLAMOS
CREATE TABLE postventa(
id_reclamo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_venta INT,
nombre_cliente VARCHAR(200),
fecha_reclamo DATETIME DEFAULT(CURRENT_TIMESTAMP),
tipo_de_reclamo ENUM("PRODUCTO DEFECTUOSO","RETRASO EN ENTREGA","ERROR DE FACTURACION","EXPECTATIVA NO SATISFECHA"),
estado_del_reclamo ENUM("RESUELTO","EN PROGRESO","EN ESPERA"),
prioridad ENUM("ALTA","MEDIA","BAJA"),
cantidad_de_reclamos INT,
respuesta VARCHAR(200),
fecha_de_resolucion DATETIME DEFAULT(CURRENT_TIMESTAMP),
FOREIGN KEY (id_venta) REFERENCES ventas(id_venta)
);

--TABLA DETALLE DE VENTAS
CREATE TABLE detalle_de_venta(
id_detalle_de_venta INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_venta INT,
id_producto INT,
id_num_factura_venta INT,
cantidad INT,
precio DECIMAL(10,2),
descuento DECIMAL(10,2),
subtotal DECIMAL(10,2),
tipo_venta ENUM("ONLINE","FISICA"),
nombre_cliente VARCHAR(200),
FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);