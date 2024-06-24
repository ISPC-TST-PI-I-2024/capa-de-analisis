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
