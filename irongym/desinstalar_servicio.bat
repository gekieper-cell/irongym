@echo off
title Iron Gym — Desinstalar Servicio
color 0C
cd /d "%~dp0"

net session >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Ejecutar como ADMINISTRADOR.
    pause & exit
)

echo Deteniendo y eliminando servicio IronGym...
nssm.exe stop IronGym >nul 2>&1
nssm.exe remove IronGym confirm
echo.
echo Servicio eliminado. El sistema ya no arranca automaticamente.
echo Podés seguir usándolo con iniciar_PRODUCCION.bat
pause
