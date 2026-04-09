CREATE TABLE supply_chain_dirty (
    order_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100),
    product VARCHAR(100),
    order_date VARCHAR(50),
    expected_delivery VARCHAR(50),
    actual_delivery VARCHAR(50),
    quantity_ordered INT,
    quantity_delivered INT,
    region VARCHAR(50),
    unit_cost DECIMAL(10,2)
);

INSERT INTO supply_chain_dirty VALUES
(1, 'SUPPLIER_A', 'Laptop', '01/05/2024', '01/15/2024', '01/15/2024', 100, 100, 'LATAM', 800.00),
(2, 'supplierB', 'Mouse', '06-01-2024', '10-01-2024', '14-01-2024', 200, 180, 'usa', 25.00),
(3, 'Supplier_A', 'Laptop', '2024-01-10', '2024-01-20', NULL, 150, NULL, 'Europe', 800.00),
(4, 'SUPPLIER_C', 'Keyboard', '12/01/2024', '18/01/2024', '18/01/2024', 300, -300, 'LATAM', 45.00),
(5, 'SupplierB', 'Mouse', '2024-01-15', '2024-01-20', '2024-01-25', 250, 200, 'USA', 25.00),
(6, 'supplier_c', 'Keyboard', '18/01/2024', '25/01/2024', '24/01/2024', 100, 100, 'europe', 45.00),
(7, 'SUPPLIER_A', 'Laptop', '2024-02-01', '2024-02-10', '2024-02-15', 200, 180, 'Latam', 800.00),
(8, 'supplierB', 'Mouse', '05-02-2024', '12-02-2024', '12-02-2024', 300, 300, 'USA', 25.00),
(9, 'Supplier_C', 'Keyboard', '2024-02-08', '2024-02-15', NULL, 150, NULL, 'EUROPE', 45.00),
(10, 'supplier_a', 'Laptop', '2024-02-12', '2024-02-20', '2024-02-20', 100, 100, 'latam', 800.00),
(11, 'SUPPLIERB', 'Mouse', '15/02/2024', '22/02/2024', '28/02/2024', 200, 150, 'Europe', 25.00),
(12, 'supplier_c', 'Keyboard', '2024-02-20', '2024-02-28', '2024-02-27', 250, 250, 'usa', 45.00),
(13, 'Supplier_A', 'Laptop', '01-03-2024', '10-03-2024', '10-03-2024', 300, 300, 'europe', 800.00),
(14, 'supplierB', 'Mouse', '2024-03-05', '2024-03-12', '2024-03-14', 100, 90, 'LATAM', 25.00),
(15, 'SUPPLIER_C', 'Keyboard', '10/03/2024', '18/03/2024', '18/03/2024', 200, 200, 'USA', 45.00),
(16, 'supplier_a', 'Laptop', '2024-03-15', '2024-03-20', '2024-03-20', 100, 100, 'LATAM', 800.00),
(16, 'supplierB', 'Mouse', '2024-03-15', '2024-03-20', '2024-03-20', 100, 100, 'USA', 25.00);