-- =============================================
-- SEEDS - DATOS INICIALES DE PRUEBA
-- Sistema POS Multisucursal
-- =============================================

-- =============================================
-- SUCURSALES
-- =============================================
INSERT INTO sucursales (id, nombre, codigo, direccion, telefono, email, ciudad, estado, codigo_postal) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'Sucursal Centro', 'SUC-001', 'Av. Principal #123', '5551234567', 'centro@empresa.com', 'Ciudad de México', 'CDMX', '01000'),
('550e8400-e29b-41d4-a716-446655440002', 'Sucursal Norte', 'SUC-002', 'Av. Norte #456', '5557654321', 'norte@empresa.com', 'Ciudad de México', 'CDMX', '02000'),
('550e8400-e29b-41d4-a716-446655440003', 'Sucursal Sur', 'SUC-003', 'Av. Sur #789', '5559876543', 'sur@empresa.com', 'Ciudad de México', 'CDMX', '03000');

-- =============================================
-- USUARIOS (Password: Admin123! para todos)
-- Hash generado con bcrypt, rounds: 10
-- =============================================
INSERT INTO usuarios (id, nombre, apellido, email, telefono, password_hash, rol, sucursal_id) VALUES
('660e8400-e29b-41d4-a716-446655440001', 'Carlos', 'Administrador', 'admin@empresa.com', '5551111111', '$2b$10$rZ8qYq5Z5Z5Z5Z5Z5Z5Z5uK4K4K4K4K4K4K4K4K4K4K4K4K4K4K4K4', 'administrador', NULL),
('660e8400-e29b-41d4-a716-446655440002', 'María', 'Propietaria', 'propietario@empresa.com', '5552222222', '$2b$10$rZ8qYq5Z5Z5Z5Z5Z5Z5Z5uK4K4K4K4K4K4K4K4K4K4K4K4K4K4K4K4', 'propietario', NULL),
('660e8400-e29b-41d4-a716-446655440003', 'Juan', 'Vendedor Centro', 'vendedor1@empresa.com', '5553333333', '$2b$10$rZ8qYq5Z5Z5Z5Z5Z5Z5Z5uK4K4K4K4K4K4K4K4K4K4K4K4K4K4K4K4', 'vendedor', '550e8400-e29b-41d4-a716-446655440001'),
('660e8400-e29b-41d4-a716-446655440004', 'Ana', 'Vendedora Norte', 'vendedor2@empresa.com', '5554444444', '$2b$10$rZ8qYq5Z5Z5Z5Z5Z5Z5Z5uK4K4K4K4K4K4K4K4K4K4K4K4K4K4K4K4', 'vendedor', '550e8400-e29b-41d4-a716-446655440002');

-- =============================================
-- CATEGORÍAS
-- =============================================
INSERT INTO categorias (id, nombre, descripcion) VALUES
('770e8400-e29b-41d4-a716-446655440001', 'Electrónica', 'Productos electrónicos y tecnología'),
('770e8400-e29b-41d4-a716-446655440002', 'Alimentos', 'Productos alimenticios'),
('770e8400-e29b-41d4-a716-446655440003', 'Bebidas', 'Bebidas diversas'),
('770e8400-e29b-41d4-a716-446655440004', 'Limpieza', 'Productos de limpieza e higiene'),
('770e8400-e29b-41d4-a716-446655440005', 'Papelería', 'Artículos de oficina y papelería');

-- =============================================
-- PROVEEDORES
-- =============================================
INSERT INTO proveedores (id, nombre, razon_social, rfc, telefono, email, contacto_nombre) VALUES
('880e8400-e29b-41d4-a716-446655440001', 'Distribuidora Tech SA', 'Distribuidora Tech SA de CV', 'DTE123456789', '5556666666', 'ventas@tech.com', 'Roberto Pérez'),
('880e8400-e29b-41d4-a716-446655440002', 'Alimentos del Valle', 'Alimentos del Valle SA de CV', 'ADV987654321', '5557777777', 'contacto@alimentos.com', 'Laura Gómez'),
('880e8400-e29b-41d4-a716-446655440003', 'Limpieza Total', 'Limpieza Total SA de CV', 'LIT456789123', '5558888888', 'info@limpieza.com', 'Pedro Martínez');

-- =============================================
-- PRODUCTOS
-- =============================================
INSERT INTO productos (id, codigo_barras, sku, nombre, descripcion, categoria_id, proveedor_id, precio_compra, precio_venta, precio_mayoreo, cantidad_mayoreo, stock_minimo, stock_maximo) VALUES
-- Electrónica
('990e8400-e29b-41d4-a716-446655440001', '7501234567890', 'ELEC-001', 'Mouse Inalámbrico', 'Mouse inalámbrico USB 2.4GHz', '770e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', 150.00, 250.00, 220.00, 10, 5, 50),
('990e8400-e29b-41d4-a716-446655440002', '7501234567891', 'ELEC-002', 'Teclado USB', 'Teclado USB estándar español', '770e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', 200.00, 350.00, 320.00, 5, 3, 30),
('990e8400-e29b-41d4-a716-446655440003', '7501234567892', 'ELEC-003', 'Cable HDMI 2m', 'Cable HDMI 2 metros alta velocidad', '770e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', 80.00, 150.00, 130.00, 20, 10, 100),

