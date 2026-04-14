
# Paso 1: Limpieza de supplier.
Nombre con minúscula y espacios dobles y simples,etc.

```sql
select
	TRIM(
		LOWER(
		REPLACE(REPLACE(supplier, '__', ' '), '_', ' ')
		)
	) as supplier_name
from practice.raw_orders;
```

# Paso 2: Limpiar Region.

```sql
select
	CASE
    WHEN TRIM(LOWER(region)) = 'us4' THEN 'usa'
    WHEN TRIM(LOWER(region)) = 'eur0pe' THEN 'europe'
    ELSE TRIM(LOWER(region))
END as region
from practice.raw_orders;
```

# Paso 3: Limpiar el fechas que son columnas.

```sql
SELECT
    CASE
        WHEN order_date LIKE '__/__/____' 
            AND SPLIT_PART(order_date, '/', 1)::INT > 31 
            THEN NULL
        WHEN order_date LIKE '__/__/____' 
            AND SPLIT_PART(order_date, '/', 2)::INT > 12 
            THEN NULL
        WHEN order_date LIKE '__/__/____' 
            AND SPLIT_PART(order_date, '/', 1)::INT > 12 
            THEN TO_DATE(order_date, 'DD/MM/YYYY')
        WHEN order_date LIKE '__/__/____' 
            THEN TO_DATE(order_date, 'MM/DD/YYYY')
        WHEN order_date LIKE '____-__-__' 
            THEN TO_DATE(order_date, 'YYYY-MM-DD')
        WHEN order_date LIKE '__-__-____' 
            AND SPLIT_PART(order_date, '-', 1)::INT <= 12
            AND SPLIT_PART(order_date, '-', 2)::INT > 12
            THEN TO_DATE(order_date, 'MM-DD-YYYY')
        WHEN order_date LIKE '__-__-____' 
            THEN TO_DATE(order_date, 'DD-MM-YYYY')
        WHEN order_date LIKE '____/__/__' 
            THEN TO_DATE(order_date, 'YYYY/MM/DD')
        WHEN order_date LIKE '__-Mon-____' 
            THEN TO_DATE(order_date, 'DD-Mon-YYYY')
        WHEN order_date LIKE 'Mon __ ____' 
            THEN TO_DATE(order_date, 'Mon DD YYYY')
        ELSE NULL
    END as order_date
FROM practice.raw_orders;
```
```sql
SELECT
    CASE
        WHEN delivery_date LIKE '__/__/____' 
            AND SPLIT_PART(delivery_date, '/', 1)::INT > 31 
            THEN NULL
        WHEN delivery_date LIKE '__/__/____' 
            AND SPLIT_PART(delivery_date, '/', 2)::INT > 12 
            THEN NULL
        WHEN delivery_date LIKE '__/__/____' 
            AND SPLIT_PART(delivery_date, '/', 1)::INT > 12 
            THEN TO_DATE(delivery_date, 'DD/MM/YYYY')
        WHEN delivery_date LIKE '__/__/____' 
            THEN TO_DATE(delivery_date, 'MM/DD/YYYY')
        WHEN delivery_date LIKE '____-__-__' 
            THEN TO_DATE(delivery_date, 'YYYY-MM-DD')
        WHEN delivery_date LIKE '__-__-____' 
            AND SPLIT_PART(delivery_date, '-', 1)::INT <= 12
            AND SPLIT_PART(delivery_date, '-', 2)::INT > 12
            THEN TO_DATE(delivery_date, 'MM-DD-YYYY')
        WHEN delivery_date LIKE '__-__-____' 
            THEN TO_DATE(delivery_date, 'DD-MM-YYYY')
        WHEN delivery_date LIKE '____/__/__' 
            THEN TO_DATE(delivery_date, 'YYYY/MM/DD')
        WHEN delivery_date LIKE '__-Mon-____' 
            THEN TO_DATE(delivery_date, 'DD-Mon-YYYY')
        WHEN delivery_date LIKE 'Mon __ ____' 
            THEN TO_DATE(delivery_date, 'Mon DD YYYY')
        ELSE NULL
    END as delivery_date
FROM practice.raw_orders;
```

# Paso 4: Limpiar el ordered_quantity y delivered.

