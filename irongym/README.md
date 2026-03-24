# 🥊 Iron Gym — Sistema de Gestión de Gimnasio de Boxeo

Sistema web de gestión integral para gimnasios de boxeo. Corre localmente en Windows, accesible desde cualquier dispositivo en la red local.

## Stack

- **Backend:** Python + Flask + SQLite (WAL mode)
- **Servidor producción:** Waitress (8 threads)
- **Frontend:** HTML5 + CSS3 + JavaScript vanilla
- **Gráficos:** Chart.js
- **QR:** qrcode (SVG puro, sin Pillow)

## Funcionalidades

- 📊 Dashboard con gráficos en tiempo real
- ✅ Asistencia por QR o últimos 3 dígitos del DNI
- 🥊 Alta, edición y seguimiento de alumnos
- 🔔 Control automático de morosos con notificación WhatsApp y email
- 📅 Horario semanal de clases
- 💰 Punto de venta con carrito y control de stock
- 📉 Control de gastos internos
- 📈 Reportes y exportación CSV para Looker Studio
- 📥 Importación masiva de alumnos y productos desde Excel
- 🎨 Fondo configurable (color o imagen)
- 📱 Diseño responsivo — funciona en celular
- ☁️ Exportación para Google Drive / Looker Studio
- 👥 Dos roles: Administrador y Operador

## Requisitos

- Windows 10 / 11
- Python 3.10 o superior
- Al instalar Python: marcar **"Add Python to PATH"**

## Instalación

```bash
# 1. Clonar o descargar el repositorio
git clone https://github.com/tu-usuario/irongym.git
cd irongym

# 2. Doble clic en iniciar_PRODUCCION.bat
#    (crea el venv e instala dependencias automáticamente)
```

O simplemente doble clic en `iniciar_PRODUCCION.bat`.

## Acceso

| URL | Descripción |
|-----|-------------|
| http://127.0.0.1:5000 | Acceso local |
| http://[IP-LAN]:5000 | Acceso desde celular en la misma red |

## Usuarios por defecto

| Usuario | Contraseña | Rol |
|---------|-----------|-----|
| `admin` | `admin123` | Administrador |
| `operador` | `op123` | Operador |
| Clave maestra | `IRONGYM2024` | Recuperación |

> ⚠️ Cambiar las contraseñas por defecto antes de usar en producción.

## Estructura

```
irongym/
├── app.py                    ← Backend Flask
├── requirements.txt          ← Dependencias
├── templates/
│   ├── index.html            ← Frontend SPA
│   └── login.html
├── instance/                 ← Base de datos (git-ignored)
├── iniciar_PRODUCCION.bat    ← Arrancar producción
├── iniciar_TEST.bat          ← Arrancar entorno test
└── actualizar.bat            ← Aplicar updates
```

## Actualizar

Recibís un archivo `update_X.X.zip` con el nuevo código:

```
1. Doble clic en actualizar.bat
2. Ingresar la ruta completa del ZIP cuando lo pida
3. El script hace backup de la DB y aplica los cambios
```

## Dependencias Python

```
Flask==3.1.0
Flask-SQLAlchemy==3.1.1
qrcode==8.0
waitress==3.0.1
openpyxl==3.1.5
```

## Licencia

Uso privado — Boxfit Matias Medina.