-- Alimentos
('990e8400-e29b-41d4-a716-446655440004', '7501234567893', 'ALIM-001', 'Arroz 1kg', 'Arroz blanco premium 1 kilogramo', '770e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440002', 18.00, 32.00, 28.00, 50, 20, 200),
('990e8400-e29b-41d4-a716-446655440005', '7501234567894', 'ALIM-002', 'Frijol Negro 1kg', 'Frijol negro 1 kilogramo', '770e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440002', 22.00, 38.00, 35.00, 50, 15, 150),
('990e8400-e29b-41d4-a716-446655440006', '7501234567895', 'ALIM-003', 'Aceite Vegetal 1L', 'Aceite vegetal 1 litro', '770e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440002', 35.00, 55.00, 50.00, 30, 10, 100),

-- Bebidas
('990e8400-e29b-41d4-a716-446655440007', '7501234567896', 'BEB-001', 'Agua Natural 1.5L', 'Agua purificada 1.5 litros', '770e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440002', 8.00, 15.00, 13.00, 100, 50, 500),
('990e8400-e29b-41d4-a716-446655440008', '7501234567897', 'BEB-002', 'Refresco Cola 600ml', 'Refresco de cola 600ml', '770e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440002', 10.00, 18.00, 16.00, 50, 30, 300),

-- Limpieza
('990e8400-e29b-41d4-a716-446655440009', '7501234567898', 'LIMP-001', 'Detergente Líquido 1L', 'Detergente líquido multiusos 1 litro', '770e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440003', 45.00, 75.00, 68.00, 20, 10, 80),
('990e8400-e29b-41d4-a716-446655440010', '7501234567899', 'LIMP-002', 'Cloro 1L', 'Cloro blanqueador 1 litro', '770e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440003', 20.00, 35.00, 32.00, 30, 15, 120),

-- Papelería
('990e8400-e29b-41d4-a716-446655440011', '7501234567800', 'PAP-001', 'Cuaderno 100 Hojas', 'Cuaderno profesional 100 hojas', '770e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655440001', 25.00, 45.00, 40.00, 50, 20, 200),
('990e8400-e29b-41d4-a716-446655440012', '7501234567801', 'PAP-002', 'Bolígrafo Azul', 'Bolígrafo tinta azul punta fina', '770e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655440001', 5.00, 10.00, 8.00, 100, 50, 500);

-- =============================================
-- INVENTARIO INICIAL
-- =============================================
-- Sucursal Centro
INSERT INTO inventario (producto_id, sucursal_id, cantidad, ubicacion) VALUES
('990e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 25, 'Estante A1'),
('990e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 15, 'Estante A2'),
('990e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440001', 50, 'Estante A3'),
('990e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440001', 100, 'Estante B1'),
('990e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440001', 80, 'Estante B2'),
('990e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440001', 60, 'Estante B3'),
('990e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440001', 200, 'Estante C1'),
('990e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440001', 150, 'Estante C2'),
('990e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440001', 40, 'Estante D1'),
('990e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440001', 70, 'Estante D2'),
('990e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440001', 100, 'Estante E1'),
('990e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440001', 300, 'Estante E2');

-- Sucursal Norte
INSERT INTO inventario (producto_id, sucursal_id, cantidad, ubicacion) VALUES
('990e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', 20, 'Anaquel 1A'),
('990e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', 10, 'Anaquel 1B'),
('990e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', 40, 'Anaquel 1C'),
('990e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', 90, 'Anaquel 2A'),
('990e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440002', 180, 'Anaquel 3A'),
('990e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440002', 120, 'Anaquel 3B');

-- Sucursal Sur
INSERT INTO inventario (producto_id, sucursal_id, cantidad, ubicacion) VALUES
('990e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440003', 120, 'Bodega A'),
('990e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440003', 100, 'Bodega A'),
('990e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440003', 250, 'Bodega B'),
('990e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440003', 80, 'Bodega C'),
('990e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440003', 400, 'Bodega C');

-- =============================================
-- CLIENTES
-- =============================================
INSERT INTO clientes (id, nombre, apellido, email, telefono, rfc, limite_credito) VALUES
('aa0e8400-e29b-41d4-a716-446655440001', 'Público', 'General', NULL, NULL, NULL, 0),
('aa0e8400-e29b-41d4-a716-446655440002', 'Roberto', 'García', 'roberto.garcia@email.com', '5551122334', 'GAGR850101ABC', 5000.00),
('aa0e8400-e29b-41d4-a716-446655440003', 'Laura', 'Martínez', 'laura.martinez@email.com', '5552233445', 'MAML900215DEF', 10000.00),
('aa0e8400-e29b-41d4-a716-446655440004', 'José', 'López', 'jose.lopez@email.com', '5553344556', 'LOJP750320GHI', 3000.00);

-- =============================================
-- CAJAS
-- =============================================
INSERT INTO cajas (id, sucursal_id, nombre, numero) VALUES
-- Sucursal Centro
('bb0e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Caja Principal', 1),
('bb0e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'Caja 2', 2),
-- Sucursal Norte
('bb0e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', 'Caja Principal', 1),
-- Sucursal Sur
('bb0e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440003', 'Caja Principal', 1);

-- =============================================
-- FIN DE SEEDS
-- =============================================