-- ============================================
-- SCRIPT SQL PARA MI OBRA FÁCIL
-- Base de Datos: miobrafacildb_cityvastbe
-- Host: y27ad9.h.filess.io
-- Port: 3306
-- User: miobrafacildb_cityvastbe
-- Password: c0cb1e8a0bc69a67cf4255b2e9398674c0fd391c
-- ============================================

-- Tabla 1: projects (Proyectos de construcción)
CREATE TABLE IF NOT EXISTS projects (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    client VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    region VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_synced TINYINT(1) DEFAULT 1,
    device_id VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 2: jobs (Trabajos/Items de cada proyecto)
CREATE TABLE IF NOT EXISTS jobs (
    id VARCHAR(50) PRIMARY KEY,
    project_id VARCHAR(50) NOT NULL,
    work_type_id VARCHAR(50) NOT NULL,
    work_type_name VARCHAR(255) NOT NULL,
    quantity DECIMAL(10, 2) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    unit VARCHAR(10) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    INDEX idx_project_id (project_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 3: work_types (Catálogo de tipos de trabajo con precios regionales)
CREATE TABLE IF NOT EXISTS work_types (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    unit VARCHAR(10) NOT NULL,
    price_la_paz DECIMAL(10, 2) NOT NULL,
    price_cochabamba DECIMAL(10, 2) NOT NULL,
    price_santa_cruz DECIMAL(10, 2) NOT NULL,
    price_sucre DECIMAL(10, 2) NOT NULL,
    price_oruro DECIMAL(10, 2) NOT NULL,
    price_tarija DECIMAL(10, 2) NOT NULL,
    price_potosi DECIMAL(10, 2) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla 4: sync_log (Registro de sincronizaciones)
CREATE TABLE IF NOT EXISTS sync_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    device_id VARCHAR(100) NOT NULL,
    sync_type VARCHAR(50) NOT NULL,
    records_synced INT DEFAULT 0,
    sync_status VARCHAR(20) NOT NULL,
    sync_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    error_message TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- INSERTAR DATOS DE PRUEBA (Opcional)
-- ============================================

-- Insertar un proyecto de prueba
INSERT INTO projects (id, name, client, location, region, device_id) VALUES
('test_001', 'Casa Familiar - Zona Sur', 'Juan Pérez Mamani', 'La Paz', 'laPaz', 'web_admin');

-- Insertar trabajos del proyecto de prueba
INSERT INTO jobs (id, project_id, work_type_id, work_type_name, quantity, unit_price, total, unit) VALUES
('job_001', 'test_001', 'og_replanteo', 'Replanteo y Trazado', 100.00, 12.50, 1250.00, 'm²'),
('job_002', 'test_001', 'og_excavacion', 'Excavación de Zanjas', 50.00, 45.00, 2250.00, 'm³');

-- Insertar algunos tipos de trabajo (catálogo)
INSERT INTO work_types (id, name, category, unit, price_la_paz, price_cochabamba, price_santa_cruz, price_sucre, price_oruro, price_tarija, price_potosi) VALUES
('og_replanteo', 'Replanteo y Trazado', 'Obra Gruesa', 'm²', 12.50, 11.80, 13.20, 11.50, 11.00, 12.00, 10.50),
('og_excavacion', 'Excavación de Zanjas', 'Obra Gruesa', 'm³', 45.00, 42.50, 48.00, 41.50, 40.00, 43.50, 38.50),
('og_hormigon', 'Hormigón Simple', 'Obra Gruesa', 'm³', 580.00, 550.00, 620.00, 540.00, 520.00, 565.00, 500.00),
('og_muros', 'Muros de Ladrillo 6H', 'Obra Gruesa', 'm²', 85.00, 80.00, 90.00, 78.50, 75.00, 82.00, 72.00),
('of_enlucido', 'Enlucido de Yeso', 'Obra Fina', 'm²', 28.00, 26.50, 30.00, 26.00, 25.00, 27.50, 24.00),
('of_piso', 'Piso Cerámico', 'Obra Fina', 'm²', 95.00, 90.00, 100.00, 88.00, 85.00, 92.00, 82.00),
('in_agua', 'Instalación de Agua Potable', 'Instalaciones', 'pto', 180.00, 170.00, 190.00, 165.00, 160.00, 175.00, 155.00),
('in_luz', 'Instalación Eléctrica', 'Instalaciones', 'pto', 95.00, 90.00, 100.00, 88.00, 85.00, 92.00, 82.00);

-- ============================================
-- VERIFICAR TABLAS CREADAS
-- ============================================

-- Comando para ver todas las tablas
SHOW TABLES;

-- Ver estructura de la tabla projects
DESCRIBE projects;

-- Ver estructura de la tabla jobs
DESCRIBE jobs;

-- Ver estructura de la tabla work_types
DESCRIBE work_types;

-- Ver estructura de la tabla sync_log
DESCRIBE sync_log;

-- ============================================
-- CONSULTAS DE VERIFICACIÓN
-- ============================================

-- Ver todos los proyectos
SELECT * FROM projects;

-- Ver todos los trabajos
SELECT * FROM jobs;

-- Ver tipos de trabajo
SELECT * FROM work_types;

-- Ver registro de sincronizaciones
SELECT * FROM sync_log;

-- Consulta completa: proyectos con sus trabajos
SELECT 
    p.id AS project_id,
    p.name AS project_name,
    p.client,
    p.region,
    j.work_type_name,
    j.quantity,
    j.unit_price,
    j.total,
    j.unit
FROM projects p
LEFT JOIN jobs j ON p.id = j.project_id
ORDER BY p.created_at DESC;
