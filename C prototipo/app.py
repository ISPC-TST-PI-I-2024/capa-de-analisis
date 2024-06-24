from flask import Flask, request, jsonify
from db_config import close_db_connection
from routes.configuraciones import configuraciones_bp
from routes.datos_dispositivos import datos_dispositivos_bp
from routes.dispositivos import dispositivos_bp
from routes.proyectos import proyectos_bp
from routes.seguridad import seguridad_bp
from routes.usuarios import usuarios_bp

app = Flask(__name__)

# Middleware para verificar la clave de API
@app.before_request
def before_request():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or api_key not in ['jade', 'opalo', 'rubi', 'topaz', 'plata']:  # Claves de API válidas
        return jsonify({'error': 'Unauthorized access'}), 401

# Registro de Blueprints
app.register_blueprint(configuraciones_bp, url_prefix='/configuraciones')
app.register_blueprint(datos_dispositivos_bp, url_prefix='/datos_dispositivos')
app.register_blueprint(dispositivos_bp, url_prefix='/dispositivos')
app.register_blueprint(proyectos_bp, url_prefix='/proyectos')
app.register_blueprint(seguridad_bp, url_prefix='/seguridad')
app.register_blueprint(usuarios_bp, url_prefix='/usuarios')

app.teardown_appcontext(close_db_connection)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
