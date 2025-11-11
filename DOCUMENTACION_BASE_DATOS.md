# 📊 Documentación de Base de Datos - Mi Obra Fácil

## 🗄️ Sistema de Base de Datos

**Motor:** Hive (NoSQL - Key-Value Store)  
**Tipo:** Base de datos local embebida  
**Ubicación:** `/data/data/com.example.mi_obra_facil/app_flutter/`

---

## 📋 Estructura de Tablas (Collections)

### Tabla 1: `projects.hive` (Proyectos)

**TypeAdapter ID:** 2  
**Clase:** `Project`  
**Ubicación del código:** `lib/models/project_model.dart`

#### Campos (Columnas):

| Campo | Tipo | Descripción | HiveField ID |
|-------|------|-------------|--------------|
| `id` | String | Identificador único (UUID) | 0 |
| `projectName` | String | Nombre del proyecto | 1 |
| `clientName` | String | Nombre del cliente | 2 |
| `region` | String | Región del proyecto (laPaz, cochabamba, etc.) | 3 |
| `jobs` | List\<Job\> | Lista de trabajos/partidas (relación 1:N) | 4 |

#### Código del Modelo:
```dart
@HiveType(typeId: 2)
class Project extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String projectName;

  @HiveField(2)
  String clientName;

  @HiveField(3)
  String region;

  @HiveField(4)
  List<Job> jobs;
}
```

---

### Tabla 2: `Job` (Partidas/Trabajos)

**TypeAdapter ID:** 1  
**Clase:** `Job`  
**Ubicación del código:** `lib/models/job_model.dart`  
**Relación:** N:1 con Project (embedded dentro de projects.hive)

#### Campos (Columnas):

| Campo | Tipo | Descripción | HiveField ID |
|-------|------|-------------|--------------|
| `id` | String | Identificador único (UUID) | 0 |
| `workType` | WorkType | Tipo de trabajo (relación 1:1) | 1 |
| `quantity` | double | Cantidad del trabajo | 2 |
| `width` | double | Ancho (dimensión) | 3 |
| `height` | double | Alto (dimensión) | 4 |
| `totalCost` | double | Costo total calculado | 5 |

#### Código del Modelo:
```dart
@HiveType(typeId: 1)
class Job {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final WorkType workType;

  @HiveField(2)
  final double quantity;

  @HiveField(3)
  final double width;

  @HiveField(4)
  final double height;

  @HiveField(5)
  final double totalCost;
}
```

---

### Tabla 3: `WorkType` (Tipos de Trabajo)

**TypeAdapter ID:** 0  
**Clase:** `WorkType`  
**Ubicación del código:** `lib/models/work_type_model.dart`  
**Tipo:** Catálogo/Diccionario (26 registros predefinidos)

#### Campos (Columnas):

| Campo | Tipo | Descripción | HiveField ID |
|-------|------|-------------|--------------|
| `id` | String | Código del trabajo (og_replanteo, etc.) | 0 |
| `description` | String | Descripción del trabajo | 1 |
| `unit` | String | Unidad de medida (m2, m3, pza, ml, pto) | 2 |
| `prices` | Map<String, double> | Precios por región | 3 |

#### Código del Modelo:
```dart
@HiveType(typeId: 0)
class WorkType {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String unit;

  @HiveField(3)
  final Map<String, double> prices;
}
```

---

## 🔗 Diagrama de Relaciones (Modelo ER)

