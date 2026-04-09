

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


# Caso 2
## Paso 1: Limpiar supplier_name con varios formatos
**Query:**
```sql
select
	supplier_name as original,
	UPPER(
		REPLACE(supplier_name, '_', '')
	) as normalizado
FROM supply_chain_dirty;
```

## Paso 2: Lo mismo con region
```sql
Select
	region as original,
	UPPER(
		region
	) as normalizado
FROM supply_chain_dirty;
```

## Paso 3: Formatear fechas

```sql
SELECT
    order_date as original_order,
    expected_delivery as original_expected,
    actual_delivery as original_actual,
    CASE
        WHEN order_date LIKE '__/__/____' AND SPLIT_PART(order_date, '/', 1)::INT > 12 
            THEN TO_DATE(order_date, 'DD/MM/YYYY')
        WHEN order_date LIKE '__/__/____' 
            THEN TO_DATE(order_date, 'MM/DD/YYYY')
        WHEN order_date LIKE '__-__-____' 
            THEN TO_DATE(order_date, 'DD-MM-YYYY')
        WHEN order_date LIKE '____-__-__' 
            THEN TO_DATE(order_date, 'YYYY-MM-DD')
    END as order_date_clean,
    CASE
        WHEN expected_delivery LIKE '__/__/____' AND SPLIT_PART(expected_delivery, '/', 1)::INT > 12 
            THEN TO_DATE(expected_delivery, 'DD/MM/YYYY')
        WHEN expected_delivery LIKE '__/__/____' 
            THEN TO_DATE(expected_delivery, 'MM/DD/YYYY')
        WHEN expected_delivery LIKE '__-__-____' 
            THEN TO_DATE(expected_delivery, 'DD-MM-YYYY')
        WHEN expected_delivery LIKE '____-__-__' 
            THEN TO_DATE(expected_delivery, 'YYYY-MM-DD')
    END as expected_delivery_clean,
    CASE
        WHEN actual_delivery LIKE '__/__/____' AND SPLIT_PART(actual_delivery, '/', 1)::INT > 12 
            THEN TO_DATE(actual_delivery, 'DD/MM/YYYY')
        WHEN actual_delivery LIKE '__/__/____' 
            THEN TO_DATE(actual_delivery, 'MM/DD/YYYY')
        WHEN actual_delivery LIKE '__-__-____' 
            THEN TO_DATE(actual_delivery, 'DD-MM-YYYY')
        WHEN actual_delivery LIKE '____-__-__' 
            THEN TO_DATE(actual_delivery, 'YYYY-MM-DD')
    END as actual_delivery_clean
FROM supply_chain_dirty;
```

## Paso 4: CTE de limpieza de todo lo anterior junto
```sql
WITH cleaned_data AS (
    SELECT
        UPPER(REPLACE(supplier_name, '_', '')) as supplier_name,
        UPPER(region) as region,
        CASE
            WHEN order_date LIKE '__/__/____' AND SPLIT_PART(order_date, '/', 1)::INT > 12 
                THEN TO_DATE(order_date, 'DD/MM/YYYY')
            WHEN order_date LIKE '__/__/____' 
                THEN TO_DATE(order_date, 'MM/DD/YYYY')
            WHEN order_date LIKE '__-__-____' 
                THEN TO_DATE(order_date, 'DD-MM-YYYY')
            WHEN order_date LIKE '____-__-__' 
                THEN TO_DATE(order_date, 'YYYY-MM-DD')
        END as order_date,
        CASE
            WHEN expected_delivery LIKE '__/__/____' AND SPLIT_PART(expected_delivery, '/', 1)::INT > 12 
                THEN TO_DATE(expected_delivery, 'DD/MM/YYYY')
            WHEN expected_delivery LIKE '__/__/____' 
                THEN TO_DATE(expected_delivery, 'MM/DD/YYYY')
            WHEN expected_delivery LIKE '__-__-____' 
                THEN TO_DATE(expected_delivery, 'DD-MM-YYYY')
            WHEN expected_delivery LIKE '____-__-__' 
                THEN TO_DATE(expected_delivery, 'YYYY-MM-DD')
        END as expected_delivery,
        CASE
            WHEN actual_delivery LIKE '__/__/____' AND SPLIT_PART(actual_delivery, '/', 1)::INT > 12 
                THEN TO_DATE(actual_delivery, 'DD/MM/YYYY')
            WHEN actual_delivery LIKE '__/__/____' 
                THEN TO_DATE(actual_delivery, 'MM/DD/YYYY')
            WHEN actual_delivery LIKE '__-__-____' 
                THEN TO_DATE(actual_delivery, 'DD-MM-YYYY')
            WHEN actual_delivery LIKE '____-__-__' 
                THEN TO_DATE(actual_delivery, 'YYYY-MM-DD')
        END as actual_delivery,
        quantity_ordered,
        quantity_delivered
    FROM supply_chain_dirty
    WHERE actual_delivery IS NOT NULL AND quantity_delivered IS NOT NULL AND quantity_delivered > 0
)
SELECT *
FROM cleaned_data;
```

