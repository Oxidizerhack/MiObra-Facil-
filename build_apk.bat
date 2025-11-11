@echo off
echo ====================================
echo Construyendo APK para MiObra-Facil
echo ====================================
echo.

set FLUTTER_PATH=C:\Users\ASUS\Downloads\flutter_windows_3.24.4-stable\flutter\bin

echo [1/4] Verificando Flutter...
"%FLUTTER_PATH%\flutter.bat" --version
echo.

echo [2/4] Instalando dependencias...
"%FLUTTER_PATH%\flutter.bat" pub get
echo.

echo [3/4] Limpiando proyecto...
"%FLUTTER_PATH%\flutter.bat" clean
echo.

echo [4/4] Construyendo APK de release...
"%FLUTTER_PATH%\flutter.bat" build apk --release
echo.

echo ====================================
echo APK generado en:
echo build\app\outputs\flutter-apk\app-release.apk
echo ====================================
pause
