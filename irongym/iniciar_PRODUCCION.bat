@echo off
title Iron Gym — PRODUCCION
color 0A
cd /d "%~dp0"

echo.
echo  ============================================
echo    IRON GYM — PRODUCCION
echo    Puerto: 5000
echo    DB: instance\irongym.db
echo  ============================================
echo.

if exist "venv\Scripts\activate.bat" (
    echo  Usando entorno virtual...
) else (
    echo  Creando entorno virtual...
    python -m venv venv
)

call venv\Scripts\activate.bat
python -m pip install --upgrade pip --quiet
pip install -r "%~dp0requirements.txt" --upgrade --quiet

if not exist "instance\" mkdir instance

start http://127.0.0.1:5000

echo  Iniciando servidor PRODUCCION en puerto 5000...
echo.
set IRONGYM_ENV=produccion
python app.py

pause