## Paso 4: Agregar CTE de OTIF
```sql
WITH cleaned_data AS (
    SELECT
        UPPER(REPLACE(supplier_name, '_', '')) as supplier_name,
        UPPER(region) as region,
        CASE
            WHEN order_date LIKE '__/__/____' AND SPLIT_PART(order_date, '/', 1)::INT > 12 
                THEN TO_DATE(order_date, 'DD/MM/YYYY')
            WHEN order_date LIKE '__/__/____' 
                THEN TO_DATE(order_date, 'MM/DD/YYYY')
            WHEN order_date LIKE '__-__-____' 
                THEN TO_DATE(order_date, 'DD-MM-YYYY')
            WHEN order_date LIKE '____-__-__' 
                THEN TO_DATE(order_date, 'YYYY-MM-DD')
        END as order_date,
        CASE
            WHEN expected_delivery LIKE '__/__/____' AND SPLIT_PART(expected_delivery, '/', 1)::INT > 12 
                THEN TO_DATE(expected_delivery, 'DD/MM/YYYY')
            WHEN expected_delivery LIKE '__/__/____' 
                THEN TO_DATE(expected_delivery, 'MM/DD/YYYY')
            WHEN expected_delivery LIKE '__-__-____' 
                THEN TO_DATE(expected_delivery, 'DD-MM-YYYY')
            WHEN expected_delivery LIKE '____-__-__' 
                THEN TO_DATE(expected_delivery, 'YYYY-MM-DD')
        END as expected_delivery,
        CASE
            WHEN actual_delivery LIKE '__/__/____' AND SPLIT_PART(actual_delivery, '/', 1)::INT > 12 
                THEN TO_DATE(actual_delivery, 'DD/MM/YYYY')
            WHEN actual_delivery LIKE '__/__/____' 
                THEN TO_DATE(actual_delivery, 'MM/DD/YYYY')
            WHEN actual_delivery LIKE '__-__-____' 
                THEN TO_DATE(actual_delivery, 'DD-MM-YYYY')
            WHEN actual_delivery LIKE '____-__-__' 
                THEN TO_DATE(actual_delivery, 'YYYY-MM-DD')
        END as actual_delivery,
        quantity_ordered,
        quantity_delivered
    FROM supply_chain_dirty
    WHERE actual_delivery IS NOT NULL AND quantity_delivered IS NOT NULL AND quantity_delivered > 0
),
otif_calculation AS (
    SELECT
        supplier_name,
        region,
        ROUND(
            SUM(
                CASE
                    WHEN actual_delivery <= expected_delivery
                    AND quantity_delivered = quantity_ordered
                    THEN 1 ELSE 0
                END
            ) * 100.0 / COUNT(*), 2
        ) AS otif_percentage
    FROM cleaned_data
    GROUP BY supplier_name, region
)
SELECT *
FROM otif_calculation;
```

