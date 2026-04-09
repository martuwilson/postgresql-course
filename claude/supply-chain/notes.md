

# Análisis: Supply Chain Orders

---

## Paso 1: Exploración inicial

**Ver todos los datos:**
```sql
SELECT * FROM supply_chain_orders;
```

**Ver columnas y tipos de datos:**
```sql
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'supply_chain_orders';
```

---

## Paso 1.5: Manejo de NULLs

**Filas con algún NULL en `actual_delivery` o `quantity_delivered`:**
```sql
SELECT *
FROM supply_chain_orders
WHERE actual_delivery IS NULL OR quantity_delivered IS NULL;
```

**Filas con ambos campos NULL al mismo tiempo:**
```sql
SELECT *
FROM supply_chain_orders
WHERE actual_delivery IS NULL AND quantity_delivered IS NULL;
```

> Se detectaron 2 NULLs: órdenes 3 y 9.
> Opciones:
> - Excluirlas (órdenes pendientes o canceladas no se cuentan)
> - Marcarlas como pendientes y reportar por separado
>
> **Decisión: excluirlas del análisis.**

---

## Paso 2: Calcular OTIF (On Time In Full)

**Definición:**

$$\text{OTIF} = \frac{\text{Órdenes entregadas a tiempo y completas}}{\text{Total de órdenes}} \times 100$$

Una orden cumple OTIF si:
- `actual_delivery <= expected_delivery` (entregada a tiempo)
- `quantity_delivered = quantity_ordered` (entregada completa)

**Query:**
```sql
SELECT
    supplier_name,
    ROUND(
        SUM(
            CASE
                WHEN actual_delivery <= expected_delivery
                AND quantity_delivered = quantity_ordered
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*), 2
    ) AS otif_percentage
FROM supply_chain_orders
WHERE actual_delivery IS NOT NULL
    AND quantity_delivered IS NOT NULL
GROUP BY supplier_name
ORDER BY otif_percentage DESC;
```

---

## Conclusión

> **SupplierB** tiene un OTIF crítico del **20%** — antes de tomar decisiones analizaría si es un problema de Lead Time, cantidad entregada o ambos.

