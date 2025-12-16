@echo off
title Minecraft Server - CIERRE y Sincronizacion
color 0C
chcp 65001 >nul

echo ========================================
echo    CIERRE y SINCRONIZACION CON GIT
echo ========================================
echo.
echo Este script:
echo 1. Supone que YA has escrito 'stop' en el servidor.
echo 2. Añade TODOS los cambios respetando .gitignore.
echo 3. Sube solo lo que .gitignore permite (ej: carpeta world).
echo.
pause

REM --- Pequena pausa para asegurar cierre ---
echo Esperando 5 segundos para que el mundo se guarde completamente...
timeout /t 5 >nul

echo.
echo [1/4] Comprobando el estado de Git...
git status --short
if %errorlevel% neq 0 (
    echo ❌ ERROR: No se pudo comprobar el estado de Git.
    pause
    exit /b 1
)

echo [2/4] Añadiendo TODOS los cambios (respetando .gitignore)...
git add .
if %errorlevel% neq 0 (
    echo ❌ ERROR: No se pudo añadir los cambios.
    pause
    exit /b 1
)

REM --- Verificar si hay algo que commitear ---
echo [3/4] Verificando si hay cambios para guardar...
git diff --staged --quiet
if %errorlevel% equ 0 (
    echo ℹ  No hay cambios que guardar. Saliendo...
    timeout /t 2
    exit /b 0
)

echo    Creando commit con la fecha y hora...
set "fecha_actual=%date:~-4%-%date:~-7,2%-%date:~-10,2%"
set "hora_actual=%time:~0,2%:%time:~3,2%"
git commit -m "Server Backup: %fecha_actual% %hora_actual%" --no-verify

echo [4/4] Subiendo cambios al repositorio remoto...
git push origin master
if %errorlevel% neq 0 (
    echo ⚠  Advertencia: No se pudo subir los cambios.
    echo    Es posible que necesites hacer 'git pull' primero.
    pause
    exit /b 1
)

echo.
echo ========================================
echo    ✅ SINCRONIZACION COMPLETADA
echo ========================================
echo    Se han subido los cambios respetando .gitignore.
echo    Fecha: %fecha_actual% %hora_actual%
echo ========================================
echo.
pause