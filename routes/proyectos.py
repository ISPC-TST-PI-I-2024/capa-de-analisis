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
