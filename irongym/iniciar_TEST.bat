@echo off
title Iron Gym — ENTORNO TEST
color 0E
cd /d "%~dp0"

echo.
echo  ============================================
echo    IRON GYM — ENTORNO DE TEST
echo    Puerto: 5001
echo    DB: instance_test\irongym_test.db
echo  ============================================
echo.
echo  Este entorno NO afecta los datos de produccion.
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

if not exist "instance_test\" mkdir instance_test

start http://127.0.0.1:5001

echo  Iniciando servidor TEST en puerto 5001...
echo.
set IRONGYM_ENV=test
python app.py

pause
