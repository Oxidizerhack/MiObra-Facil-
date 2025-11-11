# 📚 Guía para Demostrar Base de Datos al Docente

## 🎯 Objetivo
Demostrar que la aplicación "Mi Obra Fácil" utiliza una base de datos local real y persistente.

---

## ✅ Pasos para la Demostración

### 1️⃣ **Abrir el Visor de Base de Datos en la App**

1. Abre la aplicación "Mi Obra Fácil" en tu dispositivo Android
2. Ve a la pestaña **"Dashboard"** (segunda pestaña en el menú inferior)
3. Toca el ícono de **almacenamiento** (📊) en la esquina superior derecha
4. Se abrirá la pantalla **"Visor de Base de Datos"**

### 2️⃣ **Mostrar Información de la BD**

En la pantalla del visor verás:

✅ **Información General:**
- Motor de BD: Hive (NoSQL)
- Tipo: Key-Value Store Local
- Ubicación del archivo: `/data/data/com.example.mi_obra_facil/app_flutter/`
- Archivo principal: `projects.hive`

✅ **Estadísticas en Tiempo Real:**
- Total de proyectos guardados
- Total de partidas/trabajos
- Regiones activas
- Tamaño estimado de la BD

✅ **Estructura de "Tablas":**
- WorkType (TypeId: 0) - Catálogo de 26 tipos de trabajo
- Job (TypeId: 1) - Partidas/trabajos
- Project (TypeId: 2) - Proyectos principales

✅ **Lista de Todos los Proyectos:**
- Expande la sección para ver cada proyecto con:
  - ID único (UUID)
  - Nombre del proyecto
  - Cliente
  - Región
  - Cantidad de partidas

### 3️⃣ **Demostrar Persistencia de Datos**

Esta es la prueba MÁS IMPORTANTE para tu docente:

1. **Crear un Proyecto de Prueba:**
   - Ve a "Proyectos" → Toca "+" Nuevo Proyecto
   - Llena los datos: "Proyecto Demo", "Cliente Test", región "La Paz"
   - Guarda el proyecto

2. **Agregar Partidas:**
   - Entra al proyecto
   - Agrega 2-3 trabajos (ej: Replanteo, Excavación, Piso cerámico)

3. **Cerrar COMPLETAMENTE la App:**
   - Ve a Configuración de Android
   - Apps → Mi Obra Fácil
   - **"Forzar Detención"** (Force Stop)
   
4. **Reabrir la App:**
   - Abre la app nuevamente
   - Ve a "Proyectos"
   - **EL PROYECTO SIGUE AHÍ** ✅ ← Esto demuestra persistencia

5. **Mostrar en el Visor de BD:**
   - Ve al Dashboard → Ícono de BD
   - El proyecto aparece en la lista con todos sus datos

### 4️⃣ **Ver el Archivo de BD con ADB** (Opcional - Más Técnico)

Si tu docente quiere ver el archivo físico:

```bash
# 1. Conectar el dispositivo Android por USB
# 2. Habilitar "Depuración USB" en el dispositivo
# 3. Abrir terminal/cmd en la computadora

# Verificar conexión
adb devices

# Listar archivos de la base de datos
adb shell ls -la /data/data/com.example.mi_obra_facil/app_flutter/

# Resultado esperado:
# projects.hive  <- Archivo de la base de datos
# projects.lock  <- Archivo de bloqueo
```

### 5️⃣ **Imprimir Info de BD en Consola** (Para Debug)

En el Visor de BD, toca el botón **"Imprimir Info en Consola (Debug)"**

Luego, en Android Studio:
1. Ve a la pestaña **"Logcat"** (parte inferior)
2. Filtra por "INFORMACIÓN DE BASE DE DATOS"
3. Verás todos los datos impresos en formato de texto

---

## 📊 Documentos de Respaldo

### Documento Principal: `DOCUMENTACION_BASE_DATOS.md`

Abre este archivo para mostrar:
- ✅ Diagrama ER (Modelo Entidad-Relación)
- ✅ Estructura de las 3 "tablas" (TypeAdapters)
- ✅ Campos de cada tabla con tipos de datos
- ✅ Código de operaciones CRUD
- ✅ Ejemplo de datos almacenados
- ✅ Referencias técnicas

---

## 🎓 Argumentos para el Docente

### "¿Dónde están las tablas?"

**Respuesta:**
> En Hive (base de datos NoSQL), no hay "tablas" como en SQL. En su lugar, usamos **TypeAdapters** que funcionan como esquemas de datos. Tenemos 3 TypeAdapters registrados:
> - **WorkType** (TypeId 0) - Catálogo de trabajos
> - **Job** (TypeId 1) - Partidas
> - **Project** (TypeId 2) - Proyectos
>
> Cada TypeAdapter define la estructura de datos, similar a una tabla en SQL.

