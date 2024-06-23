#!/bin/bash

# Crear directorios necesarios
mkdir -p routes

# Crear archivos y agregar contenido

# app.py
cat <<EOL > app.py
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
EOL

# db_config.py
cat <<EOL > db_config.py
import mysql.connector
from flask import g

def get_db_connection():
    if 'db' not in g:
        g.db = mysql.connector.connect(
            host="localhost",
            user="YOUR_DB_USER",  # Cambiar para cada grupo
            password="YOUR_DB_PASSWORD",  # Cambiar para cada grupo
            database="YOUR_DB_NAME"  # Cambiar para cada grupo
        )
    return g.db

def close_db_connection(e=None):
    db = g.pop('db', None)
    if db is not None:
        db.close()
EOL

# models.py
cat <<EOL > models.py
# Ejemplo de uso de SQLAlchemy
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Configuraciones(db.Model):
    id_configuracion = db.Column(db.Integer, primary_key=True)
    id_dispositivo = db.Column(db.Integer, db.ForeignKey('dispositivos.id_dispositivo'))
    parametro = db.Column(db.String(50))
    valor = db.Column(db.String(100))
    fecha_asignacion = db.Column(db.TIMESTAMP, server_default=db.func.current_timestamp())

class DatosDispositivos(db.Model):
    id_dato = db.Column(db.Integer, primary_key=True)
    id_dispositivo = db.Column(db.Integer, db.ForeignKey('dispositivos.id_dispositivo'))
    fecha_recoleccion = db.Column(db.TIMESTAMP, server_default=db.func.current_timestamp())
    valor = db.Column(db.Float)
    unidad = db.Column(db.String(20))
EOL

# routes/configuraciones.py
cat <<EOL > routes/configuraciones.py
from flask import Blueprint, request, jsonify
from db_config import get_db_connection

configuraciones_bp = Blueprint('configuraciones', __name__)

@configuraciones_bp.route('/', methods=['GET'])
def get_configuraciones():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Configuraciones")
    configuraciones = cursor.fetchall()
    cursor.close()
    return jsonify(configuraciones)

@configuraciones_bp.route('/<int:id>', methods=['GET'])
def get_configuracion(id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Configuraciones WHERE id_configuracion = %s", (id,))
    configuracion = cursor.fetchone()
    cursor.close()
    return jsonify(configuracion)

@configuraciones_bp.route('/', methods=['POST'])
def add_configuracion():
    nueva_configuracion = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO Configuraciones (id_dispositivo, parametro, valor) VALUES (%s, %s, %s)",
        (nueva_configuracion['id_dispositivo'], nueva_configuracion['parametro'], nueva_configuracion['valor'])
    )
    conn.commit()
    cursor.close()
    return '', 201

@configuraciones_bp.route('/<int:id>', methods=['PUT'])
def update_configuracion(id):
    configuracion_actualizada = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE Configuraciones SET id_dispositivo = %s, parametro = %s, valor = %s WHERE id_configuracion = %s",
        (configuracion_actualizada['id_dispositivo'], configuracion_actualizada['parametro'], configuracion_actualizada['valor'], id)
    )
    conn.commit()
    cursor.close()
    return '', 204

@configuraciones_bp.route('/<int:id>', methods=['DELETE'])
def delete_configuracion(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM Configuraciones WHERE id_configuracion = %s", (id,))
    conn.commit()
    cursor.close()
    return '', 204
EOL

# routes/datos_dispositivos.py
cat <<EOL > routes/datos_dispositivos.py
from flask import Blueprint, request, jsonify
from db_config import get_db_connection

datos_dispositivos_bp = Blueprint('datos_dispositivos', __name__)

@datos_dispositivos_bp.route('/', methods=['GET'])
def get_datos_dispositivos():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Datos_Dispositivos")
    datos_dispositivos = cursor.fetchall()
    cursor.close()
    return jsonify(datos_dispositivos)

@datos_dispositivos_bp.route('/<int:id>', methods=['GET'])
def get_dato_dispositivo(id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Datos_Dispositivos WHERE id_dato = %s", (id,))
    dato_dispositivo = cursor.fetchone()
    cursor.close()
    return jsonify(dato_dispositivo)

@datos_dispositivos_bp.route('/', methods=['POST'])
def add_dato_dispositivo():
    nuevo_dato = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO Datos_Dispositivos (id_dispositivo, fecha_recoleccion, valor, unidad) VALUES (%s, %s, %s, %s)",
        (nuevo_dato['id_dispositivo'], nuevo_dato['fecha_recoleccion'], nuevo_dato['valor'], nuevo_dato['unidad'])
    )
    conn.commit()
    cursor.close()
    return '', 201

@datos_dispositivos_bp.route('/<int:id>', methods=['PUT'])
def update_dato_dispositivo(id):
    dato_actualizado = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE Datos_Dispositivos SET id_dispositivo = %s, fecha_recoleccion = %s, valor = %s, unidad = %s WHERE id_dato = %s",
        (dato_actualizado['id_dispositivo'], dato_actualizado['fecha_recoleccion'], dato_actualizado['valor'], dato_actualizado['unidad'], id)
    )
    conn.commit()
    cursor.close()
    return '', 204

