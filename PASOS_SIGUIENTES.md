# 🚀 Guía Rápida: Usar filess.io con Tu App

## ✅ Configuración Completada

### 📝 Tus Credenciales de filess.io

**Base de Datos MySQL:**
- Host: `y27ad9.h.filess.io`
- Port: `3306`
- Database: `miobrafacildb`
- User: `miobrafacildb_cityvastbe`
- Password: `c0cb1e8a0bc69a67cf4255b2e9398674c0fd391c`

**API Key:**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjcxZWRmMmE3LTExOTItNGJmMS05YzdmLTA5M2IxNmJhZjU1ZSIsImlhdCI6MTc2Mjg4NTU5MywiZXhwIjozMTczMDczMjc5OTN9.vVtHWhP9l6aY5x7-tSu6SC3E3Hu-d13oQVcHmaSwYhY
```

---

## 🎯 ¿Qué Tengo que Hacer Ahora?

### Opción 1: Subir el Backend PHP a filess.io (Recomendado)

1. **Accede a filess.io → File Manager**

2. **Navega a la carpeta web pública**
   - Busca `public_html/` o `www/`

3. **Sube el archivo `api.php`**
   - Arrastra `backend/api.php` desde tu computadora
   - O usa el botón "Upload"

4. **La URL de tu API será:**
   ```
   https://miobrafacildb.filess.io/api.php
   ```

5. **Actualiza Flutter:**
   - Edita `lib/config/api_config.dart` línea 13
   - Cambia a: `static const String CLOUD_API = 'https://miobrafacildb.filess.io/api.php';`

### Opción 2: Usar la API REST Automática de filess.io

Si filess.io ya te da endpoints REST automáticos para tus tablas:

1. **No necesitas subir `api.php`**

2. **Usa directamente los endpoints de filess.io:**
   ```
   https://miobrafacildb.filess.io/api/projects
   ```

3. **Flutter ya está configurado con tu API Key** ✅

---

## 🧪 Probar la Conexión

### Paso 1: Probar desde Navegador

Abre esta URL (reemplaza con tu URL real):
```
https://miobrafacildb.filess.io/api.php/health
```

**Si funciona, verás:**
```json
{
  "success": true,
  "message": "Servidor funcionando correctamente",
  "timestamp": "2025-11-11 12:00:00",
  "version": "1.0.0"
}
```

**Si NO funciona:**
- Verifica que subiste `api.php` correctamente
- Confirma la URL exacta en filess.io

### Paso 2: Probar desde la App

1. **Compila la app:**
   ```powershell
   flutter build apk --release
   ```

2. **Instala en tu celular**

3. **Abre la app → Dashboard → Ícono Nube ☁️**

4. **Presiona "Probar Conexión al Servidor"**

**Resultado esperado:**
```
✅ Servidor respondiendo correctamente
```

---

## 📱 Sincronizar Datos

### Paso a Paso:

1. **Crea un proyecto de prueba** en la app
   - Nombre: "Proyecto Test"
   - Cliente: "Tu Nombre"
   - Región: La Paz
   - Agrega 1-2 trabajos

2. **Ve al Dashboard**

3. **Presiona el ícono de nube** ☁️ (Sincronización)

4. **Presiona "Sincronizar Ahora"**

5. **Debe mostrar:**
   ```
   ✅ Sincronizado: 1 subidos, 0 descargados
   ```

6. **Verifica en filess.io:**
   - Abre phpMyAdmin
   - Tabla `projects` → debe tener 1 registro
   - Tabla `jobs` → debe tener tus trabajos

---

## 🔧 Si Algo No Funciona

### Error: "Sin conexión al servidor"

**Posibles causas:**

1. **No subiste `api.php` a filess.io**
   - Solución: Sube el archivo al File Manager

2. **URL incorrecta en Flutter**
   - Solución: Verifica línea 13 de `api_config.dart`
   - Debe ser: `https://tu-dominio.filess.io/api.php`

3. **Sin internet en el celular**
   - Solución: Verifica WiFi o datos móviles

### Error: "401 Unauthorized"

**Causa:** API Key incorrecta

**Solución:**
- La API Key ya está configurada ✅
- Si persiste, regenera la key en filess.io

### Error: "500 Internal Server Error"

**Causa:** Error en PHP o credenciales MySQL

**Solución:**
1. Revisa logs en filess.io → Dashboard → Error Logs
2. Verifica que las credenciales en `api.php` sean correctas
3. Confirma que las 4 tablas existan

---

## 📊 Verificar Tablas en filess.io

1. **Accede a phpMyAdmin**:
   - filess.io → Dashboard → phpMyAdmin

2. **Selecciona tu database**: `miobrafacildb`

3. **Verifica estas 4 tablas**:
   - ✅ `projects`
   - ✅ `jobs`
   - ✅ `work_types`
   - ✅ `sync_log`

4. **Si faltan tablas**, ejecuta el SQL:
   - Ve a pestaña "SQL"
   - Copia el script de `GUIA_FILESSIO_MYSQL.md` (líneas 54-111)
   - Ejecuta

---

## 🎓 Para la Presentación

### Demostración Completa (5 minutos):

1. **Mostrar Hive Local** (offline):
   - Dashboard → Storage 💾
   - "Esta es mi base de datos local, funciona sin internet"

2. **Crear proyecto**:
   - Crear proyecto nuevo en la app
   - Agregar 2-3 trabajos

3. **Sincronizar**:
   - Dashboard → Cloud ☁️
   - "Sincronizar Ahora"
   - Mostrar mensaje: "✅ 1 subidos"

4. **Mostrar MySQL Cloud**:
   - Abrir phpMyAdmin en filess.io
   - Tabla `projects` → mostrar proyecto recién creado
   - "Aquí está mi base de datos MySQL en la nube"

5. **Explicar arquitectura**:
   - "Sistema híbrido: Hive local + MySQL nube"
   - "App funciona offline, sincroniza cuando hay internet"
   - "Backup automático en filess.io"

---

## ✅ Checklist Final

- [x] Credenciales configuradas en Flutter
- [x] API Key configurada
- [x] Tablas creadas en filess.io
- [ ] **Subir `api.php` a filess.io**
- [ ] **Actualizar URL en `api_config.dart`**
- [ ] **Compilar APK con nueva config**
- [ ] **Probar sincronización**
- [ ] **Verificar datos en phpMyAdmin**

---

## 🚀 Próximo Paso Inmediato

**SUBE EL ARCHIVO `api.php` A FILESS.IO**

1. Ve a: filess.io → File Manager
2. Busca la carpeta `public_html/` o `www/`
3. Sube `backend/api.php`
4. Anota la URL completa (ej: `https://miobrafacildb.filess.io/api.php`)
5. Actualiza línea 13 de `lib/config/api_config.dart` con esa URL
6. Compila: `flutter build apk --release`
7. Prueba la sincronización ✅

---

¿Necesitas ayuda con algún paso específico? 🤔
