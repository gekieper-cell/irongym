@echo off
title Iron Gym — Instalar como Servicio de Windows
color 0A
cd /d "%~dp0"

:: Requiere permisos de administrador
net session >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Este script necesita ejecutarse como ADMINISTRADOR.
    echo Click derecho sobre el archivo ^> "Ejecutar como administrador"
    pause
    exit
)

echo.
echo =====================================================
echo   IRON GYM — Instalacion como Servicio de Windows
echo =====================================================
echo.
echo Este proceso va a:
echo  1. Descargar NSSM (gestor de servicios)
echo  2. Instalar las dependencias Python
echo  3. Registrar Iron Gym como servicio de Windows
echo  4. Configurar reinicio automatico si se cae
echo.
echo El sistema va a arrancar SOLO cuando enciendas el servidor.
echo.
set /p CONFIRM=Escribi S para continuar: 
if /i not "%CONFIRM%"=="S" ( echo Cancelado. & pause & exit )

:: ── Paso 1: Preparar entorno Python ─────────────────────────
echo.
echo [1/5] Preparando entorno Python...
if not exist "venv\Scripts\activate.bat" (
    python -m venv venv
)
call venv\Scripts\activate.bat
python -m pip install --upgrade pip --quiet
pip install -r "%~dp0requirements.txt" --upgrade --quiet
echo      OK

:: ── Paso 2: Crear carpetas ───────────────────────────────────
echo [2/5] Creando carpetas...
if not exist "instance\" mkdir instance
if not exist "logs\" mkdir logs
echo      OK

:: ── Paso 3: Descargar NSSM ──────────────────────────────────
echo [3/5] Verificando NSSM...
if exist "nssm.exe" (
    echo      NSSM ya existe, omitiendo descarga.
) else (
    echo      Descargando NSSM...
    powershell -Command ^
      "Invoke-WebRequest -Uri 'https://nssm.cc/release/nssm-2.24.zip' -OutFile 'nssm_temp.zip'" ^
      >nul 2>&1
    if exist "nssm_temp.zip" (
        powershell -Command ^
          "Add-Type -Assembly 'System.IO.Compression.FileSystem'; ^
           $z=[IO.Compression.ZipFile]::OpenRead('nssm_temp.zip'); ^
           $entry=$z.Entries | Where-Object {$_.Name -eq 'nssm.exe' -and $_.FullName -like '*win64*'}; ^
           [IO.Compression.ZipFileExtensions]::ExtractToFile($entry,'nssm.exe',$true); ^
           $z.Dispose()" >nul 2>&1
        del nssm_temp.zip >nul 2>&1
        if exist "nssm.exe" (
            echo      NSSM descargado OK
        ) else (
            echo      No se pudo descargar automaticamente.
            echo      Descarga manual: https://nssm.cc/download
            echo      Copiá nssm.exe en: %~dp0
            pause
            exit
        )
    ) else (
        echo      Sin internet. Descarga NSSM manualmente desde:
        echo      https://nssm.cc/download  ^(nssm-2.24.zip^)
        echo      Extraé nssm.exe ^(carpeta win64^) a: %~dp0
        pause
        exit
    )
)

:: ── Paso 4: Registrar el servicio ───────────────────────────
echo [4/5] Registrando servicio de Windows...

set SVC_NAME=IronGym
set PYTHON_EXE=%~dp0venv\Scripts\python.exe
set APP_PY=%~dp0app.py
set LOG_OUT=%~dp0logs\irongym_out.log
set LOG_ERR=%~dp0logs\irongym_err.log

:: Eliminar servicio anterior si existe
nssm.exe stop %SVC_NAME% >nul 2>&1
nssm.exe remove %SVC_NAME% confirm >nul 2>&1

:: Instalar nuevo servicio
nssm.exe install %SVC_NAME% "%PYTHON_EXE%" "%APP_PY%"
nssm.exe set %SVC_NAME% AppDirectory "%~dp0"
nssm.exe set %SVC_NAME% DisplayName "Iron Gym — Sistema de Gestion"
nssm.exe set %SVC_NAME% Description "Sistema de gestion de gimnasio de boxeo Iron Gym"
nssm.exe set %SVC_NAME% AppEnvironmentExtra "IRONGYM_ENV=produccion"
nssm.exe set %SVC_NAME% AppStdout "%LOG_OUT%"
nssm.exe set %SVC_NAME% AppStderr "%LOG_ERR%"
nssm.exe set %SVC_NAME% AppStdoutCreationDisposition 4
nssm.exe set %SVC_NAME% AppStderrCreationDisposition 4
nssm.exe set %SVC_NAME% AppRotateFiles 1
nssm.exe set %SVC_NAME% AppRotateBytes 10485760
:: Reinicio automatico si se cae (esperar 5 segundos)
nssm.exe set %SVC_NAME% AppRestartDelay 5000
:: Arranque automatico con Windows
nssm.exe set %SVC_NAME% Start SERVICE_AUTO_START

echo      Servicio registrado OK

:: ── Paso 5: Iniciar el servicio ─────────────────────────────
echo [5/5] Iniciando servicio...
nssm.exe start %SVC_NAME%
timeout /t 3 /nobreak >nul

:: Verificar que arranco
sc query %SVC_NAME% | find "RUNNING" >nul
if errorlevel 1 (
    echo.
    echo [ADVERTENCIA] El servicio no esta RUNNING todavia.
    echo Revisá los logs en: logs\irongym_err.log
    echo O ejecuta: nssm.exe edit IronGym
) else (
    echo      Servicio corriendo OK
)

echo.
echo =====================================================
echo   INSTALACION COMPLETADA
echo =====================================================
echo.
echo   Acceso local:   http://127.0.0.1:5000
echo   El sistema arranca AUTOMATICAMENTE con Windows.
echo.
echo   Comandos utiles (como Administrador):
echo     Ver estado:    sc query IronGym
echo     Detener:       sc stop IronGym
echo     Arrancar:      sc start IronGym
echo     Ver logs:      logs\irongym_out.log
echo     Configurar:    nssm.exe edit IronGym
echo     Desinstalar:   nssm.exe remove IronGym confirm
echo.
pause
