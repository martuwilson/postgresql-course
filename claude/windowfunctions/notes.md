## Que son las Window Functions?
Las window functions te permiten hacer cálculos sobre un conjunto de filas relacionadas a la fila actual, sin colapsar el resultado como hace GROUP BY.

Por ejemplo:
Si quieres calcular el promedio de ventas por departamento, pero también quieres mostrar cada venta individual, las window functions te permiten hacer eso.

## Diferencia clave:
- **GROUP BY**: Agrupa filas y devuelve una fila por grupo. No puedes mostrar datos individuales dentro de cada grupo.

-- GROUP BY colapsa → perdés las filas individuales
```sql
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id;
```

- **Window Functions**: Calculan valores para cada fila basándose en un conjunto de filas relacionadas (la "ventana"), pero no colapsan los resultados. Puedes mostrar datos individuales y agregados al mismo tiempo.
-- Window Function → mantenés todas las filas Y agregás el cálculo
```sql
SELECT name, department_id, salary,
AVG(salary) OVER (PARTITION BY department_id)
FROM employees;
```

## Sintaxis general de una Window Function:
```sql
function() OVER (PARTITION BY columna ORDER BY columna)
``` 
- `function()`: La función de agregación o analítica que quieres usar (ej. `AVG()`, `SUM()`, `ROW_NUMBER()`, etc.).
- `OVER`: Indica que estás usando una window function.
- `PARTITION BY`: Divide las filas en particiones sobre las cuales se aplicará la función.
- `ORDER BY`: Especifica el orden de las filas dentro de cada partición.

# Las 4 más importantes Window Functions:
1. `ROW_NUMBER()`: Asigna un número de fila único a cada fila dentro de su partición, comenzando en 1.
2. `RANK()`: Asigna un número de fila a cada fila dentro de su partición, pero las filas con valores iguales reciben el mismo número de fila, y se saltan los números siguientes.
3. `LAG()`: Permite acceder a una fila anterior a la fila actual dentro de la misma partición.
4. `LEAD()`: Permite acceder a una fila siguiente a la fila actual dentro de la misma partición.

Ejercicio 1:
Con la DB que acabamos de crear (init.sql):

Traé el nombre, departamento, salario y el salario promedio de su departamento en la misma fila.
```sql
-- Window Function: promedio de salario por departamento
-- PARTITION BY agrupa sin colapsar filas (a diferencia de GROUP BY)
SELECT
    a.name,
    b.department_name,
    a.salary,
    AVG(a.salary) OVER (PARTITION BY b.department_name) as avg_salary
FROM employees a
INNER JOIN departments b ON a.department_id = b.id;
```

Ejercicio 2:
Traé el nombre, departamento, salario y un ranking de salario dentro de cada departamento — el que más gana es el #1.
```sql
-- ROW_NUMBER: ranking de salario dentro de cada departamento
-- ROW_NUMBER() no recibe argumentos, el orden lo define el ORDER BY
SELECT
    a.name,
    b.department_name,
    a.salary,
    ROW_NUMBER() OVER (PARTITION BY b.department_name ORDER BY a.salary DESC) as rank_salary
FROM employees a
INNER JOIN departments b ON a.department_id = b.id;
```

Una diferencia clave entre `ROW_NUMBER()` y `RANK()` es cómo manejan los empates:
```sql
SELECT
    a.name,
    b.department_name,
    a.salary,
    ROW_NUMBER() OVER (PARTITION BY b.department_name ORDER BY a.salary DESC) as row_num,
    RANK() OVER (PARTITION BY b.department_name ORDER BY a.salary DESC) as rank_num
FROM employees a
INNER JOIN departments b ON a.department_id = b.id;
```
En este ejemplo, si dos empleados tienen el mismo salario, `ROW_NUMBER()` les asignará números de fila diferentes (1 y 2), mientras que `RANK()` les asignará el mismo número de fila (1) y saltará al siguiente número (3 para el siguiente empleado).


## LAG() y LEAD()
Estas funciones te permiten acceder a filas anteriores o siguientes dentro de la misma partición.

Sintaxis LAG():
```sql
LAG(columna, offset, default) OVER (PARTITION BY columna ORDER BY columna)
```
- `columna`: La columna de la cual quieres obtener el valor.
- `offset`: Cuántas filas hacia atrás quieres mirar (por defecto es 1).
- `default`: El valor que se devuelve si no hay suficientes filas hacia atrás (por defecto es NULL).

Caso de uso: 
Supongamos que quieres comparar el salario de cada empleado con el salario del empleado anterior en su departamento:
```sql
select
  a.name,
  b.department_name,
  a.salary,
  LAG(a.salary, 1, 0) OVER ( -- 1 fila hacia atrás, default 0 si no hay fila anterior
    PARTITION BY
      b.department_name
    ORDER BY
      a.salary DESC
  ) as prev_salary
from
  employees a
  inner join departments b ON a.department_id = b.id;
```