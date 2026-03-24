@echo off
title Iron Gym — Actualizador
color 0B
cd /d "%~dp0"

echo.
echo =====================================================
echo   IRON GYM — Actualizador del Sistema
echo =====================================================
echo.

if "%1"=="" (
    echo  USO: Arrastrar archivo update_X.X.zip sobre este .bat
    echo.
    echo  El actualizador NUNCA modifica:
    echo    - instance\irongym.db     (base de datos produccion)
    echo    - instance_test\          (base de datos test)
    echo    - venv\                   (entorno Python)
    echo.
    pause & exit
)

set UPDATE_FILE=%1
if not exist "%UPDATE_FILE%" (
    echo [ERROR] No se encontro: %UPDATE_FILE%
    pause & exit
)

:: ── Backup automatico ────────────────────────────────────────
echo [1/5] Haciendo backup de la base de datos...
if exist "instance\irongym.db" (
    if not exist "backups\" mkdir backups
    for /f "tokens=2-4 delims=/ " %%a in ('date /t') do set HOY=%%c%%b%%a
    for /f "tokens=1-2 delims=:. " %%a in ('time /t') do set HH=%%a%%b
    copy "instance\irongym.db" "backups\irongym_%HOY%_%HH%.db" >nul
    echo      Backup: backups\irongym_%HOY%_%HH%.db
) else (
    echo      Sin DB de produccion, omitiendo.
)

:: ── Detener servicio si existe ───────────────────────────────
echo [2/5] Deteniendo servicio (si existe)...
sc query IronGym >nul 2>&1
if not errorlevel 1 (
    sc stop IronGym >nul 2>&1
    timeout /t 3 /nobreak >nul
    echo      Servicio detenido.
) else (
    echo      Servicio no instalado, continuando.
)

:: ── Extraer update ───────────────────────────────────────────
echo [3/5] Extrayendo archivos de actualizacion...
if exist "temp_update\" rmdir /s /q temp_update
mkdir temp_update
powershell -Command "Expand-Archive -Path '%UPDATE_FILE%' -DestinationPath 'temp_update' -Force" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] No se pudo descomprimir.
    rmdir /s /q temp_update 2>nul & pause & exit
)

:: ── Copiar solo codigo (nunca instance/ ni venv/) ────────────
echo [4/5] Aplicando actualizacion...
for /r "temp_update" %%f in (app.py) do (
    copy /y "%%f" "%~dp0app.py" >nul
    echo      app.py actualizado
)
for /r "temp_update" %%d in (.) do (
    if exist "%%d\login.html"  ( copy /y "%%d\login.html"  "%~dp0templates\login.html"  >nul & echo      login.html actualizado )
    if exist "%%d\index.html"  ( copy /y "%%d\index.html"  "%~dp0templates\index.html"  >nul & echo      index.html actualizado )
)
for /r "temp_update" %%f in (requirements.txt) do (
    copy /y "%%f" "%~dp0requirements.txt" >nul
    echo      requirements.txt actualizado
)
rmdir /s /q temp_update 2>nul

:: ── Actualizar dependencias ──────────────────────────────────
call venv\Scripts\activate.bat
pip install -r "%~dp0requirements.txt" --upgrade --quiet

:: ── Reiniciar servicio si estaba instalado ───────────────────
echo [5/5] Reiniciando servicio...
sc query IronGym >nul 2>&1
if not errorlevel 1 (
    sc start IronGym >nul 2>&1
    timeout /t 3 /nobreak >nul
    sc query IronGym | find "RUNNING" >nul
    if errorlevel 1 ( echo      ADVERTENCIA: servicio no arranco, revisa logs\ ) else ( echo      Servicio reiniciado OK )
) else (
    echo      Servicio no instalado. Usa iniciar_PRODUCCION.bat para arrancar.
)

echo.
echo =====================================================
echo   Actualizacion completada. DB intacta.
echo =====================================================
echo.
pause
