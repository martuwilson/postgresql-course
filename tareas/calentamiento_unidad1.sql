-- Nombre, apellido e IP, donde la última conexión se dió de 221.xxx.xxx.xxx
SELECT
	first_name,
	last_name,
	last_connection
FROM
	users
WHERE
	last_connection LIKE '221.%'


--Nombre, apellido y followers de todos los que siguen mas de 4600 personas
SELECT
	first_name,
	last_name,
	followers
FROM
	users
WHERE
	"following" >= 4600