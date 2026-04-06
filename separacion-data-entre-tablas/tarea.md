

-- Tarea con countryLanguage

-- Crear la tabla de language

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS language_code_seq;


-- Table Definition
CREATE TABLE "public"."language" (
    "code" int4 NOT NULL DEFAULT 	nextval('language_code_seq'::regclass),
    "name" text NOT NULL,
    PRIMARY KEY ("code")
);

-- Crear una columna en countrylanguage
ALTER TABLE countrylanguage
ADD COLUMN languagecode varchar(3);

--AGREGAR DATA A LANGUAGE
select DISTINCT language
from countrylanguage
order by language ASC;

insert into language(name)
select DISTINCT language
from countrylanguage;


-- Empezar con el select para confirmar lo que vamos a actualizar

select
	"language",
	(select code from "language" b where a.language = b.name)
from countrylanguage a;


-- Actualizar todos los registros
update countrylanguage a
set languagecode = (select code from "language" b where a.language = b.name);

-- Cambiar tipo de dato en countrylanguage - languagecode por int4
alter table countrylanguage
alter COLUMN languagecode type int4
using languagecode::INTEGER;

-- para agregar la FK necesito hacer UNIQUE la name
ALTER TABLE language    
ADD CONSTRAINT language_name_unique UNIQUE (name);
-- Crear el forening key y constraints de no nulo el language_code
alter table countrylanguage
add CONSTRAINT countrylanguage_language_fk
FOREIGN KEY (language) REFERENCES language(name);
