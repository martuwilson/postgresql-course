## Ejercicio 1:
Usando nuestra DB (employees y departments):

Traé el nombre del empleado, su departamento, su salario y una columna salary_category que clasifique:

Menos de 3000 → 'Junior'
Entre 3000 y 4000 → 'Mid'
Más de 4000 → 'Senior'

Pero solo mostrá los empleados de departamentos cuyo promedio de salario sea mayor a 3000.

```sql
select
	a.name,
	b.department_name,
	a.salary,
	CASE
		WHEN a.salary > 4000 then 'Senior'
		WHEN a.salary BETWEEN 3000 and 4000 then 'Mid'
		WHEN a.salary < 3000 then 'Junior'
		ELSE 'No info'
	END as salary_category
from employees a
INNER JOIN departments b ON a.department_id = b.id
where b.id IN (
	select department_id
	from employees
	group by
		department_id
	HAVING avg(salary) > 3000
);
```

## Ejercicio 2:
Traé el nombre, departamento, salario y el ranking de salario dentro de su departamento. Pero solo mostrá los empleados que están en el top 2 de su departamento.

```sql
WITH rank_employees as (
select
	a.name,
	b.department_name,
	a.salary,
	ROW_NUMBER() OVER (partition by b.department_name ORDER BY a.salary DESC) as rank_salary
	from employees a
INNER JOIN departments b ON a.department_id = b.id
)
SELECT *
FROM rank_employees
WHERE rank_salary <= 2;
```

### Ejercicio 3:
Traé el nombre, departamento, salario, el salario del empleado anterior dentro del mismo departamento ordenado por salario descendente, y la diferencia entre ambos salarios. Solo mostrá los empleados donde esa diferencia sea mayor a 500.

```sql
WITH rank_employees as (
select
    a.name,
    b.department_name,
    a.salary,
    LAG(a.salary) OVER (partition by b.department_name ORDER BY a.salary DESC) as previous_salary
    from employees a
INNER JOIN departments b ON a.department_id = b.id
)
SELECT *,
       salary - COALESCE(previous_salary, 0) as salary_difference
FROM rank_employees
WHERE salary - COALESCE(previous_salary, 0) > 500;
```

### Ejercicio 3; 

Traé el nombre del empleado, departamento, salario, y el ranking de salario dentro de su departamento. Solo mostrá los empleados que están en el top 2 de su departamento

```sql
with rank_salaries AS (
select
	a.name,
	b.department_name,
	a.salary,
	ROW_NUMBER() OVER (PARTITION BY b.department_name ORDER BY a.salary desc) as rank_salary
from employees a
inner join departments b ON a.department_id = b.id
)
SELECT *
from rank_salaries
WHERE rank_salary<= 2;
```

### Ejercicio 4:
Traé el nombre del departamento, promedio de salario y cantidad de empleados. Pero solo de los departamentos que tienen más de 2 empleados y cuyo promedio de salario esté entre 2800 y 4000.
Clasificalos además como:

'Pequeño' si tienen 3 empleados
'Mediano' si tienen 4 o más

```sql
select
	b.department_name,
	avg(a.salary) as avg_salary,
	count(*) as total_employees,
	CASE
		when count(*) = 3 then 'Pequeño'
		when count(*) >= 4 then 'Mediano'
		else 'no info'
	end as clasify
from employees a
inner join departments b on a.department_id = b.id
group by
	b.department_name
having count(*) > 2 and avg(a.salary) BETWEEN 2800 and 4000;
```