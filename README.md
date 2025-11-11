# 🏗️ Mi Obra Fácil

<div align="center">

![Mi Obra Fácil](assets/images/logo.png)

**Aplicación profesional para presupuestos de construcción en Bolivia**

[![Flutter Version](https://img.shields.io/badge/Flutter-3.24.4-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.5.4-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android)](https://www.android.com)

</div>

---

## 📋 Descripción

**Mi Obra Fácil** es una aplicación móvil diseñada para profesionales de la construcción en Bolivia que permite:

- ✅ Crear presupuestos de obra detallados
- 📊 Visualizar estadísticas y análisis de costos
- 💾 Guardar proyectos localmente con persistencia
- 📄 Exportar presupuestos en formato PDF
- 🌍 Calcular precios según región (La Paz, Cochabamba, Santa Cruz)
- 🏗️ Gestionar 26 tipos de trabajos en 3 categorías

---

## ✨ Características Principales

### 🎯 Gestión de Proyectos
- **CRUD Completo**: Crear, leer, actualizar y eliminar proyectos
- **Información Detallada**: Nombre del proyecto, cliente, región
- **Partidas Personalizables**: Agregar y eliminar trabajos específicos
- **Cálculo Automático**: Totales por categoría y proyecto

### 📊 Dashboard Analítico
- **Estadísticas Generales**: Total de proyectos, costos totales
- **Gráficos por Categoría**: Obra Gruesa, Obra Fina, Instalaciones
- **Desglose Regional**: Análisis de costos por departamento
- **Top 3 Proyectos**: Ranking de proyectos más costosos

### 💾 Persistencia de Datos
- **Base de Datos Local**: Implementación con Hive
- **Almacenamiento Eficiente**: Sin conexión a internet requerida
- **TypeAdapters Generados**: Serialización automática

### 🎨 Interfaz Moderna
- **Material Design 3**: UI/UX actualizado
- **Splash Screen Personalizado**: Logo y fondo de marca (3 segundos)
- **Tema Personalizado**: Colores naranja (#FF6B35) y azul (#004E89)
- **Modo Oscuro**: Soporte para tema claro y oscuro

### 📄 Exportación PDF
- **Presupuestos Profesionales**: Generación de PDF detallado
- **Formato Boliviano**: Adaptado a estándares locales
- **Logo y Marca**: Documentos personalizados

---

## 🏗️ Categorías de Trabajo

### 🧱 Obra Gruesa (10 trabajos)
Replanteo, excavación, cimientos, sobrecimientos, columnas, vigas, losas, muros, revoques, contrapisos

### 🎨 Obra Fina (10 trabajos)
Pisos cerámicos, azulejos, carpintería madera, carpintería metálica, vidrios, pintura, cielo raso, impermeabilización, mesones, portones

### ⚡ Instalaciones (6 trabajos)
Sanitarias, eléctricas, agua potable, gas, red contra incendios, sistema de seguridad

---

## 🚀 Instalación

### Prerrequisitos

- Flutter SDK 3.24.4 o superior
- Dart SDK 3.5.4 o superior
- Android Studio / VS Code
- Git

### Pasos de Instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/Oxidizerhack/MiObra-Facil-.git

# 2. Navegar al directorio
cd MiObra-Facil-

# 3. Instalar dependencias
flutter pub get

# 4. Generar archivos de Hive (TypeAdapters)
flutter pub run build_runner build

# 5. Ejecutar la aplicación
flutter run
```

### Construir APK para Android

```bash
# APK de producción
flutter build apk --release

# APK se genera en: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📦 Dependencias Principales

| Paquete | Versión | Uso |
|---------|---------|-----|
| `provider` | ^6.0.5 | Gestión de estado |
| `go_router` | ^14.0.0 | Navegación |
| `hive` | ^2.2.3 | Base de datos local |
| `hive_flutter` | ^1.1.0 | Integración Hive con Flutter |
| `printing` | ^5.12.0 | Generación de PDF |
| `pdf` | ^3.10.8 | Manipulación de PDF |
| `uuid` | ^4.3.3 | Generación de IDs únicos |
| `flutter_launcher_icons` | ^0.13.1 | Iconos personalizados |
| `flutter_native_splash` | ^2.3.5 | Splash screen |

### Dev Dependencies

- `hive_generator` ^2.0.1
- `build_runner` ^2.4.6
- `flutter_lints` ^5.0.0

---

## 🏛️ Arquitectura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada
├── router.dart                  # Configuración de rutas
├── data/
│   ├── work_catalog.dart       # Catálogo de 26 trabajos
│   └── work_types.dart         # Definición de tipos
├── models/
│   ├── project_model.dart      # Modelo de proyecto
│   ├── job_model.dart          # Modelo de trabajo/partida
│   └── work_type_model.dart    # Modelo de tipo de trabajo
├── providers/
│   ├── project_provider.dart   # Estado de proyectos
│   └── region_provider.dart    # Estado de región seleccionada
├── screens/
│   ├── home_screen.dart        # Pantalla principal
│   ├── add_project_screen.dart # Crear proyecto
│   ├── edit_project_screen.dart # Editar proyecto
│   ├── project_detail_screen.dart # Detalles del proyecto
│   ├── calculator_screen.dart  # Calculadora de partidas
│   ├── select_item_screen.dart # Selección de trabajos
│   └── dashboard_screen.dart   # Estadísticas
├── widgets/
│   └── custom_cards.dart       # Componentes reutilizables
└── pdf_export_helper.dart      # Exportación a PDF

android/
├── app/
│   └── src/main/
│       ├── AndroidManifest.xml # Configuración Android
│       └── res/
│           ├── drawable/       # Splash screen
│           ├── mipmap-*/       # Iconos del launcher
│           └── values/         # Colores y estilos

assets/
├── icons/
│   └── app_icon.png           # Icono de la app (1024x1024)
└── images/
    ├── logo.png               # Logo (512x512)
    └── background.png         # Fondo splash (1080x1920)
```

---

## 🎨 Paleta de Colores

| Color | Hex | Uso |
|-------|-----|-----|
| **Naranja Principal** | `#FF6B35` | Botones, AppBar, acentos |
| **Azul Secundario** | `#004E89` | Enlaces, secundarios |
| **Azul Oscuro** | `#1A659E` | Modo oscuro |

---

## 💡 Uso de la Aplicación

### 1. Crear un Nuevo Proyecto

1. Toca el botón **"+ Nuevo Proyecto"**
2. Completa los datos:
   - Nombre del proyecto
   - Nombre del cliente
   - Región (La Paz, Cochabamba, Santa Cruz)
3. Toca **"Guardar Proyecto"**

### 2. Agregar Partidas al Proyecto

1. Entra al proyecto desde la lista
2. Toca el botón **"+ Agregar Partida"**
3. Selecciona el tipo de trabajo
4. Ingresa cantidad y dimensiones
5. El costo se calcula automáticamente

### 3. Ver Estadísticas

1. Navega a la pestaña **"Dashboard"**
2. Visualiza:
   - Total de proyectos activos
   - Costo total acumulado
   - Distribución por categorías
   - Análisis regional
   - Top 3 proyectos

### 4. Exportar a PDF

1. Desde el detalle del proyecto
2. Toca el ícono de **PDF** en el AppBar
3. El documento se genera y se puede compartir

---

## 🗺️ Precios Regionales

Los precios varían según la región de Bolivia:

| Tipo de Trabajo | La Paz | Cochabamba | Santa Cruz |
|-----------------|--------|------------|------------|
| Replanteo y trazado | 15 Bs/m² | 12 Bs/m² | 10 Bs/m² |
| Excavación | 120 Bs/m³ | 100 Bs/m³ | 90 Bs/m³ |
| Piso cerámico | 180 Bs/m² | 160 Bs/m² | 150 Bs/m² |
| ... | ... | ... | ... |

*(Ver `lib/data/work_catalog.dart` para precios completos)*

---

## 🛠️ Desarrollo

### Generar TypeAdapters de Hive

Después de modificar modelos:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Hot Reload

Durante el desarrollo:

```bash
flutter run
# Presiona 'r' para hot reload
# Presiona 'R' para hot restart
```

---

## 📝 Tareas Pendientes

- [ ] 📤 Compartir presupuestos por WhatsApp y email
- [ ] 🔍 Búsqueda y filtros de proyectos
- [ ] 💰 Panel de actualización de precios regionales
- [ ] 🎨 Más animaciones y transiciones
- [ ] 🌐 Sincronización en la nube (opcional)
- [ ] 📊 Exportar datos a Excel

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

---

## 👨‍💻 Autor

**Oxidizerhack**

- GitHub: [@Oxidizerhack](https://github.com/Oxidizerhack)
- Proyecto: [MiObra-Facil-](https://github.com/Oxidizerhack/MiObra-Facil-)

---

## 🙏 Agradecimientos

- Comunidad Flutter Bolivia
- Profesionales de la construcción que inspiraron esta herramienta
- Equipo de Flutter y Dart

---

<div align="center">

**Hecho con ❤️ en Bolivia 🇧🇴**

⭐ Si te gusta el proyecto, dale una estrella en GitHub

</div>
```