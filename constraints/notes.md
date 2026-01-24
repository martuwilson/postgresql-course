Introducción a las relaciones:

## Uno a uno (1:1)
Un registro de la tabla A se relaciona con exactamente un registro de la tabla B.
**Ejemplo:** Un usuario tiene un solo perfil, y un perfil pertenece a un solo usuario.

## Uno a muchos (1:N)
Un registro de la tabla A se puede relacionar con múltiples registros de la tabla B, pero un registro de B solo pertenece a un registro de A.
**Ejemplo:** Un autor puede escribir muchos libros, pero cada libro tiene un solo autor.

## Relaciones a sí mismas (Self-referencing)
Una tabla se relaciona consigo misma, donde un registro referencia a otro registro de la misma tabla.
**Ejemplo:** Una tabla de empleados donde cada empleado tiene un jefe (que también es un empleado).

## Muchos a muchos (N:M)
Múltiples registros de la tabla A se relacionan con múltiples registros de la tabla B. Requiere una tabla intermedia (tabla puente).
**Ejemplo:** Estudiantes y cursos - un estudiante puede tomar muchos cursos, y un curso puede tener muchos estudiantes.


## Keys - llaves

### Primary Key (Llave Primaria)
Identifica cada registro de forma única en una tabla. Solo puede haber una por tabla.
**Ejemplo:** El DNI en una tabla de personas, o el ID en una tabla de productos.

### Candidate Key (Llave Candidata)
Cualquier atributo o conjunto de atributos que pueden identificar un registro de forma única. Todas las que no fueron elegidas como Primary Key son Candidate Keys.
**Ejemplo:** En una tabla de usuarios, tanto el email como el username podrían ser llaves candidatas.

### Super Key
Cualquier combinación de atributos que identifica un registro de forma única. Puede incluir atributos innecesarios.
**Ejemplo:** En una tabla de empleados: {ID}, {ID, nombre}, {ID, nombre, apellido} son todas super keys.

### Foreign Key (Llave Foránea)
Campo que referencia la Primary Key de otra tabla, estableciendo una relación entre tablas.
**Ejemplo:** En una tabla de pedidos, el campo `user_id` que referencia al `id` de la tabla de usuarios.

### Composite Key (Llave Compuesta)
Primary Key formada por la combinación de dos o más columnas para identificar un registro de forma única.
**Ejemplo:** En una tabla de inscripciones: la combinación de `student_id` + `course_id` forma la llave primaria.

### Añadir Primary Key manualmente
```sql
ALTER TABLE country
ADD PRIMARY KEY (code);
```

