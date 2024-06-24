# Proyecto IoT: API RESTful

Este proyecto proporciona una API RESTful para gestionar datos de un proyecto IoT utilizando Flask y MySQL. La API soporta operaciones CRUD para varias entidades como usuarios, dispositivos, proyectos, configuraciones, datos de dispositivos y seguridad.

## Estructura del Proyecto

```
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
```

## Instalación

1. Clonar el repositorio.
2. Navegar al directorio del proyecto.
3. Ejecutar `pip install -r requirements.txt` para instalar las dependencias.
4. Configurar la base de datos en `db_config.py`.
5. Ejecutar `python app.py` para iniciar el servidor.

## Uso

### Endpoints

La API proporciona los siguientes endpoints:

- **Usuarios**: 
- **Dispositivos**: 
- **Proyectos**: 
- **Configuraciones**: 
- **Datos de Dispositivos**: 
- **Seguridad**: 

Cada endpoint soporta operaciones CRUD. Ver la documentación para detalles específicos.

### Autenticación

Se requiere una clave de API para todas las solicitudes. La clave debe ser incluida en el encabezado `X-API-KEY`. Claves válidas incluyen `jade`, `opalo`, `rubi`, `topaz`, y `plata`.

```bash
curl -H "X-API-KEY: jade" https://api.gonaiot.com/jade/usuarios/
```

## Licencia

Este proyecto está licenciado bajo los términos de la licencia MIT. Ver el archivo LICENSE para más detalles.
