@echo off
title Minecraft Server 1.21.1 - INICIO
color 0A
chcp 65001 >nul

echo ========================================
echo    MINECRAFT SERVER 1.21.1
echo ========================================
echo.

REM --- Obtener IP ---
echo Obteniendo IP del servidor...
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4" ^| head -1') do (
    for /f "tokens=*" %%b in ("%%a") do set "SERVER_IP=%%b"
)
if not defined SERVER_IP set "SERVER_IP=localhost"

echo.
echo 📍 IP Local: %SERVER_IP%:25565
echo.

REM --- Sincronizar configuraciones desde Git (pero NO mods) ---
echo [1/3] Sincronizando configuraciones del servidor...
git pull orgin master --no-rebase
if %errorlevel% neq 0 (
    echo ⚠  Advertencia: Hubo un problema al sincronizar con Git.
    echo    Continuando con los archivos locales...
)

REM --- Verificar archivos criticos ---
echo [2/3] Verificando archivos del servidor...
if not exist fabric-server-launch.jar (
    echo ❌ ERROR: No se encuentra el archivo principal del servidor.
    pause
    exit /b 1
)
if not exist eula.txt echo eula=true > eula.txt

REM --- Iniciar servidor ---
echo [3/3] Iniciando servidor...
echo ========================================
echo    Servidor en linea. Para detenerlo:
echo    Escribe 'stop' en esta consola.
echo ========================================
echo.
java -Xmx4G -Xms2G -jar fabric-server-launch.jar nogui

echo.
echo ========================================
echo    Servidor detenido por el usuario.
echo ========================================
pause