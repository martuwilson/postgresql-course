-- Tabla de departamentos
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    department_name VARCHAR(100),
    location VARCHAR(100)
);

-- Tabla de empleados
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department_id INT REFERENCES departments(id),
    salary DECIMAL(10,2),
    hire_date DATE
);

-- Insert departamentos
INSERT INTO departments (department_name, location) VALUES
('Engineering', 'Buenos Aires'),
('Marketing', 'Montevideo'),
('Sales', 'Buenos Aires'),
('HR', 'Santiago'),
('Finance', 'Buenos Aires');

-- Insert empleados
INSERT INTO employees (name, department_id, salary, hire_date) VALUES
('Martin', 1, 3500.00, '2021-03-15'),
('Sofia', 1, 4200.00, '2020-07-01'),
('Lucas', 2, 2800.00, '2022-01-10'),
('Valentina', 2, 3100.00, '2021-11-20'),
('Diego', 3, 2600.00, '2023-02-05'),
('Camila', 3, 2900.00, '2022-08-15'),
('Andres', 3, 3200.00, '2020-04-30'),
('Florencia', 4, 2400.00, '2023-06-01'),
('Matias', 4, 2700.00, '2022-03-22'),
('Carolina', 5, 4500.00, '2019-09-10'),
('Pablo', 5, 3800.00, '2021-05-18'),
('Lucia', 1, 3900.00, '2020-12-01');