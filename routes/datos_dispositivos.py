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
