## Tabla continentes
# selecciono los continentes distintos de la tabla country
```sql
select DISTINCT continent from country order by continent asc;
```

# 2: crear tabla continente (desde tableplus)

# 3: agregar los contienentes
```sql
insert into
  continent (name)
select DISTINCT
  continent
from
  country
order by
  continent asc;
```

## Relación, checks, respaldo de de country table

# Crear copia de la table country
```sql
create table country_backup as select * from country;
```
# drop del check de continent
```sql
alter table country drop constraint country_continent_check;
```

## Actualización Masiva

# Verificar datos entre tablas sin join
```sql
select
	a.name,
	a.continent,
	(select name from continent b where b.name = a.continent)
FROM
	country a
```

El codigo de arriba es para verificar que los datos de continent en country coincidan con los datos de name en continent, sin embargo, no es eficiente. Para actualizar los datos de continent en country, se puede usar un join.

# Actualizar datos de continent en country usando join
```sql
update country a
set continent = (select name from continent b where b.name = a.continent)
```
Este código actualiza los datos de continent en country con los datos de name en continent, asegurando que los datos sean consistentes entre ambas tablas.

# Actualizar tabla country para que aparezca el code de continent y no el nombre basado en la tabla continent (sin join)
```sql
update country a
set continent = (select "code" from continent b where b.name = a.continent)
```

El código de arriba actualiza la tabla country para que en lugar de mostrar el nombre del continente, muestre el código del continente basado en la tabla continent. Sin embargo, este código no es eficiente ya que hace una subconsulta para cada fila de la tabla country. Es mejor usar un join para actualizar los datos de continent en country.

# Actualizar tabla country para que aparezca el code de continent y no el nombre basado en la tabla continent (con join)
```sql
update country a
set continent = b.code
from continent b
where b.name = a.continent
```
Este código actualiza la tabla country para que en lugar de mostrar el nombre del continente, muestre el código del continente basado en la tabla continent, utilizando un join para mejorar la eficiencia de la consulta.

## Cambio de tipo de dato y llave foranea

# Cambiar tipo de dato de continent en country de text a int4
```sql
alter table country
alter COLUMN continent type int4
using continent::INTEGER; -- esto es para convertir los datos de continent a int4, ya que actualmente son text y no se pueden convertir directamente a int4 sin una conversión explícita.
```

El codigo de arriba cambia el tipo de dato de la columna continent en la tabla country de text a int4, utilizando una conversión explícita para asegurar que los datos se conviertan correctamente.

# Alternativas para cambiar el tipo de dato de continent en country de text a int4:
1- Crear una nueva columna con el tipo de dato int4, copiar los datos convertidos a la nueva columna, eliminar la columna original y renombrar la nueva columna.
```sql
alter table country
add COLUMN continent_int int4;
update country
set continent_int = continent::INTEGER;
alter table country
drop COLUMN continent;
alter table country
rename COLUMN continent_int to continent;
```
2- Crear una nueva tabla con el tipo de dato int4, copiar los datos convertidos a la nueva tabla, eliminar la tabla original y renombrar la nueva tabla.
```sql
create table country_new (
    code text,
    name text,
    continent int4,
    region text,
    surfacearea float8,
    indepyear int4,
    population int4,
    lifeexpectancy float8,
    gnp float8,
    gnpold float8,
    localname text,
    governmentform text,
    headOfState text,
    capital int4
);
insert into country_new (code, name, continent, region, surfacearea, indepyear, population, lifeexpectancy, gnp, gnpold, localname, governmentform, headOfState, capital)
select code, name, continent::INTEGER, region, surfacearea, indepyear, population, lifeexpectancy, gnp, gnpold, localname, governmentform, headOfState, capital
from country;
drop table country;
alter table country_new rename to country;
```

# Agregar FK en la tabla country, columna continent, referenciando a la columna code de la tabla continent
```sql
alter table country
add CONSTRAINT country_continent_fk 
FOREIGN KEY (continent) REFERENCES continent(code);
```
Esto tambien puede hacerse directo en table plus sin usar la query, pero es importante saber como hacerlo con query para entender el proceso.