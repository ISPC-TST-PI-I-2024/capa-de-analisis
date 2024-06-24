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