@datos_dispositivos_bp.route('/<int:id>', methods=['DELETE'])
def delete_dato_dispositivo(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM Datos_Dispositivos WHERE id_dato = %s", (id,))
    conn.commit()
    cursor.close()
    return '', 204
EOL

# routes/dispositivos.py
cat <<EOL > routes/dispositivos.py
from flask import Blueprint, request, jsonify
from db_config import get_db_connection

dispositivos_bp = Blueprint('dispositivos', __name__)

@dispositivos_bp.route('/', methods=['GET'])
def get_dispositivos():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Dispositivos")
    dispositivos = cursor.fetchall()
    cursor.close()
    return jsonify(dispositivos)

@dispositivos_bp.route('/<int:id>', methods=['GET'])
def get_dispositivo(id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Dispositivos WHERE id_dispositivo = %s", (id,))
    dispositivo = cursor.fetchone()
    cursor.close()
    return jsonify(dispositivo)

@dispositivos_bp.route('/', methods=['POST'])
def add_dispositivo():
    nuevo_dispositivo = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO Dispositivos (nombre, tipo, ubicacion, id_usuario) VALUES (%s, %s, %s, %s)",
        (nuevo_dispositivo['nombre'], nuevo_dispositivo['tipo'], nuevo_dispositivo['ubicacion'], nuevo_dispositivo['id_usuario'])
    )
    conn.commit()
    cursor.close()
    return '', 201

@dispositivos_bp.route('/<int:id>', methods=['PUT'])
def update_dispositivo(id):
    dispositivo_actualizado = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE Dispositivos SET nombre = %s, tipo = %s, ubicacion = %s, id_usuario = %s WHERE id_dispositivo = %s",
        (dispositivo_actualizado['nombre'], dispositivo_actualizado['tipo'], dispositivo_actualizado['ubicacion'], dispositivo_actualizado['id_usuario'], id)
    )
    conn.commit()
    cursor.close()
    return '', 204

@dispositivos_bp.route('/<int:id>', methods=['DELETE'])
def delete_dispositivo(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM Dispositivos WHERE id_dispositivo = %s", (id,))
    conn.commit()
    cursor.close()
    return '', 204
EOL

# routes/proyectos.py
cat <<EOL > routes/proyectos.py
from flask import Blueprint, request, jsonify
from db_config import get_db_connection

proyectos_bp = Blueprint('proyectos', __name__)

@proyectos_bp.route('/', methods=['GET'])
def get_proyectos():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Proyectos")
    proyectos = cursor.fetchall()
    cursor.close()
    return jsonify(proyectos)

@proyectos_bp.route('/<int:id>', methods=['GET'])
def get_proyecto(id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Proyectos WHERE id_proyecto = %s", (id,))
    proyecto = cursor.fetchone()
    cursor.close()
    return jsonify(proyecto)

@proyectos_bp.route('/', methods=['POST'])
def add_proyecto():
    nuevo_proyecto = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO Proyectos (nombre, descripcion, id_usuario, fecha_inicio, fecha_fin) VALUES (%s, %s, %s, %s, %s)",
        (nuevo_proyecto['nombre'], nuevo_proyecto['descripcion'], nuevo_proyecto['id_usuario'], nuevo_proyecto['fecha_inicio'], nuevo_proyecto['fecha_fin'])
    )
    conn.commit()
    cursor.close()
    return '', 201

@proyectos_bp.route('/<int:id>', methods=['PUT'])
def update_proyecto(id):
    proyecto_actualizado = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE Proyectos SET nombre = %s, descripcion = %s, id_usuario = %s, fecha_inicio = %s, fecha_fin = %s WHERE id_proyecto = %s",
        (proyecto_actualizado['nombre'], proyecto_actualizado['descripcion'], proyecto_actualizado['id_usuario'], proyecto_actualizado['fecha_inicio'], proyecto_actualizado['fecha_fin'], id)
    )
    conn.commit()
    cursor.close()
    return '', 204

@proyectos_bp.route('/<int:id>', methods=['DELETE'])
def delete_proyecto(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM Proyectos WHERE id_proyecto = %s", (id,))
    conn.commit()
    cursor.close()
    return '', 204
EOL

# routes/seguridad.py
cat <<EOL > routes/seguridad.py
from flask import Blueprint, request, jsonify
from db_config import get_db_connection

seguridad_bp = Blueprint('seguridad', __name__)

@seguridad_bp.route('/', methods=['GET'])
def get_seguridad():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Seguridad")
    seguridad = cursor.fetchall()
    cursor.close()
    return jsonify(seguridad)

@seguridad_bp.route('/<int:id>', methods=['GET'])
def get_seguridad_entry(id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Seguridad WHERE id_seguridad = %s", (id,))
    seguridad_entry = cursor.fetchone()
    cursor.close()
    return jsonify(seguridad_entry)

@seguridad_bp.route('/', methods=['POST'])
def add_seguridad():
    nueva_seguridad = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO Seguridad (id_usuario, id_dispositivo, permisos) VALUES (%s, %s, %s)",
        (nueva_seguridad['id_usuario'], nueva_seguridad['id_dispositivo'], nueva_seguridad['permisos'])
    )
    conn.commit()
    cursor.close()
    return '', 201

@seguridad_bp.route('/<int:id>', methods=['PUT'])
def update_seguridad(id):
    seguridad_actualizada = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE Seguridad SET id_usuario = %s, id_dispositivo = %s, permisos = %s WHERE id_seguridad = %s",
        (seguridad_actualizada['id_usuario'], seguridad_actualizada['id_dispositivo'], seguridad_actualizada['permisos'], id)
    )
    conn.commit()
    cursor.close()
    return '', 204

