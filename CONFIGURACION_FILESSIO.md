# 🔑 Configuración de filess.io - Mi Obra Fácil

## ✅ Estado: CONFIGURADO

### 📝 Información de tu Cuenta

**API Key (Bearer Token):**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjcxZWRmMmE3LTExOTItNGJmMS05YzdmLTA5M2IxNmJhZjU1ZSIsImlhdCI6MTc2Mjg4NTU5MywiZXhwIjozMTczMDczMjc5OTN9.vVtHWhP9l6aY5x7-tSu6SC3E3Hu-d13oQVcHmaSwYhY
```

**URL Base del API:**
```
https://miobrafacil.filess.io/api
```

**Base de Datos:**
- Host: `miobrafacil.filess.io`
- Port: `3307`
- Database: `miobrafacil_db`
- User: `miobrafacil_admin` (verifica tu usuario real)

---

## 📊 Tablas Creadas en filess.io

✅ **projects** - Proyectos de construcción
✅ **jobs** - Trabajos/items de cada proyecto
✅ **work_types** - Catálogo de tipos de trabajo
✅ **sync_log** - Registro de sincronizaciones

---

## 🚀 Cómo Usar la API de filess.io

### Opción 1: Usar la API REST de filess.io directamente

Si filess.io ya provee una API REST automática para tus tablas, puedes usarla directamente desde Flutter.

**Endpoints típicos de filess.io:**

```
GET    https://miobrafacil.filess.io/api/projects
POST   https://miobrafacil.filess.io/api/projects
GET    https://miobrafacil.filess.io/api/projects/{id}
PUT    https://miobrafacil.filess.io/api/projects/{id}
DELETE https://miobrafacil.filess.io/api/projects/{id}
```

**Headers requeridos:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
```

### Opción 2: Crear backend PHP personalizado

Si necesitas lógica custom, puedes:

1. Subir `backend/api.php` al hosting de filess.io
2. Configurar credenciales MySQL en `api.php`
3. Usar ese backend como intermediario

---

## 🧪 Probar la Conexión

### Desde Flutter (App)

1. Abre **Mi Obra Fácil**
2. Ve al **Dashboard**
3. Presiona el ícono de **nube** ☁️ (Sincronización)
4. Presiona **"Probar Conexión al Servidor"**

Si todo está bien:
```
✅ Servidor respondiendo correctamente
```

### Desde Navegador

Abre esta URL:
```
https://miobrafacil.filess.io/api/health
```

**Respuesta esperada:**
```json
{
  "success": true,
  "message": "Servidor funcionando correctamente"
}
```

### Desde Postman/Insomnia

**Request:**
```
GET https://miobrafacil.filess.io/api/projects
Headers:
  Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjcxZWRmMmE3LTExOTItNGJmMS05YzdmLTA5M2IxNmJhZjU1ZSIsImlhdCI6MTc2Mjg4NTU5MywiZXhwIjozMTczMDczMjc5OTN9.vVtHWhP9l6aY5x7-tSu6SC3E3Hu-d13oQVcHmaSwYhY
  Content-Type: application/json
```

---

## 📱 Configuración en Flutter

### Archivo: `lib/config/api_config.dart`

**Ya está configurado con:**

✅ URL del API: `https://miobrafacil.filess.io/api`
✅ API Key en headers automáticamente
✅ Modo producción activado por defecto

**No necesitas cambiar nada en el código Flutter**, solo:

1. Verifica que tu **password de MySQL** esté correcto en línea 73
2. Compila la app
3. Prueba la sincronización

---

## 🔐 Seguridad de la API Key

### ⚠️ IMPORTANTE

Tu API Key es **sensible** y tiene fecha de expiración:

```
Expira: 3173073279930 (timestamp)
Equivale a: Año 2070 aproximadamente
```

### Recomendaciones:

1. **NO subas esta API key a GitHub público**
   - Ya está en el código por ahora
   - Para producción, usa variables de entorno

2. **Regenera la key si la compartes accidentalmente**
   - Ve a filess.io → API Settings → Regenerate Key

3. **Para desarrollo local**
   - Puedes dejarla en `api_config.dart`
   - Git ignore este archivo si es necesario

---

## 📋 Formato de Datos para Sincronización

### Crear Proyecto (POST)

```json
{
  "id": "abc123",
  "name": "Casa Familiar",
  "client": "Juan Pérez",
  "location": "La Paz",
  "region": "laPaz",
  "created_at": "2025-11-11T10:30:00Z",
  "device_id": "android_device_001",
  "jobs": [
    {
      "id": "job001",
      "project_id": "abc123",
      "work_type_id": "og_replanteo",
      "work_type_name": "Replanteo y Trazado",
      "quantity": 100.5,
      "unit_price": 12.50,
      "total": 1256.25,
      "unit": "m²"
    }
  ]
}
```

### Respuesta Esperada

```json
{
  "success": true,
  "message": "Proyecto creado exitosamente",
  "id": "abc123"
}
```

---

## 🛠️ Troubleshooting

### Error: 401 Unauthorized

**Causa:** API Key incorrecta o expirada

**Solución:**
1. Verifica que la API key en `api_config.dart` sea correcta
2. Regenera la key en filess.io si es necesario

### Error: 404 Not Found

**Causa:** URL del endpoint incorrecta

**Solución:**
1. Verifica que la URL sea: `https://miobrafacil.filess.io/api`
2. Confirma que las tablas existan en filess.io
3. Revisa la documentación de filess.io para endpoints exactos

### Error: 500 Internal Server Error

**Causa:** Error en el servidor o base de datos

**Solución:**
1. Revisa logs en filess.io → Dashboard → Logs
2. Verifica que las tablas tengan las columnas correctas
3. Confirma que el formato JSON sea válido

### Error: CORS Policy

**Causa:** Restricciones de CORS en filess.io

**Solución:**
1. Configura CORS en filess.io Dashboard
2. Permite origen: `*` (para desarrollo)
3. Para producción: especifica tu dominio

---

## 📚 Documentación de filess.io

**Portal:** https://filess.io/docs

**Secciones importantes:**
- API Reference
- Authentication
- Database Management
- CORS Configuration

---

## ✅ Checklist de Configuración

- [x] Cuenta creada en filess.io
- [x] Base de datos MySQL creada
- [x] 4 tablas creadas (projects, jobs, work_types, sync_log)
- [x] API Key obtenida
- [x] URL del API configurada en Flutter
- [x] Headers con Authorization configurados
- [ ] **Probar conexión desde la app**
- [ ] **Sincronizar primer proyecto**
- [ ] **Verificar datos en phpMyAdmin**

---

## 🎯 Próximos Pasos

1. **Compila la app** con la nueva configuración:
   ```powershell
   flutter build apk --release
   ```

2. **Instala el APK** en tu dispositivo

3. **Prueba la sincronización**:
   - Crea un proyecto
   - Ve a Dashboard → Sincronización
   - Presiona "Sincronizar Ahora"

4. **Verifica en filess.io**:
   - Abre phpMyAdmin
   - Tabla `projects` debe tener datos

5. **Para la presentación**:
   - Muestra la tabla en phpMyAdmin
   - Demuestra sincronización en vivo
   - Explica arquitectura híbrida

---

¡Todo listo para sincronizar! 🚀
