

# Tarea: Separación de datos con `countryLanguage`

---

## 1. Crear la tabla `language`

Primero se crea la secuencia y luego la tabla:

```sql
CREATE SEQUENCE IF NOT EXISTS language_code_seq;

CREATE TABLE "public"."language" (
    "code" int4 NOT NULL DEFAULT nextval('language_code_seq'::regclass),
    "name" text NOT NULL,
    PRIMARY KEY ("code")
);
```

---

## 2. Agregar columna `languagecode` en `countrylanguage`

```sql
ALTER TABLE countrylanguage
ADD COLUMN languagecode varchar(3);
```

---

## 3. Poblar la tabla `language`

Primero se verifica la data con un `SELECT`:

```sql
SELECT DISTINCT language
FROM countrylanguage
ORDER BY language ASC;
```

Luego se inserta:

```sql
INSERT INTO language(name)
SELECT DISTINCT language
FROM countrylanguage;
```

---

## 4. Verificar la actualización antes de ejecutarla

```sql
SELECT
    "language",
    (SELECT code FROM "language" b WHERE a.language = b.name)
FROM countrylanguage a;
```

---

## 5. Actualizar los registros con el código correspondiente

```sql
UPDATE countrylanguage a
SET languagecode = (SELECT code FROM "language" b WHERE a.language = b.name);
```

---

## 6. Cambiar el tipo de dato de `languagecode` a `int4`

```sql
ALTER TABLE countrylanguage
ALTER COLUMN languagecode TYPE int4
USING languagecode::INTEGER;
```

---

## 7. Agregar restricción `UNIQUE` en `language.name`

Necesario para poder referenciarla como FK:

```sql
ALTER TABLE language
ADD CONSTRAINT language_name_unique UNIQUE (name);
```

---

## 8. Crear la Foreign Key en `countrylanguage`

```sql
ALTER TABLE countrylanguage
ADD CONSTRAINT countrylanguage_language_fk
FOREIGN KEY (language) REFERENCES language(name);
```
