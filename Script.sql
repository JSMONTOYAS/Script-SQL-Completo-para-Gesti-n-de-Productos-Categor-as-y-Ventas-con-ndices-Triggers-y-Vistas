-- CREAR UNA BASE DE DATOS (SI NO EXISTE)
CREATE DATABASE IF NOT EXISTS MiTienda;

-- USAR LA BASE DE DATOS
USE MiTienda;

-- CREAR UNA TABLA DE PRODUCTOS
CREATE TABLE IF NOT EXISTS Productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    fecha_agregado DATE DEFAULT CURRENT_DATE
);

-- CREAR UNA TABLA DE CATEGORÍAS
CREATE TABLE IF NOT EXISTS Categorias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL
);

-- CREAR UNA TABLA PARA RELACIONAR PRODUCTOS CON CATEGORÍAS
CREATE TABLE IF NOT EXISTS ProductoCategoria (
    producto_id INT,
    categoria_id INT,
    FOREIGN KEY (producto_id) REFERENCES Productos(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES Categorias(id) ON DELETE CASCADE,
    PRIMARY KEY (producto_id, categoria_id)
);

-- INSERTAR DATOS DE PRUEBA EN LAS TABLAS
INSERT INTO Productos (nombre, precio, stock) VALUES
('Laptop', 1500.50, 10),
('Mouse', 20.00, 50),
('Teclado', 45.99, 30),
('Monitor', 299.99, 15),
('Impresora', 99.95, 5);

INSERT INTO Categorias (nombre) VALUES ('Electrónica'), ('Oficina');

-- ASOCIAR PRODUCTOS CON CATEGORÍAS
INSERT INTO ProductoCategoria (producto_id, categoria_id) VALUES
(1, 1), -- Laptop pertenece a Electrónica
(2, 1), -- Mouse pertenece a Electrónica
(3, 2), -- Teclado pertenece a Oficina
(4, 1), -- Monitor pertenece a Electrónica
(5, 2); -- Impresora pertenece a Oficina

-- CREAR ÍNDICES PARA OPTIMIZAR CONSULTAS

-- Índice para optimizar búsquedas por nombre de producto
CREATE INDEX idx_nombre_producto ON Productos (nombre);

-- Índice para optimizar búsquedas por precio
CREATE INDEX idx_precio_producto ON Productos (precio);

-- Índice compuesto para optimizar la búsqueda de productos por categoría
CREATE INDEX idx_producto_categoria ON ProductoCategoria (producto_id, categoria_id);

-- 1. CONSULTAS COMUNES

-- Buscar productos que pertenecen a la categoría 'Electrónica'
SELECT P.nombre, P.precio
FROM Productos P
JOIN ProductoCategoria PC ON P.id = PC.producto_id
JOIN Categorias C ON C.id = PC.categoria_id
WHERE C.nombre = 'Electrónica';

-- Buscar productos cuyo precio está entre 50 y 500
SELECT * FROM Productos WHERE precio BETWEEN 50 AND 500;

-- Ordenar los productos por stock de mayor a menor
SELECT * FROM Productos ORDER BY stock DESC;

-- 2. FUNCIONES AGREGADAS

-- Calcular el precio promedio de los productos en la tabla
SELECT AVG(precio) AS promedio_precio FROM Productos;

-- Contar cuántos productos tienen más de 20 unidades en stock
SELECT COUNT(*) AS productos_con_stock FROM Productos WHERE stock > 20;

-- 3. TRIGGERS

-- Crear un trigger que actualice el stock de un producto cuando se inserta una venta
CREATE TABLE IF NOT EXISTS Ventas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    producto_id INT,
    cantidad INT NOT NULL,
    fecha_venta DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (producto_id) REFERENCES Productos(id) ON DELETE CASCADE
);

-- Trigger para actualizar el stock de un producto cuando se inserta una venta
DELIMITER $$
CREATE TRIGGER actualizar_stock
AFTER INSERT ON Ventas
FOR EACH ROW
BEGIN
    UPDATE Productos
    SET stock = stock - NEW.cantidad
    WHERE id = NEW.producto_id;
END$$
DELIMITER ;

-- Insertar una venta para probar el trigger
INSERT INTO Ventas (producto_id, cantidad) VALUES (1, 2); -- Se vende 2 Laptops

-- Verificar que el stock de la Laptop se haya actualizado
SELECT nombre, stock FROM Productos WHERE id = 1;

-- 4. VISTAS

-- Crear una vista para facilitar la consulta de productos y sus categorías
CREATE VIEW VistaProductosCategorias AS
SELECT P.nombre AS producto, P.precio, C.nombre AS categoria
FROM Productos P
JOIN ProductoCategoria PC ON P.id = PC.producto_id
JOIN Categorias C ON C.id = PC.categoria_id;

-- Usar la vista para consultar productos y categorías
SELECT * FROM VistaProductosCategorias;

-- 5. CONSULTAS MÁS COMPLEJAS

-- Consultar el producto más caro de cada categoría
SELECT C.nombre AS categoria, MAX(P.precio) AS precio_maximo
FROM Productos P
JOIN ProductoCategoria PC ON P.id = PC.producto_id
JOIN Categorias C ON C.id = PC.categoria_id
GROUP BY C.nombre;

-- Consultar el total de productos vendidos por categoría
SELECT C.nombre AS categoria, SUM(V.cantidad) AS total_vendido
FROM Ventas V
JOIN Productos P ON P.id = V.producto_id
JOIN ProductoCategoria PC ON P.id = PC.producto_id
JOIN Categorias C ON C.id = PC.categoria_id
GROUP BY C.nombre;
