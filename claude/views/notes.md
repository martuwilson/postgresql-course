## VIEWS

Una vista es una query guardada como si fuera una tabla. No almacena data — cada vez que la consultás ejecuta la query por detrás. Es útil para:
- Simplificar consultas complejas: Puedes escribir una consulta complicada una vez, guardarla como vista, y luego consultarla fácilmente.
- Reutilizar lógica de negocio: Si tienes una lógica de negocio que se repite en varias consultas, puedes encapsularla en una vista.
- Controlar acceso a datos: Puedes dar permisos a los usuarios para acceder a una vista sin darles acceso directo a las tablas subyacentes.

"## Sintaxis para crear una vista:
```sql
CREATE VIEW nombre_vista AS
SELECT ...
FROM ...
WHERE ...;
```
Despues se usa como si fuese una tabla
```sql
SELECT *
FROM nombre_vista;
```

Para borrarla:
```sql
DROP VIEW nombre_vista;
```

### Ejercicio 1: 
Creá una vista llamada v_employee_department que muestre el nombre del empleado, su departamento y su salario. Después consultala.

```sql
CREATE VIEW v_employee_department AS
SELECT
	a.name,
	b.department_name,
	a.salary
FROM employees a
INNER JOIN departments b ON a.department_id = b.id;

select * from v_employee_department;
```
 la query compleja con JOIN queda escondida y la consultás con un simple SELECT * FROM v_employee_department.

### Ejercicio 2:
Creá una vista llamada v_senior_employees que muestre solo los empleados con salario mayor a 3500, con su nombre, departamento y salario. Después consultala filtrando solo los de Buenos Aires.

```sql
CREATE VIEW v_senior_employees AS
SELECT
    a.name,
    b.department_name,
    b.location,
    a.salary
FROM employees a
INNER JOIN departments b ON a.department_id = b.id
WHERE a.salary > 3500;

SELECT * FROM v_senior_employees
WHERE location = 'Buenos Aires';
```