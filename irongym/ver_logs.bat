@echo off
cd /d "%~dp0"
echo === ULTIMAS 50 LINEAS — LOG PRINCIPAL ===
echo.
if exist "logs\irongym_out.log" (
    powershell -Command "Get-Content logs\irongym_out.log -Tail 50"
) else (
    echo No hay logs todavia. El servicio nunca arranco?
)
echo.
echo === ERRORES ===
echo.
if exist "logs\irongym_err.log" (
    powershell -Command "Get-Content logs\irongym_err.log -Tail 30"
) else (
    echo Sin errores registrados.
)
pause
