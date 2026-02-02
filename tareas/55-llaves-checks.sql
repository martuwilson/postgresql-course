

-- 1. Crear una llave primaria en city (id)
ALTER TABLE city
ADD PRIMARY KEY (id);

-- 2. Crear un check en population, para que no soporte negativos
ALTER TABLE city
ADD CHECK (
	population >= 0
);

-- 3. Crear una llave primaria compuesta en "countrylanguage"
-- los campos a usar como llave compuesta son countrycode y language
ALTER TABLE countrylenguage
ADD PRIMARY KEY (countrycode, lenguage);

-- 4. Crear check en percentage, 
-- Para que no permita negativos ni números superiores a 100
ALTER TABLE countrylanguage
ADD CHECK (
	(percentage >= 0)
	AND (percentage <= 100)
);

