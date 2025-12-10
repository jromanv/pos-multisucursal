-- =============================================
-- SISTEMA POS MULTISUCURSAL
-- Esquema de Base de Datos
-- =============================================

-- Extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- TABLA: usuarios
-- =============================================
CREATE TABLE usuarios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    rol VARCHAR(20) NOT NULL CHECK (rol IN ('administrador', 'propietario', 'vendedor')),
    sucursal_id UUID,
    activo BOOLEAN DEFAULT true,
    ultimo_acceso TIMESTAMP,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_usuarios_rol ON usuarios(rol);
CREATE INDEX idx_usuarios_sucursal ON usuarios(sucursal_id);

-- =============================================
-- TABLA: sucursales
-- =============================================
CREATE TABLE sucursales (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(150) NOT NULL,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(150),
    ciudad VARCHAR(100),
    estado VARCHAR(100),
    codigo_postal VARCHAR(10),
    activo BOOLEAN DEFAULT true,
    configuracion JSONB DEFAULT '{}',
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_sucursales_codigo ON sucursales(codigo);
CREATE INDEX idx_sucursales_activo ON sucursales(activo);

-- =============================================
-- TABLA: categorias
-- =============================================
CREATE TABLE categorias (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    categoria_padre_id UUID REFERENCES categorias(id) ON DELETE SET NULL,
    activo BOOLEAN DEFAULT true,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_categorias_nombre ON categorias(nombre);
CREATE INDEX idx_categorias_padre ON categorias(categoria_padre_id);

-- =============================================
-- TABLA: proveedores
-- =============================================
CREATE TABLE proveedores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(200) NOT NULL,
    razon_social VARCHAR(200),
    rfc VARCHAR(20),
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(150),
    contacto_nombre VARCHAR(150),
    contacto_telefono VARCHAR(20),
    activo BOOLEAN DEFAULT true,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_proveedores_nombre ON proveedores(nombre);
CREATE INDEX idx_proveedores_activo ON proveedores(activo);

-- =============================================
-- TABLA: productos
-- =============================================
CREATE TABLE productos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    codigo_barras VARCHAR(50) UNIQUE,
    sku VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    categoria_id UUID REFERENCES categorias(id) ON DELETE SET NULL,
    proveedor_id UUID REFERENCES proveedores(id) ON DELETE SET NULL,
    precio_compra DECIMAL(10, 2) NOT NULL DEFAULT 0,
    precio_venta DECIMAL(10, 2) NOT NULL,
    precio_mayoreo DECIMAL(10, 2),
    cantidad_mayoreo INTEGER DEFAULT 0,
    iva DECIMAL(5, 2) DEFAULT 16.00,
    stock_minimo INTEGER DEFAULT 0,
    stock_maximo INTEGER DEFAULT 0,
    unidad_medida VARCHAR(20) DEFAULT 'pieza',
    imagen_url TEXT,
    activo BOOLEAN DEFAULT true,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_productos_codigo_barras ON productos(codigo_barras);
CREATE INDEX idx_productos_sku ON productos(sku);
CREATE INDEX idx_productos_nombre ON productos(nombre);
CREATE INDEX idx_productos_categoria ON productos(categoria_id);
CREATE INDEX idx_productos_activo ON productos(activo);

-- =============================================
-- TABLA: inventario
-- =============================================
CREATE TABLE inventario (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    producto_id UUID NOT NULL REFERENCES productos(id) ON DELETE CASCADE,
    sucursal_id UUID NOT NULL REFERENCES sucursales(id) ON DELETE CASCADE,
    cantidad INTEGER NOT NULL DEFAULT 0,
    ubicacion VARCHAR(50),
    ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(producto_id, sucursal_id)
);

CREATE INDEX idx_inventario_producto ON inventario(producto_id);
CREATE INDEX idx_inventario_sucursal ON inventario(sucursal_id);
CREATE INDEX idx_inventario_cantidad ON inventario(cantidad);

-- =============================================
-- TABLA: movimientos_inventario
-- =============================================
CREATE TABLE movimientos_inventario (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    producto_id UUID NOT NULL REFERENCES productos(id) ON DELETE CASCADE,
    sucursal_id UUID NOT NULL REFERENCES sucursales(id) ON DELETE CASCADE,
    tipo_movimiento VARCHAR(30) NOT NULL CHECK (tipo_movimiento IN 
        ('entrada', 'salida', 'ajuste', 'traspaso_salida', 'traspaso_entrada', 'venta', 'devolucion')),
    cantidad INTEGER NOT NULL,
    cantidad_anterior INTEGER NOT NULL,
    cantidad_nueva INTEGER NOT NULL,
    sucursal_destino_id UUID REFERENCES sucursales(id),
    referencia VARCHAR(100),
    motivo TEXT,
    usuario_id UUID REFERENCES usuarios(id),
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_movimientos_producto ON movimientos_inventario(producto_id);
CREATE INDEX idx_movimientos_sucursal ON movimientos_inventario(sucursal_id);
CREATE INDEX idx_movimientos_tipo ON movimientos_inventario(tipo_movimiento);
CREATE INDEX idx_movimientos_fecha ON movimientos_inventario(creado_en);

-- =============================================
-- TABLA: clientes
-- =============================================
CREATE TABLE clientes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    telefono VARCHAR(20),
    rfc VARCHAR(20),
    direccion TEXT,
    ciudad VARCHAR(100),
    estado VARCHAR(100),
    codigo_postal VARCHAR(10),
    limite_credito DECIMAL(10, 2) DEFAULT 0,
    saldo_actual DECIMAL(10, 2) DEFAULT 0,
    activo BOOLEAN DEFAULT true,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_clientes_nombre ON clientes(nombre);
CREATE INDEX idx_clientes_email ON clientes(email);
CREATE INDEX idx_clientes_telefono ON clientes(telefono);
CREATE INDEX idx_clientes_activo ON clientes(activo);

-- =============================================
-- TABLA: cajas
-- =============================================
CREATE TABLE cajas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sucursal_id UUID NOT NULL REFERENCES sucursales(id) ON DELETE CASCADE,
    nombre VARCHAR(50) NOT NULL,
    numero INTEGER NOT NULL,
    activo BOOLEAN DEFAULT true,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(sucursal_id, numero)
);

CREATE INDEX idx_cajas_sucursal ON cajas(sucursal_id);

-- =============================================
-- TABLA: apertura_cierre_caja
-- =============================================
CREATE TABLE apertura_cierre_caja (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    caja_id UUID NOT NULL REFERENCES cajas(id) ON DELETE CASCADE,
    usuario_id UUID NOT NULL REFERENCES usuarios(id),
    fecha_apertura TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_cierre TIMESTAMP,
    monto_inicial DECIMAL(10, 2) NOT NULL,
    monto_final DECIMAL(10, 2),
    monto_esperado DECIMAL(10, 2),
    diferencia DECIMAL(10, 2),
    total_efectivo DECIMAL(10, 2) DEFAULT 0,
    total_tarjeta DECIMAL(10, 2) DEFAULT 0,
    total_transferencia DECIMAL(10, 2) DEFAULT 0,
    total_ventas INTEGER DEFAULT 0,
    observaciones TEXT,
    estado VARCHAR(20) NOT NULL DEFAULT 'abierta' CHECK (estado IN ('abierta', 'cerrada')),
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_apertura_caja ON apertura_cierre_caja(caja_id);
CREATE INDEX idx_apertura_usuario ON apertura_cierre_caja(usuario_id);
CREATE INDEX idx_apertura_estado ON apertura_cierre_caja(estado);
CREATE INDEX idx_apertura_fecha ON apertura_cierre_caja(fecha_apertura);

-- =============================================
-- TABLA: ventas
-- =============================================
CREATE TABLE ventas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    folio VARCHAR(50) UNIQUE NOT NULL,
    sucursal_id UUID NOT NULL REFERENCES sucursales(id),
    caja_id UUID NOT NULL REFERENCES cajas(id),
    apertura_caja_id UUID NOT NULL REFERENCES apertura_cierre_caja(id),
    usuario_id UUID NOT NULL REFERENCES usuarios(id),
    cliente_id UUID REFERENCES clientes(id),
    subtotal DECIMAL(10, 2) NOT NULL,
    descuento DECIMAL(10, 2) DEFAULT 0,
    iva DECIMAL(10, 2) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    tipo_venta VARCHAR(20) DEFAULT 'contado' CHECK (tipo_venta IN ('contado', 'credito')),
    estado VARCHAR(20) DEFAULT 'completada' CHECK (estado IN ('completada', 'cancelada', 'pendiente')),
    observaciones TEXT,
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_ventas_folio ON ventas(folio);
CREATE INDEX idx_ventas_sucursal ON ventas(sucursal_id);
CREATE INDEX idx_ventas_caja ON ventas(caja_id);
CREATE INDEX idx_ventas_usuario ON ventas(usuario_id);
CREATE INDEX idx_ventas_cliente ON ventas(cliente_id);
CREATE INDEX idx_ventas_fecha ON ventas(fecha_venta);
CREATE INDEX idx_ventas_estado ON ventas(estado);

-- =============================================
-- TABLA: detalle_ventas
-- =============================================
CREATE TABLE detalle_ventas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    venta_id UUID NOT NULL REFERENCES ventas(id) ON DELETE CASCADE,
    producto_id UUID NOT NULL REFERENCES productos(id),
    cantidad INTEGER NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    descuento DECIMAL(10, 2) DEFAULT 0,
    iva DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_detalle_venta ON detalle_ventas(venta_id);
CREATE INDEX idx_detalle_producto ON detalle_ventas(producto_id);

-- =============================================
-- TABLA: pagos
-- =============================================
CREATE TABLE pagos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    venta_id UUID NOT NULL REFERENCES ventas(id) ON DELETE CASCADE,
    metodo_pago VARCHAR(30) NOT NULL CHECK (metodo_pago IN 
        ('efectivo', 'tarjeta_debito', 'tarjeta_credito', 'transferencia', 'cheque', 'otro')),
    monto DECIMAL(10, 2) NOT NULL,
    referencia VARCHAR(100),
    observaciones TEXT,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_pagos_venta ON pagos(venta_id);
CREATE INDEX idx_pagos_metodo ON pagos(metodo_pago);

-- =============================================
-- TABLA: devoluciones
-- =============================================
CREATE TABLE devoluciones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    folio VARCHAR(50) UNIQUE NOT NULL,
    venta_id UUID NOT NULL REFERENCES ventas(id),
    sucursal_id UUID NOT NULL REFERENCES sucursales(id),
    usuario_id UUID NOT NULL REFERENCES usuarios(id),
    total DECIMAL(10, 2) NOT NULL,
    motivo TEXT NOT NULL,
    tipo_devolucion VARCHAR(20) CHECK (tipo_devolucion IN ('efectivo', 'credito', 'cambio')),
    estado VARCHAR(20) DEFAULT 'procesada' CHECK (estado IN ('procesada', 'cancelada')),
    fecha_devolucion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_devoluciones_folio ON devoluciones(folio);
CREATE INDEX idx_devoluciones_venta ON devoluciones(venta_id);
CREATE INDEX idx_devoluciones_sucursal ON devoluciones(sucursal_id);
CREATE INDEX idx_devoluciones_fecha ON devoluciones(fecha_devolucion);

-- =============================================
-- TABLA: detalle_devoluciones
-- =============================================
CREATE TABLE detalle_devoluciones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    devolucion_id UUID NOT NULL REFERENCES devoluciones(id) ON DELETE CASCADE,
    producto_id UUID NOT NULL REFERENCES productos(id),
    cantidad INTEGER NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_detalle_devolucion ON detalle_devoluciones(devolucion_id);

-- =============================================
-- TABLA: auditoria
-- =============================================
CREATE TABLE auditoria (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id UUID REFERENCES usuarios(id),
    accion VARCHAR(100) NOT NULL,
    tabla VARCHAR(50) NOT NULL,
    registro_id UUID,
    datos_anteriores JSONB,
    datos_nuevos JSONB,
    ip VARCHAR(45),
    user_agent TEXT,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_auditoria_usuario ON auditoria(usuario_id);
CREATE INDEX idx_auditoria_tabla ON auditoria(tabla);
CREATE INDEX idx_auditoria_fecha ON auditoria(creado_en);

-- =============================================
-- TABLA: configuracion_sistema (para ajustes generales)
-- =============================================
CREATE TABLE configuracion_sistema (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clave VARCHAR(100) UNIQUE NOT NULL,
    valor TEXT NOT NULL,
    tipo VARCHAR(20) DEFAULT 'texto' CHECK (tipo IN ('texto', 'numero', 'booleano', 'json')),
    descripcion TEXT,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- FUNCIÓN: Actualizar timestamp automáticamente
-- =============================================
CREATE OR REPLACE FUNCTION actualizar_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.actualizado_en = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- TRIGGERS: Actualizar timestamps
-- =============================================
CREATE TRIGGER trigger_actualizar_usuarios
    BEFORE UPDATE ON usuarios
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_timestamp();

CREATE TRIGGER trigger_actualizar_sucursales
    BEFORE UPDATE ON sucursales
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_timestamp();

CREATE TRIGGER trigger_actualizar_categorias
    BEFORE UPDATE ON categorias
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_timestamp();

CREATE TRIGGER trigger_actualizar_productos
    BEFORE UPDATE ON productos
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_timestamp();

CREATE TRIGGER trigger_actualizar_clientes
    BEFORE UPDATE ON clientes
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_timestamp();

CREATE TRIGGER trigger_actualizar_proveedores
    BEFORE UPDATE ON proveedores
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_timestamp();

-- =============================================
-- INSERTAR CONFIGURACIONES INICIALES
-- =============================================
INSERT INTO configuracion_sistema (clave, valor, tipo, descripcion) VALUES
('nombre_empresa', 'Mi Empresa POS', 'texto', 'Nombre de la empresa'),
('moneda', 'MXN', 'texto', 'Moneda del sistema'),
('iva_default', '16', 'numero', 'IVA por defecto en porcentaje'),
('modo_offline', 'false', 'booleano', 'Habilitar modo offline'),
('backup_automatico', 'true', 'booleano', 'Realizar backups automáticos');

-- =============================================
-- FIN DEL ESQUEMA
-- =============================================











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




SELECT COUNT(*) FROM sucursales;      -- Debe retornar 3
SELECT COUNT(*) FROM usuarios;        -- Debe retornar 4
SELECT COUNT(*) FROM categorias;      -- Debe retornar 5
SELECT COUNT(*) FROM productos;       -- Debe retornar 12
SELECT COUNT(*) FROM inventario;      -- Debe retornar 23
SELECT COUNT(*) FROM clientes;        -- Debe retornar 4
SELECT COUNT(*) FROM cajas;           -- Debe retornar 4





UPDATE usuarios 
SET password_hash = '$2b$10$j8IfkqvFe.mREdr.BRuEVesw.j.C2IFb0eG0SszAeoreYBImr3l8i' 
WHERE email = 'admin@empresa.com';

SELECT email, password_hash FROM usuarios WHERE email = 'admin@empresa.com';