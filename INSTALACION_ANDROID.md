# 📱 Instalación de MiObra-Fácil en Android

## 🎯 Ubicación del APK

Una vez completada la compilación, encontrarás el APK en:

```
build/app/outputs/flutter-apk/app-release.apk
```

## 📥 Cómo instalar en tu celular Android

### Opción 1: USB (Recomendada)

1. **Conecta tu celular** a la PC con un cable USB
2. **Copia el APK** a la memoria del celular
3. En tu celular, abre el **Administrador de archivos**
4. Busca el archivo `app-release.apk`
5. Toca el archivo para instalarlo
6. Si aparece "Fuente desconocida", activa la instalación desde fuentes desconocidas

### Opción 2: Transferencia por correo/Drive

1. Sube el APK a Google Drive o envíalo por correo
2. Descárgalo desde tu celular
3. Abre el archivo descargado
4. Permite la instalación

### Opción 3: ADB (Para desarrolladores)

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

## ⚙️ Configuración de seguridad

Si es la primera vez que instalas una app fuera de Play Store:

1. Ve a **Configuración** → **Seguridad**
2. Activa **"Orígenes desconocidos"** o **"Instalar apps desconocidas"**
3. Selecciona el navegador o administrador de archivos
4. Activa el permiso

## 🚀 Primera ejecución

Al abrir la app por primera vez:

1. Acepta los permisos necesarios
2. Empieza a crear tus presupuestos de construcción
3. Exporta a PDF cuando necesites

## 📊 Características de la App

- ✅ Gestión de proyectos de construcción
- ✅ Calculadora de materiales
- ✅ Catálogo de trabajos
- ✅ Exportación a PDF
- ✅ Soporte de regiones

## 🔄 Actualizaciones futuras

Para actualizar la app:

1. Genera un nuevo APK con el script `build_apk.bat`
2. Instala sobre la versión anterior (conservará tus datos)

---

**¡Disfruta de MiObra-Fácil!** 🏗️💰
