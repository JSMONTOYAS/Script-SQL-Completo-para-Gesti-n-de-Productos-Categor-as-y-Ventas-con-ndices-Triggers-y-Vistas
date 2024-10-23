# Gestión de Productos, Categorías y Ventas - SQL Script

Este repositorio contiene un script SQL completo que abarca la creación y gestión de una base de datos relacional para el manejo de **productos**, **categorías** y **ventas**, incorporando características avanzadas como **índices**, **triggers** y **vistas**. El objetivo es proporcionar un esquema de base de datos funcional, optimizado y automatizado, útil para proyectos de gestión de inventario y ventas.

## Características principales

### 1. Creación de tablas
- **Productos**: Almacena información de productos como nombre, precio, stock y fecha de agregado.
- **Categorías**: Define categorías para agrupar los productos.
- **Ventas**: Registra cada venta realizada, con el producto vendido y la cantidad.
- **ProductoCategoria**: Relaciona productos con sus categorías utilizando claves foráneas.

### 2. Llaves foráneas
El script incluye relaciones entre las tablas utilizando llaves foráneas para asegurar la integridad referencial. Esto permite que las categorías y productos se relacionen de manera correcta, y asegura que al eliminar un producto o categoría, las relaciones correspondientes también sean eliminadas.

### 3. Índices
Para mejorar el rendimiento de las consultas, el script crea índices en las columnas más utilizadas:
- **Índice en el nombre de los productos** para acelerar las búsquedas.
- **Índice en el precio de los productos** para optimizar las consultas que involucren comparaciones de precios.
- **Índices compuestos** en las tablas de relación para facilitar las búsquedas por categorías.

### 4. Automatización con Triggers
El script incluye un **trigger** que automatiza la actualización del stock de productos cuando se realiza una venta. Esto garantiza que el stock siempre esté actualizado sin necesidad de realizar actualizaciones manuales.

### 5. Vistas
Se crea una **vista** llamada `VistaProductosCategorias` que facilita la consulta de productos junto con sus categorías, simplificando las consultas complejas y proporcionando una forma rápida de acceder a esta información.

### 6. Consultas avanzadas
El script también incluye ejemplos de consultas avanzadas que demuestran el uso de agregaciones y relaciones:
- Consultar el **producto más caro por categoría**.
- Calcular el **total de productos vendidos por categoría**.
- Consultar productos según su **rango de precios** o **stock**.

## Instrucciones de uso

1. **Crear la base de datos**: El script comienza creando una base de datos llamada `MiTienda`. Asegúrate de que tu entorno soporte esta operación.
   ```sql
   CREATE DATABASE MiTienda;
   USE MiTienda;