@seguridad_bp.route('/<int:id>', methods=['DELETE'])
def delete_seguridad(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM Seguridad WHERE id_seguridad = %s", (id,))
    conn.commit()
    cursor.close()
    return '', 204
EOL

# routes/usuarios.py
cat <<EOL > routes/usuarios.py
from flask import Blueprint, request, jsonify
from db_config import get_db_connection

usuarios_bp = Blueprint('usuarios', __name__)

@usuarios_bp.route('/', methods=['GET'])
def get_usuarios():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Usuarios")
    usuarios = cursor.fetchall()
    cursor.close()
    return jsonify(usuarios)

@usuarios_bp.route('/<int:id>', methods=['GET'])
def get_usuario(id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Usuarios WHERE id_usuario = %s", (id,))
    usuario = cursor.fetchone()
    cursor.close()
    return jsonify(usuario)

@usuarios_bp.route('/', methods=['POST'])
def add_usuario():
    nuevo_usuario = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO Usuarios (nombre, email, rol, password_hash) VALUES (%s, %s, %s, %s)",
        (nuevo_usuario['nombre'], nuevo_usuario['email'], nuevo_usuario['rol'], nuevo_usuario['password_hash'])
    )
    conn.commit()
    cursor.close()
    return '', 201

@usuarios_bp.route('/<int:id>', methods=['PUT'])
def update_usuario(id):
    usuario_actualizado = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE Usuarios SET nombre = %s, email = %s, rol = %s, password_hash = %s WHERE id_usuario = %s",
        (usuario_actualizado['nombre'], usuario_actualizado['email'], usuario_actualizado['rol'], usuario_actualizado['password_hash'], id)
    )
    conn.commit()
    cursor.close()
    return '', 204

@usuarios_bp.route('/<int:id>', methods=['DELETE'])
def delete_usuario(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM Usuarios WHERE id_usuario = %s", (id,))
    conn.commit()
    cursor.close()
    return '', 204
EOL

# requirements.txt
cat <<EOL > requirements.txt
Flask
mysql-connector-python
EOL

# Dockerfile
cat <<EOL > Dockerfile
FROM python:3.8-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .

CMD ["python", "app.py"]
EOL

# README.md
cat <<EOL > README.md
# Proyecto IoT: API RESTful

Este proyecto proporciona una API RESTful para gestionar datos de un proyecto IoT utilizando Flask y MySQL. La API soporta operaciones CRUD para varias entidades como usuarios, dispositivos, proyectos, configuraciones, datos de dispositivos y seguridad.

## Estructura del Proyecto

\`\`\`
c_capa_de_analisis/
├── app.py
├── db_config.py
├── models.py
├── routes/
│   ├── configuraciones.py
│   ├── datos_dispositivos.py
│   ├── dispositivos.py
│   ├── proyectos.py
│   ├── seguridad.py
│   └── usuarios.py
├── requirements.txt
└── Dockerfile
\`\`\`

## Instalación

1. Clonar el repositorio.
2. Navegar al directorio del proyecto.
3. Ejecutar \`pip install -r requirements.txt\` para instalar las dependencias.
4. Configurar la base de datos en \`db_config.py\`.
5. Ejecutar \`python app.py\` para iniciar el servidor.

## Uso

### Endpoints

La API proporciona los siguientes endpoints:

- **Usuarios**: `/usuarios`
- **Dispositivos**: `/dispositivos`
- **Proyectos**: `/proyectos`
- **Configuraciones**: `/configuraciones`
- **Datos de Dispositivos**: `/datos_dispositivos`
- **Seguridad**: `/seguridad`

Cada endpoint soporta operaciones CRUD. Ver la documentación para detalles específicos.

### Autenticación

Se requiere una clave de API para todas las solicitudes. La clave debe ser incluida en el encabezado \`X-API-KEY\`. Claves válidas incluyen \`jade\`, \`opalo\`, \`rubi\`, \`topaz\`, y \`plata\`.

\`\`\`bash
curl -H "X-API-KEY: jade" https://api_jade.server.gonaiot.com/usuarios
\`\`\`

## Licencia

Este proyecto está licenciado bajo los términos de la licencia MIT. Ver el archivo LICENSE para más detalles.
EOL

# LICENSE
cat <<EOL > LICENSE
MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOL

echo "Estructura del proyecto creada y archivos generados exitosamente."
