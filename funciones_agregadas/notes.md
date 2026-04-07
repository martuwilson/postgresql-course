# Notas: Funciones Agregadas en PostgreSQL

---

## 1. Filtrado con `AND` y `BETWEEN`

Filtrar usuarios con `following >= 4600` y `followers <= 4700`:

```sql
SELECT
    first_name,
    last_name,
    followers
FROM users
WHERE "following" >= 4600
    AND followers <= 4700
ORDER BY followers ASC;
```

Lo mismo usando `BETWEEN` (más conciso, aplica sobre la misma columna):

```sql
SELECT
    first_name,
    last_name,
    followers
FROM users
WHERE followers BETWEEN 4600 AND 4700
ORDER BY followers ASC;
```

---

## 2. Funciones de Agregación: `MIN`, `MAX`, `COUNT`, `AVG`, `SUM`

**Contar registros:**
```sql
SELECT count(*) AS total_users FROM users;
```

**Mínimo de followers:**
```sql
SELECT min(followers) AS min_followers FROM users;
```

**Máximo de followers:**
```sql
SELECT max(followers) AS max_followers FROM users;
```

**Promedio de followers:**
```sql
SELECT AVG(followers) AS avg_followers FROM users;
```

**Promedio manual:**
```sql
SELECT sum(followers) / count(*) AS avg_manual FROM users;
```

**Promedio redondeado:**
```sql
SELECT round(AVG(followers)) AS avg_followers FROM users;
```

---

## 3. `GROUP BY`

**Ejemplo 1** — Sin agrupación (solo muestra datos):
```sql
SELECT first_name, last_name, followers
FROM users
WHERE followers = 4 OR followers = 4999;
```

**Ejemplo 1 correcto** — Agrupa y cuenta cuántos tienen exactamente 4 y 4999 followers:
```sql
SELECT count(*), followers
FROM users
WHERE followers = 4 OR followers = 4999
GROUP BY followers;
```

**Ejemplo 2** — Cuenta usuarios por cantidad exacta de followers entre 4500 y 4700:
```sql
SELECT count(*), followers
FROM users
WHERE followers BETWEEN 4500 AND 4700
GROUP BY followers
ORDER BY followers DESC;
```

---

## 4. Terminología y Estructuras

**DBA:** Data Base Administrator

| Sigla | Nombre completo | Comandos |
|-------|----------------|----------|
| **DDL** | Data Definition Language | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` |
| **DML** | Data Manipulation Language | `INSERT`, `DELETE`, `UPDATE` |
| **TCL** | Transaction Control Language | `COMMIT`, `ROLLBACK` |
| **DQL** | Data Query Language | `SELECT` |

---

## 5. Aggregate Functions & Filtering — Resumen

**Funciones adicionales:**
- `HAVING` — funciona de la mano con `GROUP BY`
- `ORDER BY`

**Operadores de filtrado:**

| Operador | Descripción |
|----------|-------------|
| `LIKE` | Filtrado por expresión/patrón |
| `IN` | Dentro de una serie de opciones |
| `IS NULL` | La columna es nula |
| `IS NOT NULL` | La columna no es nula |
| `AND` | Ambas condiciones deben ser TRUE |
| `OR` | Al menos una condición debe ser TRUE |
| `BETWEEN` | Valor entre dos límites |

---

## 6. Estructura General del `SELECT`

```sql
SELECT *, campos, alias, funciones
WHERE condiciones, AND, OR, IN, LIKE
GROUP BY campo_agrupador, ALL
HAVING condicion
ORDER BY expresion, ASC, DESC
LIMIT valor, ALL
OFFSET punto_de_inicio
```

---

## 7. `HAVING`

**Contar personas por país:**
```sql
SELECT count(*), country
FROM users
GROUP BY country
ORDER BY country ASC;
```

**Filtrar países con entre 6 y 10 usuarios (`HAVING`):**
```sql
SELECT count(*) AS total, country
FROM users
GROUP BY country
HAVING count(*) BETWEEN 6 AND 10
ORDER BY count(*) DESC;
```

> `HAVING` filtra sobre el resultado del `GROUP BY`, a diferencia de `WHERE` que filtra fila por fila antes de agrupar.

---

## 8. `DISTINCT`

Elimina duplicados y muestra solo valores únicos. Si hay 50 usuarios de Argentina, solo muestra `"Argentina"` una vez:

```sql
SELECT DISTINCT country FROM users;
```

---

## 9. `GROUP BY` con otras funciones

Obtener el dominio del correo electrónico y cuántos correos hay de cada dominio:

```sql
SELECT
    count(*),
    SUBSTRING(email, POSITION('@' IN email) + 1) AS domain  -- +1 para saltar el @
FROM users
GROUP BY domain
HAVING count(*) > 1
ORDER BY domain ASC;
```

---

## 10. Subqueries

Una **subquery** es una query dentro de otra query.

Estructura general:
```sql
SELECT * FROM tabla_a
WHERE campo = (SELECT campo FROM tabla_b WHERE condicion);
```

**Ejemplo práctico** — Obtener los usuarios que tienen más followers que el promedio:

```sql
SELECT first_name, last_name, followers
FROM users
WHERE followers > (
    SELECT AVG(followers) FROM users
)
ORDER BY followers DESC;
```

**Ejemplo 2** — Obtener los usuarios del país con más registros:

```sql
SELECT first_name, last_name, country
FROM users
WHERE country = (
    SELECT country
    FROM users
    GROUP BY country
    ORDER BY count(*) DESC
    LIMIT 1
);
```

> Las subqueries se ejecutan de adentro hacia afuera: primero la query interna, luego la externa usa ese resultado.

