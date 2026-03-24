@echo off
title Iron Gym — Reparar Entorno
color 0E
cd /d "%~dp0"

echo.
echo  Eliminando entorno virtual y reinstalando...
echo.

if exist "venv\" (
    rmdir /s /q venv
    echo  Entorno anterior eliminado.
)

python -m venv venv
call venv\Scripts\activate.bat
python -m pip install --upgrade pip
pip install -r "%~dp0requirements.txt"

echo.
echo  Listo. Ahora ejecuta iniciar.bat
pause
