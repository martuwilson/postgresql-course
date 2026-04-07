




## Inner Join

Inner join devuelve solo las filas que tienen coincidencias en ambas tablas. Si una fila de la tabla A no tiene una coincidencia en la tabla B, esa fila no aparecerá en el resultado.

```sql
select
  a.name as country, -- nombre del país de la tabla country
  b.name as continent -- nombre del continente de la tabla continent
from
  country a
  inner join continent b on a.continent = b.code -- condición de join: el continente del país debe coincidir con el código del continente
order by
	a.name asc;
```
El codigo de arriba devuelve una lista de países junto con su continente, pero solo para aquellos países que tienen un continente válido en la tabla continent.

## Full Outer Join
Full outer join devuelve todas las filas de ambas tablas, combinando las filas coincidentes y llenando con NULL las filas que no tienen coincidencias en la otra tabla.

Para el ejemplo ya agregue en la db continentes inexistentes a la tabla country
```sql
SELECT
  a.name as country,
  a.continent as continentCode,
  b.name as continent_name
from
  country a
  full outer join continent b on a.continent = b.code;
```
El código de arriba devuelve una lista de países junto con su continente, incluyendo aquellos países que no tienen un continente válido (con continent_name como NULL) y aquellos continentes que no tienen países asociados (con country como NULL).

## Right Outer Join
Right outer join devuelve todas las filas de la tabla de la derecha (tabla B) y las filas coincidentes de la tabla de la izquierda (tabla A). Si una fila de la tabla B no tiene una coincidencia en la tabla A, esa fila aparecerá en el resultado con NULL en las columnas de la tabla A.

```sql
SELECT
  a.name as country,
  a.continent as continentCode,
  b.name as continent_name
from
  country a
  right outer join continent b on a.continent = b.code
where a.continent is null;
```
El código de arriba devuelve una lista de continentes junto con su país, pero solo para aquellos continentes que no tienen países asociados (con country como NULL).

## Aggregations + joins

```sql
select count(*), continent from country
group by continent
order by continent asc;
```
Eso solo devuelve el código del continente, pero no el nombre. Para obtener el nombre del continente, se puede hacer un join con la tabla continent.
Pero si uso un inner join, solo me va a devolver los continentes que tienen países asociados. 
```sql
select
  count(*),
  b.name
from
  country a
 inner join continent b on a.continent = b.code
group by
  b.name
order by
  b.name asc;
```
Luego con este código se obtiene el nombre del continente junto con la cantidad de países que pertenecen a cada continente, ordenados alfabéticamente por el nombre del continente.

## Full outer join
Si uso full outer join, me va a devolver todos los continentes, incluso aquellos que no tienen países asociados (con count(*) como 0). Pero aparece 1 porque uso un count(*), entonces para evitar eso, se puede usar un count(a.name) en lugar de count(*), ya que a.name solo contará las filas que tienen un país asociado.

```sql
select
  count(*),
  b.name
from
  country a
 full outer join continent b on a.continent = b.code
group by
  b.name
order by
  b.name asc;
```

con a.name, el código devuelve el nombre del continente junto con la cantidad de países que pertenecen a cada continente, incluyendo aquellos continentes que no tienen países asociados (con count(a.name) como 0).

```sql
select
  count(a.name),
  b.name
from
  country a
 full outer join continent b on a.continent = b.code
group by
  b.name
order by
  b.name asc;
```

## Con Right join
Si uso right outer join, me va a devolver todos los continentes, incluso aquellos que no tienen países asociados (con count(*) como 0). Pero aparece 1 porque uso un count(*), entonces para evitar eso, se puede usar un count(a.name) en lugar de count(*), ya que a.name solo contará las filas que tienen un país asociado.

```sql
select
  count(*),
  b.name
from
  country a
 right join continent b on a.continent = b.code
group by
  b.name
order by
  b.name asc;
```
El codigo de arriba devuelve el nombre del continente junto con la cantidad de países que pertenecen a cada continente, incluyendo aquellos continentes que no tienen países asociados (con count(*) como 0).