## Paso 5: Agregar Fill Rate
```sql
WITH cleaned_data AS (
    SELECT
        UPPER(REPLACE(supplier_name, '_', '')) as supplier_name,
        UPPER(region) as region,
        CASE
            WHEN order_date LIKE '__/__/____' AND SPLIT_PART(order_date, '/', 1)::INT > 12 
                THEN TO_DATE(order_date, 'DD/MM/YYYY')
            WHEN order_date LIKE '__/__/____' 
                THEN TO_DATE(order_date, 'MM/DD/YYYY')
            WHEN order_date LIKE '__-__-____' 
                THEN TO_DATE(order_date, 'DD-MM-YYYY')
            WHEN order_date LIKE '____-__-__' 
                THEN TO_DATE(order_date, 'YYYY-MM-DD')
        END as order_date,
        CASE
            WHEN expected_delivery LIKE '__/__/____' AND SPLIT_PART(expected_delivery, '/', 1)::INT > 12 
                THEN TO_DATE(expected_delivery, 'DD/MM/YYYY')
            WHEN expected_delivery LIKE '__/__/____' 
                THEN TO_DATE(expected_delivery, 'MM/DD/YYYY')
            WHEN expected_delivery LIKE '__-__-____' 
                THEN TO_DATE(expected_delivery, 'DD-MM-YYYY')
            WHEN expected_delivery LIKE '____-__-__' 
                THEN TO_DATE(expected_delivery, 'YYYY-MM-DD')
        END as expected_delivery,
        CASE
            WHEN actual_delivery LIKE '__/__/____' AND SPLIT_PART(actual_delivery, '/', 1)::INT > 12 
                THEN TO_DATE(actual_delivery, 'DD/MM/YYYY')
            WHEN actual_delivery LIKE '__/__/____' 
                THEN TO_DATE(actual_delivery, 'MM/DD/YYYY')
            WHEN actual_delivery LIKE '__-__-____' 
                THEN TO_DATE(actual_delivery, 'DD-MM-YYYY')
            WHEN actual_delivery LIKE '____-__-__' 
                THEN TO_DATE(actual_delivery, 'YYYY-MM-DD')
        END as actual_delivery,
        quantity_ordered,
        quantity_delivered
    FROM supply_chain_dirty
    WHERE actual_delivery IS NOT NULL AND quantity_delivered IS NOT NULL AND quantity_delivered > 0
),
otif_calculation AS (
    SELECT
        supplier_name,
        region,
        ROUND(
            SUM(
                CASE
                    WHEN actual_delivery <= expected_delivery
                    AND quantity_delivered = quantity_ordered
                    THEN 1 ELSE 0
                END
            ) * 100.0 / COUNT(*), 2
        ) AS otif_percentage,
        ROUND(SUM(quantity_delivered) * 100.0 / SUM(quantity_ordered), 2) as fill_rate
    FROM cleaned_data
    GROUP BY supplier_name, region
)
SELECT *
FROM otif_calculation;
```

## Paso 6: Agregar Lead Time
```sql
WITH cleaned_data AS (
    SELECT
        UPPER(REPLACE(supplier_name, '_', '')) as supplier_name,
        UPPER(region) as region,
        CASE
            WHEN order_date LIKE '__/__/____' AND SPLIT_PART(order_date, '/', 1)::INT > 12 
                THEN TO_DATE(order_date, 'DD/MM/YYYY')
            WHEN order_date LIKE '__/__/____' 
                THEN TO_DATE(order_date, 'MM/DD/YYYY')
            WHEN order_date LIKE '__-__-____' 
                THEN TO_DATE(order_date, 'DD-MM-YYYY')
            WHEN order_date LIKE '____-__-__' 
                THEN TO_DATE(order_date, 'YYYY-MM-DD')
        END as order_date,
        CASE
            WHEN expected_delivery LIKE '__/__/____' AND SPLIT_PART(expected_delivery, '/', 1)::INT > 12 
                THEN TO_DATE(expected_delivery, 'DD/MM/YYYY')
            WHEN expected_delivery LIKE '__/__/____' 
                THEN TO_DATE(expected_delivery, 'MM/DD/YYYY')
            WHEN expected_delivery LIKE '__-__-____' 
                THEN TO_DATE(expected_delivery, 'DD-MM-YYYY')
            WHEN expected_delivery LIKE '____-__-__' 
                THEN TO_DATE(expected_delivery, 'YYYY-MM-DD')
        END as expected_delivery,
        CASE
            WHEN actual_delivery LIKE '__/__/____' AND SPLIT_PART(actual_delivery, '/', 1)::INT > 12 
                THEN TO_DATE(actual_delivery, 'DD/MM/YYYY')
            WHEN actual_delivery LIKE '__/__/____' 
                THEN TO_DATE(actual_delivery, 'MM/DD/YYYY')
            WHEN actual_delivery LIKE '__-__-____' 
                THEN TO_DATE(actual_delivery, 'DD-MM-YYYY')
            WHEN actual_delivery LIKE '____-__-__' 
                THEN TO_DATE(actual_delivery, 'YYYY-MM-DD')
        END as actual_delivery,
        quantity_ordered,
        quantity_delivered
    FROM supply_chain_dirty
    WHERE actual_delivery IS NOT NULL AND quantity_delivered IS NOT NULL AND quantity_delivered > 0
),
otif_calculation AS (
    SELECT
        supplier_name,
        region,
        ROUND(
            SUM(
                CASE
                    WHEN actual_delivery <= expected_delivery
                    AND quantity_delivered = quantity_ordered
                    THEN 1 ELSE 0
                END
            ) * 100.0 / COUNT(*), 2
        ) AS otif_percentage,
        ROUND(SUM(quantity_delivered) * 100.0 / SUM(quantity_ordered), 2) as fill_rate,
        ROUND(AVG(actual_delivery - order_date)) as lead_time_days
    FROM cleaned_data
    GROUP BY supplier_name, region
)
SELECT *
FROM otif_calculation;
```
## Conclusión final

