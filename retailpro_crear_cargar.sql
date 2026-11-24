-- ============================================================
-- RetailPro - Creación de base de datos y carga inicial
-- Pre-entrega 3 (Módulo 4): correr esto primero en MySQL
-- Workbench para tener las tablas listas antes de escribir
-- las consultas de negocio.
-- ============================================================

CREATE DATABASE IF NOT EXISTS retailpro;
USE retailpro;

-- ------------------------------------------------------------
-- SECCIÓN 0: DROP TABLES (orden inverso de dependencias)
-- Se incluye al inicio para que el script sea repetible:
-- se puede ejecutar varias veces sin errores.
-- ------------------------------------------------------------
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS territorios;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

-- ------------------------------------------------------------
-- SECCIÓN 1: DEFINICIÓN DEL ESQUEMA (DDL)
-- Orden: primero las dimensiones, al final la tabla de hechos.
-- ------------------------------------------------------------

CREATE TABLE categorias (
    id_categoria     INT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL
);

CREATE TABLE clientes (
    id_cliente      INT PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    email           VARCHAR(100) NOT NULL,
    ciudad          VARCHAR(50),
    segmento        VARCHAR(20),
    fecha_registro  DATE NOT NULL
);

CREATE TABLE territorios (
    id_territorio INT PRIMARY KEY,
    region        VARCHAR(50) NOT NULL,
    pais          VARCHAR(50) NOT NULL,
    zona          VARCHAR(50) NOT NULL
);

CREATE TABLE productos (
    id_producto      INT PRIMARY KEY,
    nombre_producto  VARCHAR(100) NOT NULL,
    id_categoria     INT NOT NULL,
    precio           DECIMAL(10,2) NOT NULL,
    costo            DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE ventas (
    id_venta       INT PRIMARY KEY,
    fecha_venta    DATE NOT NULL,
    id_cliente     INT NOT NULL,
    id_producto    INT NOT NULL,
    id_territorio  INT NOT NULL,
    cantidad       INT NOT NULL,
    total_venta    DECIMAL(10,2) NOT NULL,
    canal          VARCHAR(20),
    FOREIGN KEY (id_cliente)    REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto)   REFERENCES productos(id_producto),
    FOREIGN KEY (id_territorio) REFERENCES territorios(id_territorio)
);

-- ------------------------------------------------------------
-- SECCIÓN 2: CARGA INICIAL DE DATOS (DML)
-- ------------------------------------------------------------

INSERT INTO categorias (id_categoria, nombre_categoria) VALUES (1, 'Celulares');
INSERT INTO categorias (id_categoria, nombre_categoria) VALUES (2, 'Accesorios');
INSERT INTO categorias (id_categoria, nombre_categoria) VALUES (3, 'Usados');

INSERT INTO clientes (id_cliente, nombre, email, ciudad, segmento, fecha_registro)
VALUES (1, 'Martina Gómez', 'martina.gomez@mail.com', 'Rosario', 'Minorista', '2026-01-15');
INSERT INTO clientes (id_cliente, nombre, email, ciudad, segmento, fecha_registro)
VALUES (2, 'Carlos Ibáñez', 'carlos.ibanez@mail.com', 'Buenos Aires', 'Mayorista', '2026-02-10');
INSERT INTO clientes (id_cliente, nombre, email, ciudad, segmento, fecha_registro)
VALUES (3, 'Lucía Fernández', 'lucia.fernandez@mail.com', 'Mendoza', 'Minorista', '2026-03-05');
INSERT INTO clientes (id_cliente, nombre, email, ciudad, segmento, fecha_registro)
VALUES (4, 'Sofía Ramírez', 'sofia.ramirez@mail.com', 'Rosario', 'Minorista', '2026-11-20');

INSERT INTO territorios (id_territorio, region, pais, zona) VALUES (1, 'Santa Fe', 'Argentina', 'Centro');
INSERT INTO territorios (id_territorio, region, pais, zona) VALUES (2, 'CABA', 'Argentina', 'Centro');
INSERT INTO territorios (id_territorio, region, pais, zona) VALUES (3, 'Río Negro', 'Argentina', 'Sur');
INSERT INTO territorios (id_territorio, region, pais, zona) VALUES (4, 'Mendoza', 'Argentina', 'Cuyo');
INSERT INTO territorios (id_territorio, region, pais, zona) VALUES (5, 'Tierra del Fuego', 'Argentina', 'Sur');

INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, costo) VALUES (1, 'iPhone 13 128GB', 1, 650000.00, 455000.00);
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, costo) VALUES (2, 'Samsung Galaxy A54', 1, 420000.00, 294000.00);
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, costo) VALUES (3, 'Auriculares Bluetooth JBL', 2, 45000.00, 22500.00);
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, costo) VALUES (4, 'Cargador rápido 20W', 2, 18000.00, 9000.00);
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, costo) VALUES (5, 'iPhone 11 Usado 64GB', 3, 380000.00, 285000.00);
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, costo) VALUES (6, 'Funda Silicona iPhone 13', 2, 15000.00, 7000.00);

INSERT INTO ventas (id_venta, fecha_venta, id_cliente, id_producto, id_territorio, cantidad, total_venta, canal) VALUES (1, '2026-09-01', 1, 1, 1, 1, 650000.00, 'Sucursal');
INSERT INTO ventas (id_venta, fecha_venta, id_cliente, id_producto, id_territorio, cantidad, total_venta, canal) VALUES (2, '2026-09-03', 2, 2, 2, 3, 1260000.00, 'Online');
INSERT INTO ventas (id_venta, fecha_venta, id_cliente, id_producto, id_territorio, cantidad, total_venta, canal) VALUES (3, '2026-09-05', 3, 5, 4, 1, 380000.00, 'Sucursal');
INSERT INTO ventas (id_venta, fecha_venta, id_cliente, id_producto, id_territorio, cantidad, total_venta, canal) VALUES (4, '2026-09-10', 1, 3, 1, 2, 90000.00, 'Online');
INSERT INTO ventas (id_venta, fecha_venta, id_cliente, id_producto, id_territorio, cantidad, total_venta, canal) VALUES (5, '2026-09-12', 2, 4, 2, 5, 90000.00, 'Online');
INSERT INTO ventas (id_venta, fecha_venta, id_cliente, id_producto, id_territorio, cantidad, total_venta, canal) VALUES (6, '2026-09-15', 3, 1, 4, 1, 650000.00, 'Sucursal');
INSERT INTO ventas (id_venta, fecha_venta, id_cliente, id_producto, id_territorio, cantidad, total_venta, canal) VALUES (7, '2026-09-18', 1, 2, 1, 1, 420000.00, 'Sucursal');
INSERT INTO ventas (id_venta, fecha_venta, id_cliente, id_producto, id_territorio, cantidad, total_venta, canal) VALUES (8, '2026-09-20', 2, 5, 2, 1, 380000.00, 'Online');
INSERT INTO ventas (id_venta, fecha_venta, id_cliente, id_producto, id_territorio, cantidad, total_venta, canal) VALUES (9, '2026-09-22', 3, 3, 4, 4, 180000.00, 'Sucursal');
INSERT INTO ventas (id_venta, fecha_venta, id_cliente, id_producto, id_territorio, cantidad, total_venta, canal) VALUES (10, '2026-09-25', 1, 4, 1, 2, 36000.00, 'Online');

-- ------------------------------------------------------------
-- SECCIÓN 3: VALIDACIÓN
-- ------------------------------------------------------------
SELECT * FROM categorias;
SELECT * FROM clientes;
SELECT * FROM territorios;
SELECT * FROM productos;
SELECT * FROM ventas;