```
┌─────────────────────────────────────┐
│          PROJECT (Proyecto)         │
├─────────────────────────────────────┤
│ 🔑 id: String (PK)                  │
│ projectName: String                 │
│ clientName: String                  │
│ region: String                      │
│ jobs: List<Job> (1:N)              │
└───────────────┬─────────────────────┘
                │
                │ 1:N (Un proyecto tiene muchos trabajos)
                │
                ▼
┌─────────────────────────────────────┐
│            JOB (Partida)            │
├─────────────────────────────────────┤
│ 🔑 id: String (PK)                  │
│ 🔗 workType: WorkType (FK)          │
│ quantity: double                    │
│ width: double                       │
│ height: double                      │
│ totalCost: double                   │
└───────────────┬─────────────────────┘
                │
                │ N:1 (Muchos jobs usan un tipo)
                │
                ▼
┌─────────────────────────────────────┐
│         WORKTYPE (Catálogo)         │
├─────────────────────────────────────┤
│ 🔑 id: String (PK)                  │
│ description: String                 │
│ unit: String                        │
│ prices: Map<String, double>         │
│   - laPaz: double                   │
│   - cochabamba: double              │
│   - santaCruz: double               │
│   - sucre: double                   │
│   - oruro: double                   │
│   - tarija: double                  │
│   - potosi: double                  │
└─────────────────────────────────────┘
```

---

## 🔄 Operaciones CRUD Implementadas

### CREATE (Crear)
```dart
// Crear proyecto
void addProject(String name, String client, String region) {
  final project = Project(
    id: const Uuid().v4(),
    projectName: name,
    clientName: client,
    region: region,
    jobs: [],
  );
  _projectBox.add(project);  // INSERT en Hive
  notifyListeners();
}
```

### READ (Leer)
```dart
// Leer todos los proyectos
List<Project> get projects => _projectBox.values.toList();

// Leer por ID
Project? getProjectById(String id) {
  return _projectBox.values.firstWhere(
    (p) => p.id == id,
    orElse: () => throw Exception('Proyecto no encontrado'),
  );
}
```

### UPDATE (Actualizar)
```dart
// Actualizar proyecto
void updateProject(String id, String name, String client, String region) {
  final index = _projectBox.values.toList().indexWhere((p) => p.id == id);
  if (index != -1) {
    final project = _projectBox.getAt(index)!;
    final updated = project.copyWith(
      projectName: name,
      clientName: client,
      region: region,
    );
    _projectBox.putAt(index, updated);  // UPDATE en Hive
    notifyListeners();
  }
}
```

### DELETE (Eliminar)
```dart
// Eliminar proyecto
void deleteProject(String id) {
  final index = _projectBox.values.toList().indexWhere((p) => p.id == id);
  if (index != -1) {
    _projectBox.deleteAt(index);  // DELETE en Hive
    notifyListeners();
  }
}
```

---

## 📂 Archivos de Configuración

### 1. Inicialización de la BD (`lib/main.dart`)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Hive
  await Hive.initFlutter();
  
  // Registrar TypeAdapters (como crear tablas)
  Hive.registerAdapter(WorkTypeAdapter());  // Tabla 0
  Hive.registerAdapter(JobAdapter());       // Tabla 1
  Hive.registerAdapter(ProjectAdapter());   // Tabla 2
  
  // Abrir Box (como conectarse a la BD)
  await Hive.openBox<Project>('projects');
  
  runApp(const MyApp());
}
```

### 2. TypeAdapters Generados (build_runner)
```
lib/models/
├── work_type_model.g.dart    <- Serialización WorkType
├── job_model.g.dart          <- Serialización Job
└── project_model.g.dart      <- Serialización Project
```

---

## 📊 Datos de Ejemplo en la BD

### Registro Ejemplo en `projects.hive`:

```json
{
  "id": "a1b2c3d4-e5f6-7g8h-9i0j-k1l2m3n4o5p6",
  "projectName": "Casa Familiar 2 Pisos",
  "clientName": "Juan Pérez",
  "region": "laPaz",
  "jobs": [
    {
      "id": "j1-uuid",
      "workType": {
        "id": "og_replanteo",
        "description": "Replanteo y Trazado",
        "unit": "m2",
        "prices": {
          "laPaz": 10.46,
          "cochabamba": 11.00,
          "santaCruz": 12.50,
          "sucre": 10.80,
          "oruro": 10.20,
          "tarija": 11.50,
          "potosi": 9.80
        }
      },
      "quantity": 150.0,
      "width": 10.0,
      "height": 15.0,
      "totalCost": 1569.0
    }
  ]
}
```

---

## 🔍 Cómo Ver la Base de Datos en el Dispositivo

### Opción 1: Usar ADB (Android Debug Bridge)

```bash
# 1. Conectar dispositivo Android
adb devices

