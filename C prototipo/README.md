# Proyecto IoT: API RESTful

Este proyecto proporciona una API RESTful para gestionar datos de un proyecto IoT utilizando Flask y MySQL. La API soporta operaciones CRUD para varias entidades como usuarios, dispositivos, proyectos, configuraciones, datos de dispositivos y seguridad.

## Estructura del Proyecto

``` bash
c_capa_de_analisis/
├── app.py
├── db_config.py
├── models.py
├── routes/
│ ├── configuraciones.py
│ ├── datos_dispositivos.py
│ ├── dispositivos.py
│ ├── proyectos.py
│ ├── seguridad.py
│ └── usuarios.py
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

#### Usuarios

1. **Obtener Usuarios**
   - **Método**: `GET`
   - **URL**: `/usuarios/`
   - **Descripción**: Devuelve una lista de todos los usuarios registrados en la base de datos.
   - **Respuesta**:
     ```json
     [
       {
         "id": 1,
         "nombre": "Juan Perez",
         "email": "juan.perez@example.com"
       },
       ...
     ]
     ```

2. **Crear Usuario**
   - **Método**: `POST`
   - **URL**: `/usuarios/`
   - **Descripción**: Crea un nuevo usuario en la base de datos.
   - **Cuerpo de la Solicitud**:
     ```json
     {
       "nombre": "Juan Perez",
       "email": "juan.perez@example.com",
       "password": "password123"
     }
     ```
   - **Respuesta**: Código de estado `201 Created` si se crea con éxito.

#### Dispositivos

1. **Obtener Dispositivos**
   - **Método**: `GET`
   - **URL**: `/dispositivos/`
   - **Descripción**: Devuelve una lista de todos los dispositivos registrados.
   - **Respuesta**:
     ```json
     [
       {
         "id": 1,
         "nombre": "Sensor de temperatura",
         "tipo": "Sensor",
         "ubicacion": "Sala de servidores"
       },
       ...
     ]
     ```

2. **Crear Dispositivo**
   - **Método**: `POST`
   - **URL**: `/dispositivos/`
   - **Descripción**: Registra un nuevo dispositivo en la base de datos.
   - **Cuerpo de la Solicitud**:
     ```json
     {
       "nombre": "Sensor de temperatura",
       "tipo": "Sensor",
       "ubicacion": "Sala de servidores"
     }
     ```
   - **Respuesta**: Código de estado `201 Created` si se crea con éxito.

#### Datos de Dispositivos

1. **Obtener Datos de Dispositivos**
   - **Método**: `GET`
   - **URL**: `/datos_dispositivos/`
   - **Descripción**: Devuelve una lista de los datos registrados para los dispositivos.
   - **Respuesta**:
     ```json
     [
       {
         "id": 1,
         "dispositivo_id": 1,
         "valor": 23.5,
         "unidad": "C",
         "timestamp": "2024-06-24T00:00:00Z"
       },
       ...
     ]
     ```

2. **Enviar Datos de Dispositivo**
   - **Método**: `POST`
   - **URL**: `/datos_dispositivos/`
   - **Descripción**: Envia nuevos datos para un dispositivo.
   - **Cuerpo de la Solicitud**:
     ```json
     {
       "dispositivo_id": 1,
       "valor": 23.5,
       "unidad": "C"
     }
     ```
   - **Respuesta**: Código de estado `201 Created` si se envía con éxito.

#### Configuraciones

1. **Obtener Configuraciones**
   - **Método**: `GET`
   - **URL**: `/configuraciones/`
   - **Descripción**: Devuelve una lista de las configuraciones del sistema.
   - **Respuesta**:
     ```json
     [
       {
         "id": 1,
         "nombre": "intervalo_muestreo",
         "valor": "10s"
       },
       ...
     ]
     ```

2. **Actualizar Configuración**
   - **Método**: `PUT`
   - **URL**: `/configuraciones/{id}`
   - **Descripción**: Actualiza una configuración específica.
   - **Cuerpo de la Solicitud**:
     ```json
     {
       "nombre": "intervalo_muestreo",
       "valor": "10s"
     }
     ```
   - **Respuesta**: Código de estado `200 OK` si se actualiza con éxito.

#### Proyectos

1. **Obtener Proyectos**
   - **Método**: `GET`
   - **URL**: `/proyectos/`
   - **Descripción**: Devuelve una lista de todos los proyectos registrados.
   - **Respuesta**:
     ```json
     [
       {
         "id": 1,
         "nombre": "Proyecto IoT",
         "descripcion": "Proyecto para monitoreo de temperatura"
       },
       ...
     ]
     ```

2. **Crear Proyecto**
   - **Método**: `POST`
   - **URL**: `/proyectos/`
   - **Descripción**: Crea un nuevo proyecto en la base de datos.
   - **Cuerpo de la Solicitud**:
     ```json
     {
       "nombre": "Proyecto IoT",
       "descripcion": "Proyecto para monitoreo de temperatura"
     }
     ```
   - **Respuesta**: Código de estado `201 Created` si se crea con éxito.

#### Seguridad

1. **Obtener Información de Seguridad**
   - **Método**: `GET`
   - **URL**: `/seguridad/`
   - **Descripción**: Devuelve la información de seguridad del sistema.
   - **Respuesta**:
     ```json
     {
       "seguridad_activa": true,
       "ultimo_chequeo": "2024-06-24T00:00:00Z"
     }
     ```

### Autenticación

Se requiere una clave de API para todas las solicitudes. La clave debe ser incluida en el encabezado `X-API-KEY`. Claves válidas incluyen `jade`, `opalo`, `rubi`, `topaz`, y `plata`.

```bash
curl -H "X-API-KEY: jade" https://api.gonaiot.com/jade/usuarios/
```	

## Licencia

Este proyecto está licenciado bajo los términos de la licencia MIT. Ver el archivo LICENSE para más detalles.