-- ============================================================
-- RetailPro - Pre-entrega Modulo 4: Consultas SQL de negocio
-- Base de datos: retailpro (creada en la Pre-entrega del Modulo 3)
-- Tabla usada: ventas (id_venta, fecha_venta, id_cliente, id_producto,
-- id_territorio, cantidad, total_venta, canal)
-- ============================================================

USE retailpro;

-- ------------------------------------------------------------
-- Consulta 1: Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio por mes.
-- (En nuestros datos todas las ventas son de septiembre 2026,
-- por eso el resultado tiene una sola fila: es lo esperado).
-- ------------------------------------------------------------
SELECT
    MONTH(fecha_venta) AS mes,
    SUM(total_venta)   AS total_facturado,
    COUNT(*)           AS cantidad_pedidos,
    AVG(total_venta)   AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

-- ------------------------------------------------------------
-- Consulta 2: Ranking de productos
-- Top 5 de id_producto por total facturado, con unidades vendidas.
-- ------------------------------------------------------------
SELECT
    id_producto,
    SUM(cantidad)     AS unidades_vendidas,
    SUM(total_venta)  AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;

-- ------------------------------------------------------------
-- Consulta 3: Clientes recurrentes
-- Clientes con mas de un pedido, con cantidad de pedidos y total gastado.
-- ------------------------------------------------------------
SELECT
    id_cliente,
    COUNT(*)          AS cantidad_pedidos,
    SUM(total_venta)  AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

-- ------------------------------------------------------------
-- Consulta 4: Productos por encima/por debajo del promedio
-- Total facturado por producto, etiquetado segun si supera o no
-- el promedio de facturacion POR PRODUCTO (no el promedio de las
-- filas de ventas individuales).
-- ------------------------------------------------------------
WITH totales_por_producto AS (
    SELECT
        id_producto,
        SUM(total_venta) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)
SELECT
    id_producto,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM totales_por_producto)
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM totales_por_producto
ORDER BY total_facturado DESC;

-- ------------------------------------------------------------
-- Hallazgos
-- ------------------------------------------------------------
-- 1. El producto 2 (Samsung Galaxy A54) concentra ~40,6% de la
--    facturacion total del periodo (1.680.000 de 4.136.000), el
--    mayor peso de todo el catalogo.
-- 2. El cliente 2 (Carlos Ibanez) es el que mas gasto en total
--    (1.730.000) con solo 3 pedidos, mientras que el cliente 1
--    (Martina Gomez) tuvo mas pedidos (4) pero gasto menos en total
--    (1.196.000) -- su ticket promedio por pedido es mas bajo.
-- 3. 3 de los 5 productos (Auriculares JBL, Cargador rapido e
--    iPhone 11 Usado) quedaron por debajo del promedio de
--    facturacion por producto, lo que muestra que las ventas se
--    concentran fuertemente en 2 productos top (Samsung A54 e
--    iPhone 13).
