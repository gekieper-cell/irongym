# 🥊 IRON GYM — Sistema de Gestión de Boxeo
## Guía de instalación y uso — Windows

---

## REQUISITOS

- Windows 10 / 11
- Python 3.10 o superior → https://www.python.org/downloads/
  ⚠️ Al instalar Python, marcá la opción **"Add Python to PATH"**

---

## INSTALACIÓN (primera vez)

1. Descomprimí el ZIP en una carpeta (ej: `C:\IronGym\`)
2. Hacé doble clic en **`iniciar.bat`**
3. Esperá que se instalen las dependencias (solo la primera vez)
4. El sistema se abre automáticamente en tu navegador

---

## USO DIARIO

- Hacé doble clic en **`iniciar.bat`**
- Abrí tu navegador en **http://127.0.0.1:5000**
- Desde otros dispositivos en la misma red Wi-Fi, usá la IP que muestra la consola

---

## USUARIOS PREDETERMINADOS

| Usuario      | Contraseña | Acceso                |
|--------------|------------|-----------------------|
| `admin`      | `admin123` | Todo el sistema       |
| `operador`   | `op123`    | Ventas y asistencia   |

**Clave maestra (recuperación):** `IRONGYM2024`

---

## MÓDULOS

| Módulo         | Descripción                                        |
|----------------|----------------------------------------------------|
| Dashboard      | Estadísticas, gráficos e indicadores clave         |
| Asistencia     | Escáner QR + teclado por últimos 3 del DNI         |
| Alumnos        | Alta, edición, QR individual, estado               |
| Morosos        | Lista automática, WhatsApp directo, email masivo   |
| Clases         | Horario semanal y administración de clases         |
| Ventas         | PdV con carrito, stock, tickets imprimibles        |
| Productos      | Equipamiento, bebidas, rehidratantes, stock        |
| Gastos         | Control de gastos internos por categoría           |
| Reportes       | Resúmenes mensuales y exportación CSV              |
| Google Drive   | Exportación CSV para conectar con Looker Studio    |
| Configuración  | Datos del gym, contraseñas, planes, email SMTP     |

---

## ACCESO DESDE CELULAR (Red Local)

1. Iniciá el servidor con `iniciar.bat`
2. En la consola verás la IP local, ej: `http://192.168.1.10:5000`
3. Abrí esa URL desde cualquier dispositivo en la misma red Wi-Fi
4. Funciona como app web en el navegador del celular

---

## EXPORTAR A LOOKER STUDIO

1. Ir a **Reportes** o **Google Drive** → exportar CSVs
2. Subir los archivos CSV a Google Drive
3. Abrir https://lookerstudio.google.com
4. Nuevo Reporte → Agregar datos → Google Sheets o File Upload
5. Conectar el CSV y crear dashboards personalizados

---

## CONFIGURAR EMAIL (para notificaciones a morosos)

1. Ir a **Configuración → Email SMTP**
2. Para Gmail:
   - Servidor: `smtp.gmail.com`
   - Puerto: `587`
   - Email: tu cuenta de Gmail
   - Contraseña: generar una **App Password** en myaccount.google.com
3. Guardar y probar desde el módulo Morosos

---

## DATOS Y BACKUP

- La base de datos se guarda en `instance/irongym.db`
- Para hacer backup: copiar ese archivo
- Para restaurar: reemplazar ese archivo (con el servidor apagado)

---

## SEGURIDAD

- Cambiar las contraseñas predeterminadas en **Configuración**
- La clave maestra permite recuperar la contraseña de admin
- El operador no tiene acceso a Gastos, Reportes ni Configuración

---

## SOPORTE

Sistema desarrollado con Python + Flask + SQLite.
Versión 1.0 — Iron Gym Boxing Management System


══════════════════════════════════════════════════
CÓMO ACTUALIZAR SIN PERDER LA BASE DE DATOS
══════════════════════════════════════════════════

ESTRUCTURA IMPORTANTE:
  irongym/
  ├── app.py              ← código (se actualiza)
  ├── templates/          ← código (se actualiza)
  ├── requirements.txt    ← dependencias (se actualiza)
  ├── instance/
  │   └── irongym.db      ← BASE DE DATOS (NUNCA se toca)
  └── venv/               ← entorno Python (NUNCA se toca)

PASOS PARA ACTUALIZAR:
  1. Recibís un archivo update_X.X.zip de parte del desarrollador
  2. Arrastrás ese archivo SOBRE el ícono "actualizar.bat"
     (o ejecutás: actualizar.bat update_X.X.zip)
  3. El script:
     - Hace backup automático de tu irongym.db
     - Reemplaza solo app.py y templates/
     - Nunca toca instance/ ni venv/
     - Aplica migraciones de base de datos automáticamente
  4. Ejecutás iniciar.bat normalmente

HACER BACKUP MANUAL:
  - Doble clic en "hacer_backup.bat"
  - Los backups se guardan en la carpeta "backups/"
  - Para restaurar: copiar el .db a instance/irongym.db
    (con el servidor apagado)

VERSIÓN ACTUAL:
  - Se muestra en la parte inferior del menú lateral del sistema
