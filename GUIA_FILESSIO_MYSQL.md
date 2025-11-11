# 🌐 Guía de Configuración: filess.io + MySQL + Flutter

## 📋 Paso 1: Crear Cuenta en filess.io

### 1.1 Registro
1. Ve a: https://filess.io
2. Clic en **"Sign Up"** o **"Registrarse"**
3. Completa el formulario:
   - Email
   - Contraseña
   - Confirmar email

### 1.2 Crear Base de Datos MySQL
1. Una vez logueado, ve a **"Databases"** o **"Bases de Datos"**
2. Clic en **"Create New Database"**
3. Selecciona **MySQL**
4. Configura:
   - **Database Name**: `miobrafacil_db`
   - **Region**: Elige el más cercano (Brasil o USA)
   - **Plan**: FREE (suficiente para desarrollo)
5. Clic en **"Create"**

### 1.3 Obtener Credenciales de Conexión
Después de crear la BD, filess.io te dará:

```
Host: xxxxx.filess.io
Port: 3307 (o 3306)
Database: miobrafacil_db
Username: miobrafacil_userXXXX
Password: xxxxxxxxxxxxxxxxxx
```

⚠️ **GUARDA ESTAS CREDENCIALES** - Las necesitarás para Flutter

---

## 🗄️ Paso 2: Crear Tablas en MySQL

### 2.1 Acceder a phpMyAdmin
1. En filess.io, busca el botón **"Open phpMyAdmin"** o **"Manage Database"**
2. Ingresa con las credenciales que te dieron
3. Selecciona tu database `miobrafacil_db`

### 2.2 Ejecutar Script SQL

Copia y pega este SQL en la pestaña **"SQL"**:

```sql
-- Tabla: projects (Proyectos)
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

-- Tabla: jobs (Trabajos/Items de cada proyecto)
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

-- Tabla: work_types (Catálogo de tipos de trabajo)
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

-- Tabla: sync_log (Registro de sincronizaciones)
CREATE TABLE IF NOT EXISTS sync_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    device_id VARCHAR(100) NOT NULL,
    sync_type VARCHAR(50) NOT NULL,
    records_synced INT DEFAULT 0,
    sync_status VARCHAR(20) NOT NULL,
    sync_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    error_message TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

3. Clic en **"Ejecutar"** o **"Go"**
4. Verifica que las 4 tablas se crearon correctamente

---

## 🔌 Paso 3: Backend API REST (Opcional pero Recomendado)

### ⚠️ Importante: Seguridad
**NO conectes Flutter directamente a MySQL** por seguridad. Necesitas un backend intermediario.

### Opción A: PHP Simple (Recomendado para principiantes)

**Estructura del backend:**
```
backend/
  ├── config/
  │   └── database.php
  ├── api/
  │   ├── projects/
  │   │   ├── get_all.php
  │   │   ├── create.php
  │   │   ├── update.php
  │   │   └── delete.php
  │   └── sync.php
  └── index.php
```

### Opción B: Usar Servicio Serverless
- **Supabase** (tiene MySQL + API automática) ✅ Más fácil
- **Railway.app** (deploy PHP/Node.js gratis)
- **Vercel** (para Node.js/Next.js API)

---

## 📱 Paso 4: Conexión desde Flutter

### 4.1 Agregar Dependencias

Tu `pubspec.yaml` necesitará:

```yaml
dependencies:
  http: ^1.1.0              # Para llamadas API REST
  connectivity_plus: ^5.0.2  # Detectar conexión a internet
  sqflite: ^2.3.0           # SQLite local (alternativa a Hive)
```

### 4.2 Estructura del Servicio de Sincronización

```dart
// lib/services/sync_service.dart
class SyncService {
  static const String API_URL = 'https://tu-backend.com/api';
  
  // Sincronizar proyectos locales (Hive) → MySQL
  Future<void> syncToCloud() async {
    // 1. Obtener proyectos de Hive que no están sincronizados
    // 2. Enviarlos al backend via POST
    // 3. Marcar como sincronizados
  }
  
  // Descargar proyectos de MySQL → Hive local
  Future<void> syncFromCloud() async {
    // 1. GET proyectos desde backend
    // 2. Guardar en Hive local
  }
}
```

---

## 🎯 Arquitectura del Sistema Híbrido

```
┌─────────────────────────────────────┐
│   FLUTTER APP (Mi Obra Fácil)      │
├─────────────────────────────────────┤
│                                     │
│  ┌──────────────┐  ┌─────────────┐ │
│  │  HIVE LOCAL  │  │ Sync Service│ │
│  │  (Offline)   │←→│  (Hybrid)   │ │
│  └──────────────┘  └──────┬──────┘ │
│                           │         │
└───────────────────────────┼─────────┘
                            │
                    ┌───────▼────────┐
                    │   INTERNET     │
                    └───────┬────────┘
                            │
                    ┌───────▼────────┐
                    │  BACKEND API   │
                    │  (PHP/Node.js) │
                    └───────┬────────┘
                            │
                    ┌───────▼────────┐
                    │ MySQL (filess) │
                    │  ☁️ Cloud DB   │
                    └────────────────┘
