




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