```sql
select
	CASE
		WHEN quantity_ordered::INT < 0 then null
		when quantity_ordered::int > 10000 then null
		else quantity_ordered::INT
		end as quantity_ordered
from practice.raw_orders;
```
```sql
select
	CASE
		WHEN quantity_delivered::INT < 0 THEN ABS(quantity_delivered::INT) -- hay un -180 que es un error de tipeo
		when quantity_delivered::int > 10000 then null
		else quantity_delivered::INT
		end as quantity_delivered
from practice.raw_orders;
```

# Paso 5: Limpiar el price.

```sql
SELECT
    CASE
        WHEN unit_price = 'N/A' THEN NULL
        WHEN REPLACE(REPLACE(unit_price, '$', ''), ',', '.')::DECIMAL < 0 THEN NULL
        WHEN REPLACE(REPLACE(unit_price, '$', ''), ',', '.')::DECIMAL = 0 THEN NULL
        ELSE REPLACE(REPLACE(unit_price, '$', ''), ',', '.')::DECIMAL
    END as unit_price
FROM practice.raw_orders;
```

# Paso 6: Limpiar el status.

```sql
select
	case
		WHEN LOWER(status) = 'deliverd' THEN 'delivered'
    	ELSE LOWER(status)
    end as status
 from practice.raw_orders;
```

# Paso 7: Crear la VIEW con toda la limpieza.

```sql
 CREATE VIEW practice.v_clean_orders AS
 WITH clean_data AS (
 	select
 		order_id,
		TRIM(
			LOWER(
			REPLACE(REPLACE(supplier, '__', ' '), '_', ' ')
			)
		) as supplier_name,
		CASE
    		WHEN TRIM(LOWER(region)) = 'us4' THEN 'usa'
    		WHEN TRIM(LOWER(region)) = 'eur0pe' THEN 'europe'
    		ELSE TRIM(LOWER(region))
		END as region,
		 CASE
        WHEN order_date LIKE '__/__/____' 
            AND SPLIT_PART(order_date, '/', 1)::INT > 31 
            THEN NULL
        WHEN order_date LIKE '__/__/____' 
            AND SPLIT_PART(order_date, '/', 2)::INT > 12 
            THEN NULL
        WHEN order_date LIKE '__/__/____' 
            AND SPLIT_PART(order_date, '/', 1)::INT > 12 
            THEN TO_DATE(order_date, 'DD/MM/YYYY')
        WHEN order_date LIKE '__/__/____' 
            THEN TO_DATE(order_date, 'MM/DD/YYYY')
        WHEN order_date LIKE '____-__-__' 
            THEN TO_DATE(order_date, 'YYYY-MM-DD')
        WHEN order_date LIKE '__-__-____' 
            AND SPLIT_PART(order_date, '-', 1)::INT <= 12
            AND SPLIT_PART(order_date, '-', 2)::INT > 12
            THEN TO_DATE(order_date, 'MM-DD-YYYY')
        WHEN order_date LIKE '__-__-____' 
            THEN TO_DATE(order_date, 'DD-MM-YYYY')
        WHEN order_date LIKE '____/__/__' 
            THEN TO_DATE(order_date, 'YYYY/MM/DD')
        WHEN order_date LIKE '__-Mon-____' 
            THEN TO_DATE(order_date, 'DD-Mon-YYYY')
        WHEN order_date LIKE 'Mon __ ____' 
            THEN TO_DATE(order_date, 'Mon DD YYYY')
        ELSE NULL
    END as order_date,
    CASE
        WHEN delivery_date LIKE '__/__/____' 
            AND SPLIT_PART(delivery_date, '/', 1)::INT > 31 
            THEN NULL
        WHEN delivery_date LIKE '__/__/____' 
            AND SPLIT_PART(delivery_date, '/', 2)::INT > 12 
            THEN NULL
        WHEN delivery_date LIKE '__/__/____' 
            AND SPLIT_PART(delivery_date, '/', 1)::INT > 12 
            THEN TO_DATE(delivery_date, 'DD/MM/YYYY')
        WHEN delivery_date LIKE '__/__/____' 
            THEN TO_DATE(delivery_date, 'MM/DD/YYYY')
        WHEN delivery_date LIKE '____-__-__' 
            THEN TO_DATE(delivery_date, 'YYYY-MM-DD')
        WHEN delivery_date LIKE '__-__-____' 
            AND SPLIT_PART(delivery_date, '-', 1)::INT <= 12
            AND SPLIT_PART(delivery_date, '-', 2)::INT > 12
            THEN TO_DATE(delivery_date, 'MM-DD-YYYY')
        WHEN delivery_date LIKE '__-__-____' 
            THEN TO_DATE(delivery_date, 'DD-MM-YYYY')
        WHEN delivery_date LIKE '____/__/__' 
            THEN TO_DATE(delivery_date, 'YYYY/MM/DD')
        WHEN delivery_date LIKE '__-Mon-____' 
            THEN TO_DATE(delivery_date, 'DD-Mon-YYYY')
        WHEN delivery_date LIKE 'Mon __ ____' 
            THEN TO_DATE(delivery_date, 'Mon DD YYYY')
        ELSE NULL
    END as delivery_date,
    CASE
		WHEN quantity_ordered::INT < 0 then null
		when quantity_ordered::int > 10000 then null
		else quantity_ordered::INT
		end as quantity_ordered,
		CASE
		WHEN quantity_delivered::INT < 0 THEN ABS(quantity_delivered::INT) -- hay un -180 que es un error de tipeo
		when quantity_delivered::int > 10000 then null
		else quantity_delivered::INT
		end as quantity_delivered,
		CASE
        WHEN unit_price = 'N/A' THEN NULL
        WHEN REPLACE(REPLACE(unit_price, '$', ''), ',', '.')::DECIMAL < 0 THEN NULL
        WHEN REPLACE(REPLACE(unit_price, '$', ''), ',', '.')::DECIMAL = 0 THEN NULL
        ELSE REPLACE(REPLACE(unit_price, '$', ''), ',', '.')::DECIMAL
    END as unit_price,
    case
		WHEN LOWER(status) = 'deliverd' THEN 'delivered'
    	ELSE LOWER(status)
    end as status
	from practice.raw_orders
 )
 select * from clean_data;

 select * from practice.v_clean_orders;
```

