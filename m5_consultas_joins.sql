-- ============================================================
-- RetailPro - Pre-entrega Modulo 5: Consultas con JOINs
-- Base de datos: retailpro (creada en el Checkpoint del Modulo 3,
-- actualizada con un cliente y un producto sin ventas para esta
-- entrega: id_cliente 4 "Sofia Ramirez" y id_producto 6 "Funda
-- Silicona iPhone 13").
-- ============================================================

USE retailpro;

-- ------------------------------------------------------------
-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Proposito: combinar ventas con clientes, productos, categorias
-- y territorios para tener en una sola fila todo lo que necesita
-- Power BI: fecha, cliente, segmento, producto, categoria, region,
-- cantidad, precio unitario y total de venta. Esta vista es la
-- fuente de datos principal del dashboard del Modulo 7.
-- ------------------------------------------------------------
SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre          AS nombre_cliente,
    c.segmento        AS segmento_cliente,
    p.nombre_producto,
    cat.nombre_categoria,
    t.region,
    v.cantidad,
    p.precio          AS precio_unitario,
    v.total_venta
FROM ventas v
INNER JOIN clientes    c   ON v.id_cliente    = c.id_cliente
INNER JOIN productos   p   ON v.id_producto   = p.id_producto
INNER JOIN categorias  cat ON p.id_categoria  = cat.id_categoria
INNER JOIN territorios t   ON v.id_territorio = t.id_territorio;
-- Hallazgo: las 10 ventas registradas matchean correctamente en las 4
-- tablas (10 filas en el resultado, ninguna se pierde), lo que confirma
-- que la integridad referencial del esquema esta bien y esta vista
-- puede usarse como fuente unica y confiable para el dashboard.

-- ------------------------------------------------------------
-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Proposito: detectar clientes registrados que todavia no
-- compraron, para que el area de CRM los contacte.
-- ------------------------------------------------------------
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
-- Hallazgo: 1 de los 4 clientes registrados (Sofia Ramirez) nunca
-- compro; se registro este mismo mes, asi que CRM deberia priorizar
-- un primer contacto de bienvenida antes de que se enfrie el lead.

-- ------------------------------------------------------------
-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Proposito: identificar productos del catalogo que no tienen
-- ninguna venta registrada, para que el area de producto revise
-- si conviene promocionarlos o darlos de baja.
-- ------------------------------------------------------------
SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
LEFT JOIN categorias cat ON p.id_categoria  = cat.id_categoria
LEFT JOIN ventas      v   ON p.id_producto   = v.id_producto
WHERE v.id_venta IS NULL;
-- Hallazgo: 1 de los 6 productos del catalogo (Funda Silicona iPhone
-- 13, recien agregada) no tiene ninguna venta todavia; al ser un
-- accesorio de bajo precio, conviene ofrecerlo como cross-sell junto
-- al iPhone 13 en vez de tratarlo como stock en riesgo.

-- ------------------------------------------------------------
-- Consulta 4: Consolidado por canal (UNION ALL)
-- Proposito: comparar el total facturado por canal Online versus
-- Sucursal. La columna canal no se lee de ninguna tabla: se crea
-- como literal dentro de cada SELECT (el WHERE si usa la columna
-- real ventas.canal para separar los dos grupos de filas).
-- ------------------------------------------------------------
SELECT canal, SUM(total) AS total_canal
FROM (
    SELECT fecha_venta, total_venta AS total, 'Online' AS canal
    FROM ventas WHERE canal = 'Online'
    UNION ALL
    SELECT fecha_venta, total_venta AS total, 'Sucursal' AS canal
    FROM ventas WHERE canal = 'Sucursal'
) AS consolidado
GROUP BY canal;
-- Hallazgo: Sucursal factura mas que Online ($2.280.000 vs
-- $1.856.000, sobre un total de $4.136.000), es decir, Sucursal
-- concentra ~55% de la facturacion; el canal presencial sigue
-- siendo el mas fuerte pese al crecimiento del canal online.
