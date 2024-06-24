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