# Paso 8: Crear OTIF
-- criterios personales: status = delivered / quantity_delivered = quantity_ordered / delivery_date - order_date <= 7

```sql
select
	ROUND(SUM(CASE 
            WHEN status = 'delivered'
            AND quantity_delivered = quantity_ordered
            AND delivery_date - order_date <= 7
            THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)::INT AS otif_percentage
from practice.v_clean_orders;
```

# Paso 9: Lead time por proveedor

```sql
select
	supplier_name,
	ROUND(avg(delivery_date - order_date))::INT as lead_time
from practice.v_clean_orders
group by
	supplier_name
order by
	lead_time desc;
```

# Paso 10: Fill Rate

```sql
select
	supplier_name,
	avg(quantity_delivered / quantity_ordered * 100)::INT as fill_rate
from practice.v_clean_orders
group by
	supplier_name;
```

# Paso 11: Unificación de KPIs

```sql
CREATE VIEW practice.v_clean_orders_kpis AS
with kpi as (
	SELECT
		supplier_name,
		ROUND(SUM(CASE 
            WHEN status = 'delivered'
            AND quantity_delivered = quantity_ordered
            AND delivery_date - order_date <= 7
            THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)::INT AS otif_percentage,
            ROUND(avg(delivery_date - order_date))::INT as lead_time,
            avg(quantity_delivered / quantity_ordered * 100)::INT as fill_rate
    from practice.v_clean_orders
	group by
		supplier_name
)
select *
from kpi
order by
	lead_time desc;
	
select * from practice.v_clean_orders_kpis;
```

## IMPORTANTE: Ahora unificar vistas usando INNER JOIN basado en supplier_name para tener una vista con toda la información limpia y los KPIs juntos. Esto es fundamental para análisis futuros y para facilitar el acceso a la información.

```sql
select
(a.*),
b.fill_rate,
b.lead_time,
b.otif_percentage
from practice.v_clean_orders a
inner join practice.v_clean_orders_kpis b on a.supplier_name = b.supplier_name;
```


# Paso final: view final:

```sql
CREATE VIEW practice.v_final_orders AS
SELECT
    a.*,
    b.fill_rate,
    b.lead_time,
    b.otif_percentage
FROM practice.v_clean_orders a
INNER JOIN practice.v_clean_orders_kpis b ON a.supplier_name = b.supplier_name;

select * from practice.v_final_orders;
```