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
