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