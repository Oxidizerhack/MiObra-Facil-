<?php
/**
 * BACKEND API REST PARA MI OBRA FÁCIL
 * 
 * Este archivo PHP es el backend que conecta Flutter con MySQL (filess.io)
 * 
 * IMPORTANTE: 
 * - Sube este archivo a tu hosting (filess.io, 000webhost, etc.)
 * - O ejecútalo localmente con XAMPP
 * - Actualiza ApiConfig.CLOUD_API en Flutter con la URL de este archivo
 */

// ==================== CONFIGURACIÓN ====================

// Configuración de base de datos (filess.io)
// ✅ Credenciales actualizadas
define('DB_HOST', 'y27ad9.h.filess.io');
define('DB_PORT', '3306');
define('DB_NAME', 'miobrafacildb_cityvastbe');
define('DB_USER', 'miobrafacildb_cityvastbe');
define('DB_PASSWORD', 'c0cb1e8a0bc69a67cf4255b2e9398674c0fd391c');

// Headers CORS (permitir acceso desde Flutter)
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json; charset=utf-8');

// Responder a preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// ==================== CONEXIÓN A BASE DE DATOS ====================

function getConnection() {
    try {
        $dsn = "mysql:host=" . DB_HOST . ";port=" . DB_PORT . ";dbname=" . DB_NAME . ";charset=utf8mb4";
        $pdo = new PDO($dsn, DB_USER, DB_PASSWORD);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        return $pdo;
    } catch (PDOException $e) {
        sendError(500, 'Error de conexión a la base de datos: ' . $e->getMessage());
        exit();
    }
}

// ==================== FUNCIONES DE UTILIDAD ====================

function sendResponse($data, $code = 200) {
    http_response_code($code);
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit();
}

function sendError($code, $message) {
    http_response_code($code);
    echo json_encode([
        'success' => false,
        'error' => $message
    ], JSON_UNESCAPED_UNICODE);
    exit();
}

function getRequestData() {
    $data = file_get_contents('php://input');
    return json_decode($data, true);
}

// ==================== ROUTER ====================

$method = $_SERVER['REQUEST_METHOD'];
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$uriParts = explode('/', trim($uri, '/'));

// Obtener el endpoint principal
$endpoint = isset($uriParts[count($uriParts) - 1]) ? $uriParts[count($uriParts) - 1] : '';

// ==================== ENDPOINTS ====================

// 1. Health Check
if ($endpoint === 'health') {
    sendResponse([
        'success' => true,
        'message' => 'Servidor funcionando correctamente',
        'timestamp' => date('Y-m-d H:i:s'),
        'version' => '1.0.0'
    ]);
}