### "¿Dónde se guarda?"

**Respuesta:**
> Los datos se guardan en archivos `.hive` en el almacenamiento interno del dispositivo Android:
> `/data/data/com.example.mi_obra_facil/app_flutter/projects.hive`
>
> Puedes verlos con ADB o mostrando el visor de BD integrado en la app.

### "¿Cómo funcionan las relaciones?"

**Respuesta:**
> - **Project** tiene una relación 1:N con **Job** (Un proyecto tiene muchos trabajos)
> - **Job** tiene una relación N:1 con **WorkType** (Muchos jobs usan un tipo de trabajo)
> - Las relaciones están implementadas mediante referencias de objetos y listas embebidas

### "¿Tiene CRUD?"

**Respuesta:**
> Sí, implementamos CRUD completo en `lib/providers/project_provider.dart`:
> - **CREATE:** `addProject()`, `addJobToProject()`
> - **READ:** `getProjectById()`, lista de `projects`
> - **UPDATE:** `updateProject()`, `updateJobInProject()`
> - **DELETE:** `deleteProject()`, `deleteJobFromProject()`

---

## 🔥 Demostración Rápida (5 minutos)

1. **Abrir App** → Dashboard → Ícono BD (30 seg)
2. **Mostrar Estadísticas** de la BD (30 seg)
3. **Mostrar Lista de Proyectos** guardados (1 min)
4. **Crear Proyecto Nuevo** → Agregar partidas (2 min)
5. **Cerrar App** (Force Stop) → **Reabrir** → Proyecto sigue ahí ✅ (1 min)
6. **Mostrar en Visor BD** que el proyecto está persistido (30 seg)

**Total: 5 minutos** ✅

---

## 📱 Capturas de Pantalla Recomendadas

Toma capturas de:
1. Pantalla del Visor de BD (información general)
2. Lista de proyectos en BD
3. Estadísticas de la BD
4. Consola de Android Studio con logs de BD
5. ADB mostrando archivo `projects.hive`

---

## ❓ Preguntas Frecuentes del Docente

### "¿Por qué usaron Hive y no SQLite?"

**Respuesta:**
> Hive es una base de datos NoSQL moderna diseñada específicamente para Flutter/Dart. Ventajas:
> - ✅ 10x más rápido que SQLite en operaciones de lectura
> - ✅ Type-safe (sin errores de casting)
> - ✅ No requiere escribir SQL queries
> - ✅ Más fácil de mantener (sin migraciones complejas)
> - ✅ Funciona 100% offline
>
> Es la solución recomendada para apps móviles modernas según la documentación oficial de Flutter.

### "¿Los datos se pierden al cerrar la app?"

**Respuesta:**
> NO. Hive persiste automáticamente todos los datos en el archivo `projects.hive`. La prueba de "Force Stop y reabrir" lo demuestra claramente.

### "¿Cuántos datos puede almacenar?"

**Respuesta:**
> Hive puede almacenar datos ilimitados (solo limitado por el espacio del dispositivo). En nuestra app:
> - Cada proyecto ocupa ~500 bytes
> - 100 proyectos = ~50 KB
> - 1000 proyectos = ~500 KB
>
> Es extremadamente eficiente.

---

## ✅ Checklist de Preparación

Antes de la presentación, verifica:

- [ ] La app está instalada y funcionando
- [ ] Hay al menos 2-3 proyectos creados con partidas
- [ ] El dispositivo tiene "Depuración USB" habilitada (para ADB)
- [ ] Android Studio está abierto con el proyecto
- [ ] Has leído el archivo `DOCUMENTACION_BASE_DATOS.md`
- [ ] Practicaste la demostración de persistencia
- [ ] Tienes las capturas de pantalla listas

---

## 📞 En Caso de Problemas

Si el docente tiene dudas:

1. Muestra el código fuente en `lib/models/project_model.dart` → Anotaciones `@HiveType` y `@HiveField`
2. Muestra `lib/models/project_model.g.dart` → Código generado automáticamente
3. Muestra `lib/providers/project_provider.dart` → Operaciones CRUD
4. Ejecuta el botón "Imprimir en Consola" y muestra el logcat

---

**¡Buena suerte en tu presentación! 🚀**

**Recuerda:** La clave es demostrar la **persistencia** (cerrar y abrir la app y que los datos sigan ahí). Eso es lo que diferencia una app con BD de una sin BD.
