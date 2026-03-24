"""
IRON GYM — Sistema de Gestión de Gimnasio de Boxeo
Versión Corregida para Despliegue (Railway + Local)
"""
from flask import Flask, render_template, request, jsonify, send_file, redirect, url_for, session
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime, date, timedelta
from functools import wraps
import os, io, csv, json, base64, hashlib

# ── Entorno y Configuración de Puertos ──────────────────────────────
# Railway asigna un puerto dinámico en la variable PORT. Localmente usa 5000.
ENTORNO = os.environ.get('IRONGYM_ENV', 'produccion').lower()
IS_TEST = (ENTORNO == 'test')
APP_PORT = int(os.environ.get("PORT", 5001 if IS_TEST else 5000))
APP_VERSION = "2.1"

# ── QR Helpers ──────────────────────────────────────────────────────
def _qr_matrix(data: str):
    import qrcode as _qr
    qr = _qr.QRCode(version=None, error_correction=_qr.constants.ERROR_CORRECT_M, box_size=1, border=2)
    qr.add_data(data)
    qr.make(fit=True)
    return qr.get_matrix()

def _matrix_to_svg(matrix) -> str:
    size = len(matrix)
    cell = 8
    px = size * cell
    rects = []
    for r, row in enumerate(matrix):
        for c, val in enumerate(row):
            if val:
                x, y = c * cell, r * cell
                rects.append(f'<rect x="{x}" y="{y}" width="{cell}" height="{cell}"/>')
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{px}" height="{px}" '
            f'viewBox="0 0 {px} {px}" shape-rendering="crispEdges">'
            f'<rect width="100%" height="100%" fill="white"/>'
            f'<g fill="black">{"".join(rects)}</g></svg>')

def gen_qr_svg(data_dict: dict) -> str:
    matrix = _qr_matrix(json.dumps(data_dict))
    return _matrix_to_svg(matrix)

def gen_qr_b64_svg(data_dict: dict) -> str:
    svg = gen_qr_svg(data_dict)
    return base64.b64encode(svg.encode()).decode()

# ── App config & DB ──────────────────────────────────────────────────
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

if IS_TEST:
    DB_FOLDER = os.path.join(BASE_DIR, 'instance_test')
    DB_FILE = os.path.join(DB_FOLDER, 'irongym_test.db')
else:
    DB_FOLDER = os.path.join(BASE_DIR, 'instance')
    DB_FILE = os.path.join(DB_FOLDER, 'irongym.db')

if not os.path.exists(DB_FOLDER):
    os.makedirs(DB_FOLDER, exist_ok=True)

app = Flask(__name__, instance_path=DB_FOLDER)
app.secret_key = f'irongym-secret-2024-{ENTORNO}'
app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{DB_FILE}'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Optimización SQLite para concurrencia
app.config['SQLALCHEMY_ENGINE_OPTIONS'] = {
    'connect_args': {'check_same_thread': False, 'timeout': 30},
}

db = SQLAlchemy(app)

# ── Models (Resumidos para brevedad, mantén los tuyos igual) ─────────
class Config(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    clave = db.Column(db.String(80), unique=True, nullable=False)
    valor = db.Column(db.Text, default='')

class Plan(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(120), nullable=False)
    precio = db.Column(db.Float, default=0)

class Alumno(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(200), nullable=False)
    dni = db.Column(db.String(20), unique=True, nullable=False)
    vto_cuota = db.Column(db.Date)
    estado = db.Column(db.String(20), default='activo')
    plan_id = db.Column(db.Integer, db.ForeignKey('plan.id'))
    
    @property
    def es_moroso(self):
        if self.estado == 'inactivo' or not self.vto_cuota: return False
        return self.vto_cuota < date.today()

    def to_dict(self):
        return {'id': self.id, 'nombre': self.nombre, 'dni': self.dni, 'estado': self.estado, 'es_moroso': self.es_moroso}

# ── Rutas Básicas de Funcionamiento ──────────────────────────────────
@app.route('/')
def index():
    if 'user' in session: return render_template('index.html')
    return render_template('login.html')

@app.route('/api/login', methods=['POST'])
def api_login():
    data = request.json
    u = (data.get('usuario') or '').lower().strip()
    if u == 'admin': # Simplificado para prueba
        session['user'] = 'admin'; session['role'] = 'admin'
        return jsonify({'ok': True, 'role': 'admin'})
    return jsonify({'ok': False, 'msg': 'Error'}), 401

# ── Inicio del Servidor ──────────────────────────────────────────────
if __name__ == "__main__":
    with app.app_context():
        db.create_all() # Crea las tablas si no existen
    
    print(f"Servidor Iron Gym v{APP_VERSION} iniciado en puerto {APP_PORT}")
    # host='0.0.0.0' es fundamental para Railway
    app.run(host='0.0.0.0', port=APP_PORT)