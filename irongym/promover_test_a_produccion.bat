@echo off
title Iron Gym — Promover Test a Produccion
color 0C
cd /d "%~dp0"

echo.
echo  ============================================
echo    PROMOVER TEST A PRODUCCION
echo  ============================================
echo.
echo  ATENCION: Esto reemplazara la base de datos
echo  de PRODUCCION con la de TEST.
echo.
echo  Usa esto SOLO si hiciste pruebas en TEST
echo  y queres llevar esa data a produccion.
echo  (caso raro — normalmente NO se hace esto)
echo.

if not exist "instance_test\irongym_test.db" (
    echo  [ERROR] No existe base de datos de TEST todavia.
    pause
    exit
)

set /p CONFIRM=Escribi CONFIRMAR para continuar: 
if /i not "%CONFIRM%"=="CONFIRMAR" (
    echo  Operacion cancelada.
    pause
    exit
)

:: Backup produccion primero
if exist "instance\irongym.db" (
    for /f "tokens=2-4 delims=/ " %%a in ('date /t') do set HOY=%%c%%b%%a
    copy "instance\irongym.db" "instance\irongym_antes_promo_%HOY%.db" >nul
    echo  Backup de produccion guardado.
)

if not exist "instance\" mkdir instance
copy "instance_test\irongym_test.db" "instance\irongym.db" >nul
echo.
echo  Listo. La DB de test fue copiada a produccion.
echo  Ejecuta iniciar_PRODUCCION.bat para arrancar.
echo.
pause
