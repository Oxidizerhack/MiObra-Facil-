/// Configuración de la API para conexión con backend MySQL
class ApiConfig {
  // ==================== URLs DE BACKEND ====================
  
  /// URL para desarrollo local con XAMPP
  /// Cambia la IP a la de tu computadora en la red local
  /// Para obtenerla: ipconfig (Windows) o ifconfig (Mac/Linux)
  static const String LOCAL_API = 'http://192.168.1.10/miobrafacil/api';
  
  /// URL para producción (Railway + filess.io MySQL)
  /// ✅ Configurado con Railway hosting
  static const String CLOUD_API = 'https://miobra-facil-production.up.railway.app';
  
  /// URL base que se usará en la app
  /// true = usa CLOUD_API (producción - filess.io)
  /// false = usa LOCAL_API (desarrollo - XAMPP)
  static String get baseUrl {
    return const bool.fromEnvironment('USE_CLOUD', defaultValue: true)
        ? CLOUD_API
        : LOCAL_API;
  }
  
  // ==================== ENDPOINTS ====================
  // ✅ Endpoints configurados para API de filess.io
  
  /// Endpoint para verificar estado del servidor
  static String get healthEndpoint => '$baseUrl/health';
  
  /// Endpoints de proyectos
  static String get projectsEndpoint => '$baseUrl/projects';
  static String projectByIdEndpoint(String id) => '$baseUrl/projects/$id';
  
  /// Endpoints de trabajos/jobs
  static String get jobsEndpoint => '$baseUrl/jobs';
  static String jobsByProjectEndpoint(String projectId) => '$baseUrl/projects/$projectId/jobs';
  
  /// Endpoints de tipos de trabajo
  static String get workTypesEndpoint => '$baseUrl/work-types';
  
  /// Endpoint de sincronización (filess.io usa su propia lógica)
  static String get syncEndpoint => '$baseUrl/sync';
  static String get syncUpEndpoint => '$baseUrl/sync/upload';
  static String get syncDownEndpoint => '$baseUrl/sync/download';
  
  // ==================== CONFIGURACIÓN ====================
  
  /// Timeout para peticiones HTTP (en segundos)
  static const int requestTimeout = 30;
  
  /// Número máximo de reintentos en caso de fallo
  static const int maxRetries = 3;
  
  /// Intervalo entre reintentos (en segundos)
  static const int retryDelay = 2;
  
  /// API Key de filess.io (Bearer Token)
  static const String FILESS_API_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjcxZWRmMmE3LTExOTItNGJmMS05YzdmLTA5M2IxNmJhZjU1ZSIsImlhdCI6MTc2Mjg4NTU5MywiZXhwIjozMTczMDczMjc5OTN9.vVtHWhP9l6aY5x7-tSu6SC3E3Hu-d13oQVcHmaSwYhY';
  
  /// Headers comunes para todas las peticiones
  static Map<String, String> get headers => {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Authorization': 'Bearer $FILESS_API_KEY',
  };
  
  // ==================== CREDENCIALES FILESS.IO ====================
  // ✅ Configurado con tus credenciales NUEVAS de filess.io
  // Estas credenciales coinciden con las de backend/api.php
  
  static const String DB_HOST = 'y27ad9.h.filess.io';
  static const String DB_PORT = '3306';
  static const String DB_NAME = 'miobrafacildb_cityvastbe';
  static const String DB_USER = 'miobrafacildb_cityvastbe';
  static const String DB_PASSWORD = 'c0cb1e8a0bc69a67cf4255b2e9398674c0fd391c';
  
  // ==================== CONFIGURACIÓN DE SINCRONIZACIÓN ====================
  
  /// Sincronizar automáticamente al abrir la app
  static const bool autoSyncOnStart = true;
  
  /// Sincronizar solo con WiFi (ahorro de datos móviles)
  static const bool syncOnlyOnWifi = false;
  
  /// Intervalo de sincronización automática (en minutos)
  /// 0 = desactivado
  static const int autoSyncIntervalMinutes = 15;
  
  /// ID único del dispositivo (se genera automáticamente)
  static String? _deviceId;
  static String get deviceId => _deviceId ?? 'unknown-device';
  static set deviceId(String id) => _deviceId = id;
}
