@echo off
cd /d "%~dp0"
echo Creando acceso directo en el Escritorio...

powershell -Command ^
  "$ws = New-Object -ComObject WScript.Shell; ^
   $desktop = [System.Environment]::GetFolderPath('Desktop'); ^
   $sc = $ws.CreateShortcut($desktop + '\Iron Gym.lnk'); ^
   $sc.TargetPath = '%~dp0IronGym.vbs'; ^
   $sc.WorkingDirectory = '%~dp0'; ^
   $sc.Description = 'Iron Gym — Sistema de Gestion'; ^
   $sc.IconLocation = '%SystemRoot%\system32\SHELL32.dll,23'; ^
   $sc.Save()"

echo.
echo  Listo! Icono "Iron Gym" creado en el Escritorio.
echo  Doble clic abre el sistema SIN ventana negra.
echo  El navegador se abre solo en http://127.0.0.1:5000
echo.
pause
