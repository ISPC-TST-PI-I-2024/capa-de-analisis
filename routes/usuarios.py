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
