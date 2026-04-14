DROP TABLE IF EXISTS practice.raw_orders;

CREATE TABLE practice.raw_orders (
    order_id VARCHAR(50),
    supplier VARCHAR(100),
    region VARCHAR(50),
    order_date VARCHAR(50),
    delivery_date VARCHAR(50),
    quantity_ordered VARCHAR(50),
    quantity_delivered VARCHAR(50),
    unit_price VARCHAR(50),
    status VARCHAR(50)
);

INSERT INTO practice.raw_orders VALUES
('ORD-001', 'supplier_alpha', 'usa', '01/15/2024', '01/20/2024', '100', '100', '25.50', 'delivered'),
('ORD-002', 'SUPPLIER_ALPHA', 'USA', '2024-01-18', '2024-01-25', '200', '180', '25.50', 'DELIVERED'),
('ORD-003', 'Supplier Beta', 'europe', '20/01/2024', '25/01/2024', '150', '150', '30.00', 'delivered'),
('ORD-004', NULL, 'LATAM', '01/22/2024', '01/28/2024', '300', '300', '22.00', 'delivered'),
('ORD-005', 'supplier_beta', 'Europe', '2024-01-25', NULL, '250', NULL, '30.00', 'pending'),
('ORD-006', 'SUPPLIER GAMMA', 'LATAM', '26/01/2024', '30/01/2024', '-50', '0', '15.00', 'delivered'),
('ORD-007', 'supplier_alpha', 'usa', '01/15/2024', '01/20/2024', '100', '100', '25.50', 'delivered'),
('ORD-008', 'Supplier_Gamma', 'latam', '28-01-2024', '02-02-2024', '400', '420', '15.00', 'delivered'),
('ORD-009', 'SUPPLIER BETA', 'EUROPE', '2024-01-30', '2024-02-05', '180', '180', 'N/A', 'delivered'),
('ORD-010', 'supplier_alpha', 'USA', '31/01/2024', '07/02/2024', '500', '500', '0', 'delivered'),
('ORD-011', '  Supplier_Alpha  ', ' usa ', 'Jan 15 2024', 'Jan 20 2024', '100', '100', '$25.50', 'Delivered'),
('ORD-012', 'supplier__beta', 'EUR0PE', '15-Jan-2024', '20-Jan-2024', '200', '200', '30,00', 'delivered'),
('ORD-013', 'SUPPLIER_GAMMA', 'latam ', '2024/01/26', '2024/01/30', '999999', '150', '15.00', 'delivered'),
('ORD-014', 'Supplier Alpha', 'US4', '32/01/2024', '40/01/2024', '100', '100', '25.50', 'deliverd'),
('ORD-015', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('ORD-016', 'supplier_beta', 'europe', '2024-01-18', '2024-01-15', '200', '200', '30.00', 'delivered'),
('ORD-017', 'SUPPLIER ALPHA', 'USA', '01/18/2024', '01/25/2024', '200', '-180', '25.50', 'delivered'),
('ORD-018', 'Supplier_Gamma', 'LATAM', '28/01/2024', '02/02/2024', '400', '400', '999', 'PENDING'),
('ORD-019', 'supplier_alpha', 'usa', '01-18-2024', '01-25-2024', '200', '200', '25.50', 'delivered'),
('ORD-020', 'SUPPLIEr_BeTa', 'EuRoPe', '20/01/2024', '25/01/2024', '150', '150', '30.00', 'DELIVERED');