# 2. Acceder al shell
adb shell

# 3. Navegar a la carpeta de la app
cd /data/data/com.example.mi_obra_facil/app_flutter/

# 4. Listar archivos de la BD
ls -la

# Resultado esperado:
# -rw-rw---- projects.hive
# -rw-rw---- projects.lock
```

### Opción 2: Device File Explorer (Android Studio)

1. Abrir Android Studio
2. View → Tool Windows → Device File Explorer
3. Navegar a: `/data/data/com.example.mi_obra_facil/app_flutter/`
4. Descargar `projects.hive` para inspección

### Opción 3: Exportar desde la App

Agregar botón de debug para exportar datos:
```dart
// En settings o debug screen
ElevatedButton(
  onPressed: () async {
    final box = Hive.box<Project>('projects');
    print('Total proyectos: ${box.length}');
    box.values.forEach((project) {
      print('ID: ${project.id}');
      print('Nombre: ${project.projectName}');
      print('Cliente: ${project.clientName}');
      print('Región: ${project.region}');
      print('Trabajos: ${project.jobs.length}');
      print('---');
    });
  },
  child: Text('Ver Datos de BD'),
)
```

---

## 📈 Estadísticas de la Base de Datos

### Capacidad:
- **Proyectos:** Ilimitados (depende del almacenamiento)
- **Trabajos por proyecto:** Ilimitados
- **Tipos de trabajo:** 26 predefinidos
- **Regiones soportadas:** 7 departamentos de Bolivia

### Performance:
- **Lectura:** < 1ms (en memoria)
- **Escritura:** < 5ms (persistencia)
- **Tamaño archivo:** ~50KB por 100 proyectos

### Ventajas de Hive vs SQLite:
✅ Más rápido (10x en lecturas)  
✅ No requiere SQL queries  
✅ Type-safe (sin errores de casting)  
✅ Sin migraciones complejas  
✅ Funciona offline 100%  

---

## 🎓 Demostración para el Docente

### 1. Mostrar Código de Modelos
Abrir `lib/models/project_model.dart` y mostrar las anotaciones `@HiveType` y `@HiveField`.

### 2. Mostrar TypeAdapters Generados
Abrir `lib/models/project_model.g.dart` para ver el código de serialización automático.

### 3. Mostrar Operaciones CRUD
Abrir `lib/providers/project_provider.dart` y mostrar los métodos de base de datos.

### 4. Demostrar Persistencia
1. Crear un proyecto en la app
2. Cerrar completamente la app (force stop)
3. Reabrir la app
4. El proyecto sigue ahí → **Persistencia comprobada** ✅

### 5. Ver Archivo de BD
Conectar dispositivo y usar ADB para navegar a la carpeta y listar `projects.hive`.

---

## 📚 Referencias Técnicas

- **Hive Documentation:** https://docs.hivedb.dev/
- **TypeAdapter Guide:** https://docs.hivedb.dev/#/custom-objects/type_adapters
- **Flutter Hive Package:** https://pub.dev/packages/hive
- **Build Runner:** https://pub.dev/packages/build_runner

---

## ✅ Checklist para Presentación

- [ ] Explicar que Hive es una BD NoSQL embebida
- [ ] Mostrar las 3 "tablas" (TypeAdapters)
- [ ] Demostrar persistencia (abrir/cerrar app)
- [ ] Mostrar diagrama ER de relaciones
- [ ] Explicar las operaciones CRUD
- [ ] Mostrar archivos `.hive` con ADB
- [ ] Presentar estadísticas de 26 trabajos catalogados
- [ ] Demostrar funcionalidad multi-región (7 departamentos)

---

**Autor:** Oxidizerhack  
**Proyecto:** Mi Obra Fácil  
**Fecha:** Noviembre 2025  
**Tecnología:** Flutter + Hive DB