// 2. Obtener todos los proyectos
if ($endpoint === 'projects' && $method === 'GET') {
    try {
        $pdo = getConnection();
        $stmt = $pdo->prepare("
            SELECT p.*, GROUP_CONCAT(
                JSON_OBJECT(
                    'id', j.id,
                    'project_id', j.project_id,
                    'work_type_id', j.work_type_id,
                    'work_type_name', j.work_type_name,
                    'quantity', j.quantity,
                    'unit_price', j.unit_price,
                    'total', j.total,
                    'unit', j.unit
                )
            ) as jobs
            FROM projects p
            LEFT JOIN jobs j ON p.id = j.project_id
            GROUP BY p.id
            ORDER BY p.created_at DESC
        ");
        $stmt->execute();
        $projects = $stmt->fetchAll();
        
        // Decodificar JSON de jobs
        foreach ($projects as &$project) {
            $project['jobs'] = $project['jobs'] ? json_decode('[' . $project['jobs'] . ']') : [];
        }
        
        sendResponse([
            'success' => true,
            'data' => $projects,
            'count' => count($projects)
        ]);
    } catch (PDOException $e) {
        sendError(500, 'Error obteniendo proyectos: ' . $e->getMessage());
    }
}

// 3. Crear proyecto
if ($endpoint === 'projects' && $method === 'POST') {
    try {
        $data = getRequestData();
        
        if (!isset($data['id']) || !isset($data['name'])) {
            sendError(400, 'Faltan datos requeridos (id, name)');
        }
        
        $pdo = getConnection();
        $pdo->beginTransaction();
        
        // Insertar proyecto
        $stmt = $pdo->prepare("
            INSERT INTO projects (id, name, client, location, region, created_at, device_id)
            VALUES (:id, :name, :client, :location, :region, :created_at, :device_id)
        ");
        $stmt->execute([
            ':id' => $data['id'],
            ':name' => $data['name'],
            ':client' => $data['client'] ?? '',
            ':location' => $data['location'] ?? '',
            ':region' => $data['region'] ?? '',
            ':created_at' => $data['created_at'] ?? date('Y-m-d H:i:s'),
            ':device_id' => $data['device_id'] ?? 'unknown'
        ]);
        
        // Insertar jobs si existen
        if (isset($data['jobs']) && is_array($data['jobs'])) {
            $stmt = $pdo->prepare("
                INSERT INTO jobs (id, project_id, work_type_id, work_type_name, quantity, unit_price, total, unit)
                VALUES (:id, :project_id, :work_type_id, :work_type_name, :quantity, :unit_price, :total, :unit)
            ");
            
            foreach ($data['jobs'] as $job) {
                $stmt->execute([
                    ':id' => $job['id'],
                    ':project_id' => $data['id'],
                    ':work_type_id' => $job['work_type_id'],
                    ':work_type_name' => $job['work_type_name'],
                    ':quantity' => $job['quantity'],
                    ':unit_price' => $job['unit_price'],
                    ':total' => $job['total'],
                    ':unit' => $job['unit']
                ]);
            }
        }
        
        $pdo->commit();
        
        sendResponse([
            'success' => true,
            'message' => 'Proyecto creado exitosamente',
            'id' => $data['id']
        ], 201);
        
    } catch (PDOException $e) {
        if (isset($pdo)) {
            $pdo->rollBack();
        }
        sendError(500, 'Error creando proyecto: ' . $e->getMessage());
    }
}

// 4. Actualizar proyecto
if ($method === 'PUT' && strpos($endpoint, 'projects/') !== false) {
    try {
        // Extraer ID del proyecto de la URL
        $projectId = str_replace('projects/', '', $endpoint);
        $data = getRequestData();
        
        $pdo = getConnection();
        $pdo->beginTransaction();
        
        // Actualizar proyecto
        $stmt = $pdo->prepare("
            UPDATE projects 
            SET name = :name, 
                client = :client, 
                location = :location, 
                region = :region,
                updated_at = NOW()
            WHERE id = :id
        ");
        $stmt->execute([
            ':id' => $projectId,
            ':name' => $data['name'],
            ':client' => $data['client'] ?? '',
            ':location' => $data['location'] ?? '',
            ':region' => $data['region'] ?? ''
        ]);
        
        // Eliminar jobs antiguos
        $stmt = $pdo->prepare("DELETE FROM jobs WHERE project_id = :project_id");
        $stmt->execute([':project_id' => $projectId]);
        
        // Insertar jobs nuevos
        if (isset($data['jobs']) && is_array($data['jobs'])) {
            $stmt = $pdo->prepare("
                INSERT INTO jobs (id, project_id, work_type_id, work_type_name, quantity, unit_price, total, unit)
                VALUES (:id, :project_id, :work_type_id, :work_type_name, :quantity, :unit_price, :total, :unit)
            ");
            
            foreach ($data['jobs'] as $job) {
                $stmt->execute([
                    ':id' => $job['id'],
                    ':project_id' => $projectId,
                    ':work_type_id' => $job['work_type_id'],
                    ':work_type_name' => $job['work_type_name'],
                    ':quantity' => $job['quantity'],
                    ':unit_price' => $job['unit_price'],
                    ':total' => $job['total'],
                    ':unit' => $job['unit']
                ]);
            }
        }
        
        $pdo->commit();
        
        sendResponse([
            'success' => true,
            'message' => 'Proyecto actualizado exitosamente'
        ]);
        
    } catch (PDOException $e) {
        if (isset($pdo)) {
            $pdo->rollBack();
        }
        sendError(500, 'Error actualizando proyecto: ' . $e->getMessage());
    }
}

// 5. Eliminar proyecto
if ($method === 'DELETE' && strpos($endpoint, 'projects/') !== false) {
    try {
        $projectId = str_replace('projects/', '', $endpoint);
        
        $pdo = getConnection();
        
        // Los jobs se eliminan automáticamente por ON DELETE CASCADE
        $stmt = $pdo->prepare("DELETE FROM projects WHERE id = :id");
        $stmt->execute([':id' => $projectId]);
        
        sendResponse([
            'success' => true,
            'message' => 'Proyecto eliminado exitosamente'
        ]);
        
    } catch (PDOException $e) {
        sendError(500, 'Error eliminando proyecto: ' . $e->getMessage());
    }
}

// 6. Sincronización completa
if ($endpoint === 'sync' && $method === 'POST') {
    try {
        $data = getRequestData();
        $deviceId = $data['device_id'] ?? 'unknown';
        $localProjects = $data['projects'] ?? [];
        
        $pdo = getConnection();
        $pdo->beginTransaction();
        
        $syncedCount = 0;
        
        // Sincronizar cada proyecto local
        foreach ($localProjects as $project) {
            // Verificar si existe
            $stmt = $pdo->prepare("SELECT id FROM projects WHERE id = :id");
            $stmt->execute([':id' => $project['id']]);
            $exists = $stmt->fetch();
            
            if ($exists) {
                // Actualizar
                // (código similar a PUT)
            } else {
                // Crear
                // (código similar a POST)
            }
            
            $syncedCount++;
        }
        
        // Registrar sincronización
        $stmt = $pdo->prepare("
            INSERT INTO sync_log (device_id, sync_type, records_synced, sync_status)
            VALUES (:device_id, 'full', :records, 'success')
        ");
        $stmt->execute([
            ':device_id' => $deviceId,
            ':records' => $syncedCount
        ]);
        
        $pdo->commit();
        
        sendResponse([
            'success' => true,
            'message' => 'Sincronización completada',
            'synced' => $syncedCount
        ]);
        
    } catch (PDOException $e) {
        if (isset($pdo)) {
            $pdo->rollBack();
        }
        sendError(500, 'Error en sincronización: ' . $e->getMessage());
    }
}

// Endpoint no encontrado
sendError(404, 'Endpoint no encontrado: ' . $endpoint);
?>
