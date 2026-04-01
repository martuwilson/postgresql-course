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