| Proveedor | Estado | Detalle |
|-----------|--------|---------|
| **SUPPLIERC** | ✅ Mejor proveedor | Referencia para negociar estándares con los demás. |
| **SUPPLIERA** | ⚠️ Sólido en general | Brecha entre LATAM (75%) y Europe (100%) en OTIF merece investigación — puede ser logística regional. |
| **SUPPLIERB** | 🔴 Proveedor crítico | OTIF 0% en LATAM y Europe con Fill Rate aceptable indica que el problema es de **puntualidad, no de cantidad**. Recomendaría revisar acuerdos de entrega antes de considerar cambio de proveedor. Lead Time de 13 días en Europe es el más alto — correlaciona con el OTIF bajo. |

---

## ⚠️ Data Quality Finding

> Durante la limpieza detectamos fechas con formato ambiguo — cuando el día es ≤ 12 no es posible determinar automáticamente si el formato es `DD/MM` o `MM/DD`. Esto generó un **Lead Time negativo en SUPPLIERC USA**.
>
> **Recomendación:** establecer un estándar de formato de fechas con el equipo de datos antes de procesar futuros reportes.

## Importante:
Para que POWER BI lea la data limpia directamente lo recomendable es hacer una VIEW con el código del paso 6, así cada vez que se actualice la tabla `supply_chain_dirty` la VIEW se actualizará automáticamente con los datos limpios y los KPIs calculados.

```sql
CREATE VIEW supply_chain.v_clean_kpis AS
WITH cleaned_data AS (
    SELECT
        UPPER(REPLACE(supplier_name, '_', '')) as supplier_name,
        UPPER(region) as region,
        CASE
            WHEN order_date LIKE '__/__/____' AND SPLIT_PART(order_date, '/', 1)::INT > 12 
                THEN TO_DATE(order_date, 'DD/MM/YYYY')
            WHEN order_date LIKE '__/__/____' 
                THEN TO_DATE(order_date, 'MM/DD/YYYY')
            WHEN order_date LIKE '__-__-____' 
                THEN TO_DATE(order_date, 'DD-MM-YYYY')
            WHEN order_date LIKE '____-__-__' 
                THEN TO_DATE(order_date, 'YYYY-MM-DD')
        END as order_date,
        CASE
            WHEN expected_delivery LIKE '__/__/____' AND SPLIT_PART(expected_delivery, '/', 1)::INT > 12 
                THEN TO_DATE(expected_delivery, 'DD/MM/YYYY')
            WHEN expected_delivery LIKE '__/__/____' 
                THEN TO_DATE(expected_delivery, 'MM/DD/YYYY')
            WHEN expected_delivery LIKE '__-__-____' 
                THEN TO_DATE(expected_delivery, 'DD-MM-YYYY')
            WHEN expected_delivery LIKE '____-__-__' 
                THEN TO_DATE(expected_delivery, 'YYYY-MM-DD')
        END as expected_delivery,
        CASE
            WHEN actual_delivery LIKE '__/__/____' AND SPLIT_PART(actual_delivery, '/', 1)::INT > 12 
                THEN TO_DATE(actual_delivery, 'DD/MM/YYYY')
            WHEN actual_delivery LIKE '__/__/____' 
                THEN TO_DATE(actual_delivery, 'MM/DD/YYYY')
            WHEN actual_delivery LIKE '__-__-____' 
                THEN TO_DATE(actual_delivery, 'DD-MM-YYYY')
            WHEN actual_delivery LIKE '____-__-__' 
                THEN TO_DATE(actual_delivery, 'YYYY-MM-DD')
        END as actual_delivery,
        quantity_ordered,
        quantity_delivered
    FROM supply_chain_dirty
    WHERE actual_delivery IS NOT NULL 
    AND quantity_delivered IS NOT NULL 
    AND quantity_delivered > 0
),
kpis AS (
    SELECT
        supplier_name,
        region,
        ROUND(SUM(CASE 
            WHEN actual_delivery <= expected_delivery
            AND quantity_delivered = quantity_ordered
            THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS otif_percentage,
        ROUND(SUM(quantity_delivered) * 100.0 / SUM(quantity_ordered), 2) as fill_rate,
        ROUND(AVG(actual_delivery - order_date)) as lead_time_days
    FROM cleaned_data
    GROUP BY supplier_name, region
)
SELECT * FROM kpis;
```