```

### Flujo de Trabajo:

1. **Usuario sin internet**:
   - ✅ App funciona normal con Hive
   - ✅ CRUD local completo
   - 📝 Marca proyectos como "pendiente sincronización"

2. **Usuario con internet**:
   - 🔄 Sincronización automática al abrir app
   - ⬆️ Sube proyectos locales a MySQL
   - ⬇️ Descarga proyectos de otros dispositivos
   - ✅ Mantiene copia local en Hive

3. **Ventajas**:
   - ✅ App funciona 100% offline
   - ✅ Datos respaldados en nube
   - ✅ Multi-dispositivo (mismo usuario, varios celulares)
   - ✅ No pierde datos si desinstala app

---

## 🔐 Credenciales de Ejemplo (filess.io)

**IMPORTANTE**: Nunca pongas credenciales directamente en el código.

### Método Seguro: Variables de Entorno

```dart
// lib/config/api_config.dart
class ApiConfig {
  // Para desarrollo local (XAMPP)
  static const String LOCAL_API = 'http://192.168.1.10/miobrafacil/api';
  
  // Para producción (filess.io backend)
  static const String CLOUD_API = 'https://tu-backend-url.com/api';
  
  // Usar según ambiente
  static String get baseUrl {
    return const bool.fromEnvironment('USE_CLOUD', defaultValue: true)
        ? CLOUD_API
        : LOCAL_API;
  }
}
```

---

## 🧪 Pruebas de Conexión

### Test 1: Verificar Conexión a filess.io

```dart
// lib/services/database_test.dart
Future<void> testConnection() async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/health')
    );
    
    if (response.statusCode == 200) {
      print('✅ Conexión exitosa a filess.io');
    } else {
      print('❌ Error: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error de conexión: $e');
  }
}
```

---

## 📊 Comparación: Hive vs MySQL

| Característica | Hive (Local) | MySQL (filess.io) |
|----------------|--------------|-------------------|
| **Offline** | ✅ Sí | ❌ No |
| **Multi-dispositivo** | ❌ No | ✅ Sí |
| **Backup automático** | ❌ No | ✅ Sí |
| **Velocidad** | ⚡ Muy rápido | 🐢 Depende de internet |
| **Consultas complejas** | ⚠️ Limitado | ✅ SQL completo |
| **Costo** | 💰 Gratis | 💰 Gratis (plan básico) |
| **Configuración** | ✅ Fácil | ⚠️ Media |

---

## 🎓 Para tu Presentación con el Docente

### Demostración Híbrida:

1. **Mostrar Hive (Local)**:
   - Abrir Database Viewer
   - Crear proyecto sin internet (modo avión)
   - Mostrar que persiste

2. **Mostrar MySQL (Nube)**:
   - Activar internet
   - Presionar botón "Sincronizar"
   - Abrir phpMyAdmin en filess.io
   - Mostrar datos en tabla `projects`

3. **Explicar Arquitectura**:
   - "Uso Hive para offline"
   - "MySQL en filess.io para backup y multi-dispositivo"
   - "Sistema híbrido con sincronización automática"

### Respuestas para Preguntas del Docente:

**P: ¿Dónde están tus tablas?**
- R: "Tengo dos capas: Hive local (TypeAdapters) y MySQL remoto (4 tablas en filess.io)"

**P: ¿Cómo se conecta la app a la BD?**
- R: "Uso API REST intermedia por seguridad, no conexión directa MySQL desde Flutter"

**P: ¿Qué pasa si no hay internet?**
- R: "App funciona 100% offline con Hive, sincroniza cuando hay conexión"

---

## 🚀 Próximos Pasos

1. ✅ Crear cuenta en filess.io
2. ✅ Crear base de datos MySQL
3. ✅ Ejecutar script SQL (4 tablas)
4. ⏳ Decidir backend: PHP simple o Supabase
5. ⏳ Implementar SyncService en Flutter
6. ⏳ Probar sincronización

---

## 🆘 Troubleshooting

### Error: "Connection refused"
- Verifica que filess.io esté activo
- Revisa firewall de Windows
- Confirma credenciales correctas

### Error: "API not reachable"
- Verifica URL del backend
- Prueba desde navegador primero
- Revisa logs del servidor

### Sincronización lenta
- Limita cantidad de registros (paginación)
- Usa compresión GZIP
- Implementa sync incremental (solo cambios)

---

## 📚 Recursos Adicionales

- **filess.io Docs**: https://filess.io/docs
- **MySQL Dart Package**: https://pub.dev/packages/mysql1
- **API REST Tutorial**: https://flutter.dev/docs/cookbook/networking/fetch-data
- **Hive + Cloud Sync**: https://docs.hivedb.dev/

---

¡Tu app estará lista para presentar con arquitectura profesional! 🎉
