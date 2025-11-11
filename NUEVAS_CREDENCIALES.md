# 🔑 CREDENCIALES ACTUALIZADAS - filess.io

## ✅ Nueva Configuración (Actualizada el 11 de noviembre 2025)

### 📝 Conexión MySQL

**URL Completa:**
```
mysql://root:7780ca6e77287b202017919674cd7aeb@3EOB2CHXUSc59.h.filess.io:49229
```

**Desglose de Credenciales:**
- **Host:** `3EOB2CHXUSc59.h.filess.io`
- **Port:** `49229`
- **Database:** `root` (o crea una nueva en phpMyAdmin)
- **User:** `root`
- **Password:** `7780ca6e77287b202017919674cd7aeb`

---

## 🚀 PASOS INMEDIATOS

### 1. Crear las Tablas en phpMyAdmin

1. **Accede a phpMyAdmin** en filess.io
   - Busca el botón "Web Client" o "phpMyAdmin"

2. **Selecciona la base de datos** (o créala):
   - Si usas la BD por defecto: selecciona `root`
   - **Recomendado:** Crea una nueva BD llamada `miobrafacil`:
     - Clic en "New" o "Nueva"
     - Nombre: `miobrafacil`
     - Collation: `utf8mb4_unicode_ci`
     - Clic en "Create"

3. **Ve a la pestaña SQL**

4. **Copia y pega el script** de `backend/create_tables.sql`
   - Solo las primeras 60 líneas (las 4 CREATE TABLE)
   - Clic en "Go" o "Ejecutar"

5. **Verifica que se crearon las 4 tablas**:
   - ✅ `projects`
   - ✅ `jobs`
   - ✅ `work_types`
   - ✅ `sync_log`

---

### 2. Actualizar Base de Datos en Configuración (si creaste "miobrafacil")

Si creaste una BD llamada `miobrafacil` en lugar de usar `root`, actualiza:

**En `backend/api.php` línea 18:**
```php
define('DB_NAME', 'miobrafacil'); // Cambia 'root' por 'miobrafacil'
```

**En `lib/config/api_config.dart` línea 70:**
```dart
static const String DB_NAME = 'miobrafacil'; // Cambia 'root' por 'miobrafacil'
```

---

### 3. Subir el Backend PHP

Ahora necesitas subir `api.php` a algún hosting. Opciones:

#### Opción A: ¿Este nuevo portal de filess.io tiene File Manager?

- Si **SÍ** → Sube `backend/api.php` ahí
- Si **NO** → Usa opción B

#### Opción B: InfinityFree (Hosting PHP Gratis)

1. **Crear cuenta:**
   - Ve a: https://www.infinityfree.com
   - Sign Up gratis
   - Elige subdominio: `miobrafacil.infinityfreeapp.com`

2. **Subir api.php:**
   - Panel → File Manager
   - Carpeta: `htdocs/`
   - Sube `backend/api.php`

3. **Tu URL será:**
   ```
   https://miobrafacil.infinityfreeapp.com/api.php
   ```

4. **Actualizar Flutter:**
   - Edita `lib/config/api_config.dart` línea 13
   - Cambia a tu URL de InfinityFree

---

## 🧪 Probar Conexión

### Desde Navegador (después de subir api.php):

```
https://tu-url.com/api.php/health
```

**Respuesta esperada:**
```json
{
  "success": true,
  "message": "Servidor funcionando correctamente",
  "timestamp": "2025-11-11 15:00:00",
  "version": "1.0.0"
}
```

---

## 📋 Archivos Actualizados

- ✅ `backend/api.php` - Credenciales nuevas
- ✅ `lib/config/api_config.dart` - Credenciales nuevas
- ✅ `backend/create_tables.sql` - Comentarios actualizados

---

## 🎯 Checklist

- [ ] Crear tablas en phpMyAdmin (ejecutar SQL)
- [ ] Verificar que las 4 tablas existen
- [ ] Decidir dónde subir `api.php` (filess.io o InfinityFree)
- [ ] Subir `api.php` al hosting elegido
- [ ] Actualizar URL en `api_config.dart` línea 13
- [ ] Probar endpoint `/health` desde navegador
- [ ] Compilar APK: `flutter build apk --release`
- [ ] Probar sincronización desde la app

---

## 📱 API Key de filess.io

Tu API Key sigue siendo la misma:
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjcxZWRmMmE3LTExOTItNGJmMS05YzdmLTA5M2IxNmJhZjU1ZSIsImlhdCI6MTc2Mjg4NTU5MywiZXhwIjozMTczMDczMjc5OTN9.vVtHWhP9l6aY5x7-tSu6SC3E3Hu-d13oQVcHmaSwYhY
```

Ya está configurada en `api_config.dart` ✅

---

## 🆘 ¿Necesitas Ayuda?

**Dime:**
1. ¿Creaste las tablas exitosamente en phpMyAdmin?
2. ¿Este nuevo portal de filess.io tiene File Manager para subir PHP?
3. ¿Prefieres usar InfinityFree para el hosting PHP?

¡Avísame y seguimos! 🚀
