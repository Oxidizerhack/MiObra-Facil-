# Backend API - Mi Obra Fácil

API REST en PHP para conectar Flutter con MySQL (filess.io).

## 🚀 Deploy en Render

Este backend está configurado para desplegarse automáticamente en Render usando Docker.

### Credenciales MySQL (filess.io)
- **Host:** y27ad9.h.filess.io:3306
- **Database:** miobrafacildb_cityvastbe
- **User:** miobrafacildb_cityvastbe

### Endpoints disponibles

- `GET /api.php/health` - Verificar estado del servidor
- `GET /api.php/projects` - Obtener todos los proyectos
- `POST /api.php/projects` - Crear nuevo proyecto
- `PUT /api.php/projects/{id}` - Actualizar proyecto
- `DELETE /api.php/projects/{id}` - Eliminar proyecto
- `POST /api.php/sync` - Sincronización completa

## 🛠 Archivos importantes

- `api.php` - Archivo principal del backend
- `Dockerfile` - Configuración de Docker para Render
- `render.yaml` - Configuración de Render
- `composer.json` - Dependencias PHP

## 📦 Requisitos

- PHP 8.2+
- Extensiones: pdo, pdo_mysql
