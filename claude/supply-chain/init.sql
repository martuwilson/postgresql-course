CREATE TABLE supply_chain_orders (
    order_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100),
    product VARCHAR(100),
    order_date DATE,
    expected_delivery DATE,
    actual_delivery DATE,
    quantity_ordered INT,
    quantity_delivered INT,
    region VARCHAR(50),
    unit_cost DECIMAL(10,2)
);

INSERT INTO supply_chain_orders VALUES
(1, 'SupplierA', 'Laptop', '2024-01-05', '2024-01-15', '2024-01-15', 100, 100, 'LATAM', 800.00),
(2, 'SupplierB', 'Mouse', '2024-01-06', '2024-01-10', '2024-01-14', 200, 180, 'USA', 25.00),
(3, 'SupplierA', 'Laptop', '2024-01-10', '2024-01-20', NULL, 150, NULL, 'Europe', 800.00),
(4, 'SupplierC', 'Keyboard', '2024-01-12', '2024-01-18', '2024-01-18', 300, 300, 'LATAM', 45.00),
(5, 'SupplierB', 'Mouse', '2024-01-15', '2024-01-20', '2024-01-25', 250, 200, 'USA', 25.00),
(6, 'SupplierC', 'Keyboard', '2024-01-18', '2024-01-25', '2024-01-24', 100, 100, 'Europe', 45.00),
(7, 'SupplierA', 'Laptop', '2024-02-01', '2024-02-10', '2024-02-15', 200, 180, 'LATAM', 800.00),
(8, 'SupplierB', 'Mouse', '2024-02-05', '2024-02-12', '2024-02-12', 300, 300, 'USA', 25.00),
(9, 'SupplierC', 'Keyboard', '2024-02-08', '2024-02-15', NULL, 150, NULL, 'Europe', 45.00),
(10, 'SupplierA', 'Laptop', '2024-02-12', '2024-02-20', '2024-02-20', 100, 100, 'LATAM', 800.00),
(11, 'SupplierB', 'Mouse', '2024-02-15', '2024-02-22', '2024-02-28', 200, 150, 'Europe', 25.00),
(12, 'SupplierC', 'Keyboard', '2024-02-20', '2024-02-28', '2024-02-27', 250, 250, 'USA', 45.00),
(13, 'SupplierA', 'Laptop', '2024-03-01', '2024-03-10', '2024-03-10', 300, 300, 'Europe', 800.00),
(14, 'SupplierB', 'Mouse', '2024-03-05', '2024-03-12', '2024-03-14', 100, 90, 'LATAM', 25.00),
(15, 'SupplierC', 'Keyboard', '2024-03-10', '2024-03-18', '2024-03-18', 200, 200, 'USA', 45.00);