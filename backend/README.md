# 🚀 Backend PHP para Mi Obra Fácil

## 📋 Descripción

Este es el backend API REST que conecta tu app Flutter con la base de datos MySQL en filess.io.

## 📂 Estructura

```
backend/
  ├── api.php          ← Archivo principal del API
  ├── README.md        ← Este archivo
  └── .htaccess        ← Configuración de Apache (opcional)
```

## 🔧 Instalación

### Opción 1: Usar filess.io (Recomendado)

1. **Sube el archivo `api.php` a filess.io**:
   - Accede al File Manager de filess.io
   - Navega a la carpeta `public_html` o `www`
   - Sube el archivo `api.php`

2. **Actualiza las credenciales**:
   - Edita `api.php` líneas 15-19
   - Reemplaza con tus credenciales reales de filess.io

3. **Obtén la URL del API**:
   - Tu URL será algo como: `https://tu-usuario.filess.io/api.php`
   - O si tienes dominio: `https://tu-dominio.com/api.php`

4. **Actualiza Flutter**:
   - Edita `lib/config/api_config.dart`
   - Cambia `CLOUD_API` por tu URL real

### Opción 2: XAMPP Local (Solo desarrollo)

1. **Instala XAMPP**:
   - Descarga desde: https://www.apachefriends.org/
   - Instala en `C:\xampp`

2. **Copia el archivo**:
   ```
   C:\xampp\htdocs\miobrafacil\api.php
   ```

3. **Actualiza credenciales**:
   - Host: `localhost`
   - Port: `3306`
   - Database: `miobrafacil_db`
   - User: `root`
   - Password: `` (vacío por defecto)

4. **Inicia servicios**:
   - Abre XAMPP Control Panel
   - Start Apache
   - Start MySQL

5. **Prueba la conexión**:
   - Abre navegador: `http://localhost/miobrafacil/api.php/health`
   - Deberías ver: `{"success":true,"message":"Servidor funcionando correctamente"}`

## 🧪 Probar Endpoints

### 1. Health Check
```bash
GET http://tu-url.com/api.php/health
```

**Respuesta esperada:**
```json
{
  "success": true,
  "message": "Servidor funcionando correctamente",
  "timestamp": "2025-11-11 10:30:00",
  "version": "1.0.0"
}
```

### 2. Obtener todos los proyectos
```bash
GET http://tu-url.com/api.php/projects
```

### 3. Crear proyecto
```bash
POST http://tu-url.com/api.php/projects
Content-Type: application/json

{
  "id": "abc123",
  "name": "Proyecto Test",
  "client": "Juan Pérez",
  "location": "La Paz",
  "region": "laPaz",
  "created_at": "2025-11-11T10:30:00Z",
  "jobs": []
}
```

## 🔒 Seguridad

### ⚠️ IMPORTANTE: Antes de producción

1. **No expongas credenciales**:
   - Usa variables de entorno
   - Archivo `.env` con permisos restringidos

2. **Autenticación**:
   - Implementa JWT tokens
   - API Keys por usuario

3. **Validación**:
   - Sanitiza todos los inputs
   - Valida tipos de datos

4. **HTTPS**:
   - Siempre usa SSL en producción
   - filess.io incluye SSL gratis

## 📊 Estructura de Respuestas

### Respuesta Exitosa
```json
{
  "success": true,
  "data": [...],
  "count": 10
}
```

### Respuesta de Error
```json
{
  "success": false,
  "error": "Mensaje descriptivo del error"
}
```

## 🛠️ Troubleshooting

### Error: "Connection refused"
- Verifica que Apache esté corriendo
- Verifica credenciales de MySQL
- Verifica que el puerto 3307 esté abierto

### Error: "CORS policy"
- Ya está configurado en líneas 21-23
- Si persiste, verifica configuración del hosting

### Error: "404 Not Found"
- Verifica que la URL sea correcta
- Verifica que el archivo esté en la carpeta correcta
- Crea archivo `.htaccess` si es necesario

### Error: "500 Internal Server Error"
- Activa display_errors en PHP para ver detalles
- Revisa logs de Apache: `C:\xampp\apache\logs\error.log`
- Verifica sintaxis del código PHP

## 📝 .htaccess (Opcional)

Si tu servidor requiere `.htaccess`, crea este archivo en la misma carpeta:

```apache
# Reescritura de URLs (opcional)
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^(.*)$ api.php/$1 [QSA,L]
</IfModule>

# Permisos CORS
Header set Access-Control-Allow-Origin "*"
Header set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
Header set Access-Control-Allow-Headers "Content-Type"
```

## 🎯 Próximos Pasos

1. ✅ Configurar credenciales de filess.io
2. ✅ Subir `api.php` al hosting
3. ✅ Probar endpoint `/health`
4. ✅ Actualizar Flutter con URL real
5. ⏳ Probar sincronización desde la app
6. ⏳ Implementar autenticación (futuro)
7. ⏳ Agregar más endpoints según necesidad

## 📚 Recursos

- **Documentación filess.io**: https://filess.io/docs
- **PHP PDO Tutorial**: https://www.php.net/manual/es/book.pdo.php
- **REST API Best Practices**: https://restfulapi.net/

---

¿Preguntas? Revisa la `GUIA_FILESSIO_MYSQL.md` para más detalles! 🚀
