

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
**Si no supiese que columnas tienen NULLS:**
```sql
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'supply_chain_orders'
  AND is_nullable = 'YES';
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

## Paso 3: Fill Rate por proveedor
**Definición:**
$$\text{Fill Rate} = \frac{\text{Cantidad entregada}}{\text{Cantidad ordenada}} \times 100$$

**Query:**
```sql
SELECT
	supplier_name,
	ROUND(SUM(quantity_delivered) * 100.0 / SUM(quantity_ordered), 2) as fill_rate
FROM supply_chain_orders
WHERE quantity_delivered IS NOT NULL
AND quantity_ordered IS NOT NULL
group by
	supplier_name
ORDER BY
	fill_rate desc;
```

## Conclusión:
> Dato interesante: **SupplierB** tiene OTIF **20%** pero Fill Rate **87%** — eso significa que el problema principal de SupplierB es de tiempo, no de cantidad. Llega tarde pero casi completo.

## Paso 4: Lead Time promedio por proveedor
**Definición:**
$$\text{Lead Time} = \text{Fecha de entrega} - \text{Fecha de orden}$$

**Query:**
```sql
    SELECT
	supplier_name,
	ROUND(
		AVG(
		actual_delivery - order_date
		)
	) as lead_time_days
FROM supply_chain_orders
WHERE actual_delivery IS NOT NULL and order_date IS NOT NULL
GROUP BY
	supplier_name
ORDER BY
	lead_time_days DESC;
```

## Conclusión:
> **SupplierC** es el mejor proveedor de todos los KPIs. Tiene OTIF **100%**, Fill Rate **100%** y Lead Time promedio de solo **7 días**. Es un proveedor confiable y rápido. **SupplierB** es el mas crítico, con OTIF **20%**, Fill Rate **87%** y Lead Time promedio de **9 días**. Es un proveedor que llega tarde pero casi completo. Sugiere un tema de puntualidad y no de cantidad. Recomendaría revisar acuerdos de entrega antes de omitir al proveedor. **SupplierA** tiene OTIF **75%**, Fill Rate **97%** y Lead Time promedio de **10 días**. Es un proveedor decente pero no tan bueno como SupplierC.