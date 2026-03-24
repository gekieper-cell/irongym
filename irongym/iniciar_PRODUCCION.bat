@echo off
cd /d "%~dp0"

if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat
) else (
    python -m venv venv
    call venv\Scripts\activate.bat
    python -m pip install --upgrade pip --quiet
    pip install -r "%~dp0requirements.txt" --quiet
)

if not exist "instance\" mkdir instance

:: Abrir navegador luego de 3 segundos (tiempo para que Flask arranque)
start /b "" cmd /c "timeout /t 3 /nobreak >nul & start http://127.0.0.1:5000"

set IRONGYM_ENV=produccion
python "%~dp0app.py"
