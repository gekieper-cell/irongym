@echo off
title Iron Gym — Backup
color 0A
cd /d "%~dp0"

echo.
echo  Generando backup completo...
echo.

if not exist "instance\irongym.db" (
    echo  [!] No se encontro la base de datos. El sistema nunca fue iniciado?
    pause
    exit
)

:: Crear carpeta backups si no existe
if not exist "backups\" mkdir backups

:: Nombre con fecha y hora
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do set FECHA=%%c%%b%%a
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set HORA=%%a%%b

set NOMBRE=backups\irongym_%FECHA%_%HORA%.db
copy "instance\irongym.db" "%NOMBRE%" >nul

echo  Backup guardado en: %NOMBRE%
echo.
echo  Para restaurar: copiar ese archivo a instance\irongym.db
echo  (con el servidor apagado)
echo.
pause
