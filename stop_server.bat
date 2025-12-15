@echo off
title Minecraft Server 1.21.1 - CIERRE y BACKUP
color 0C
chcp 65001 >nul

echo ========================================
echo    CIERRE DEL SERVIDOR y BACKUP
echo ========================================
echo.

echo ⚠  Este script:
echo    1. Supone que YA has escrito 'stop' en el servidor.
echo    2. Hace backup SOLO de la carpeta 'world' en Git.
echo.

REM --- Pequena pausa para asegurar cierre ---
echo Esperando 5 segundos para que el mundo se guarde completamente...
timeout /t 5 >nul

REM --- Backup SELECTIVO: Solo el mundo ---
echo.
echo [1/3] Preparando backup del MUNDO para Git...
git add world/
if %errorlevel% neq 0 (
    echo ❌ ERROR: No se pudo agregar la carpeta 'world' al commit.
    echo    Verifica que la carpeta existe y Git esta inicializado.
    pause
    exit /b 1
)

echo [2/3] Creando commit con la fecha y hora...
set "fecha_actual=%date:~-4%-%date:~-7,2%-%date:~-10,2%"
set "hora_actual=%time:~0,2%:%time:~3,2%"
git commit -m "BACKUP MUNDO: %fecha_actual% %hora_actual%" --no-verify

echo [3/3] Subiendo cambios al repositorio remoto (GitHub/GitLab)...
git push

echo.
echo ========================================
echo    ✅ BACKUP COMPLETADO
echo ========================================
echo    Se ha subido SOLO la carpeta 'world'.
echo    Fecha: %fecha_actual% %hora_actual%
echo ========================================
echo.
pause