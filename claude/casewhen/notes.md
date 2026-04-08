## CASE / WHEN
Es lógica condicional dentro de una query — el equivalente a un if/else en SQL.

### Sintaxis general:
```sql
CASE
    WHEN condicion1 THEN resultado1
    WHEN condicion2 THEN resultado2
    ELSE resultado_default
END as alias
```
- `condicion`: Es una expresión que se evalúa como verdadera o falsa.
- `resultado`: Es el valor que se devuelve si la condición es verdadera.
### Ejemplo:
Supongamos que quieres clasificar a los empleados en categorías de salario: 'Alto', 'Medio' y 'Bajo'.
```sql
SELECT
    name,
    salary,
    CASE
        WHEN salary > 5000 THEN 'Alto'
        WHEN salary BETWEEN 3000 AND 5000 THEN 'Medio'
        ELSE 'Bajo'
    END as categoria_salario
FROM employees;
```

### Ejercicio 1:
Traé el nombre, salario y una columna nueva llamada salary_range que clasifique así:

Menos de 3000 → 'Junior'
Entre 3000 y 4000 → 'Mid'
Más de 4000 → 'Senior'

```sql
-- CASE WHEN: lógica condicional dentro de una query (if/else de SQL)
-- Útil para categorizar datos en reportes y dashboards

SELECT
    name,
    salary,
    CASE
        WHEN salary > 4000 THEN 'Senior'
        WHEN salary BETWEEN 3000 AND 4000 THEN 'Mid'
        WHEN salary < 3000 THEN 'Junior'
        ELSE 'no info'
    END as category_salary
FROM employees;
```

### Ejercicio 2:
Traé la cantidad de empleados por categoría (Junior, Mid, Senior) — usando el CASE WHEN dentro de un COUNT.

```sql
select
	COUNT(*) as total,
	CASE
		WHEN salary > 4000 THEN 'Senior'
		WHEN salary BETWEEN 3000 and 4000 then 'Mid'
		WHEN salary < 3000 then 'junior'
		else 'no info'
	END as category_salary
FROM employees
group by category_salary;
```
