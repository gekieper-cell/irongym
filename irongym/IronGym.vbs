' Lanza iniciar_PRODUCCION.bat sin mostrar ventana negra
Set oShell = CreateObject("WScript.Shell")
oShell.Run """" & Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName,"\")) & "iniciar_PRODUCCION.bat""", 0, False
