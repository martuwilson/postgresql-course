## Common Table Expressions (CTEs)
### Que son:
Son consultas temporales que definís antes de la query principal usando WITH. Funcionan como una tabla temporal que solo existe durante esa consulta.

### Por que existen:
- Mejoran la legibilidad: Dividen consultas complejas en partes más manejables.
- Permiten reutilizar resultados intermedios: Puedes referenciar la CTE varias veces en la consulta principal.
- No necesitas de una subquery anidada: Evitan la necesidad de escribir subqueries dentro de otras subqueries, lo que puede hacer que el código sea difícil de leer.

### Sintaxis general:
Con subquery:
```sql
SELECT b.department_name, c.city
FROM (
    SELECT department_id, count(*) as total
    FROM employees
    GROUP BY department_id
) as conteo
INNER JOIN departments b ON conteo.department_id = b.id
```

Con CTE:
```sql
WITH conteo AS (
    SELECT department_id, count(*) as total
    FROM employees
    GROUP BY department_id
)
SELECT b.department_name, conteo.total
FROM conteo
INNER JOIN departments b ON conteo.department_id = b.id
```

## Sintaxis base:
```sql
WITH nombre_cte AS (
    -- query adentro
)
SELECT *
FROM nombre_cte;
```
### Ejercicio 1:
Usando un CTE, traé los departamentos que tienen promedio de salario mayor a 3000, mostrando el nombre del departamento y el promedio.

```sql
WITH salary_department AS (
	SELECT
	a.department_name,
	AVG(b.salary) as avg_salary
FROM departments a
INNER JOIN employees b ON a.id = b.department_id
group by
	a.department_name
)
SELECT *
from salary_department
where avg_salary > 3000
```