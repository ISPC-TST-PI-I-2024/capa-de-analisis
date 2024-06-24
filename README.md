# Proyecto IoT: API RESTful

## Carátula del ISPC

---

## Datos del Docente y de la Materia

---

## Datos del Grupo de Trabajo y sus Integrantes

---

## Datos del Proyecto

---

## Introducción

Este proyecto proporciona una API RESTful para gestionar datos de un proyecto IoT utilizando Flask y MySQL. La API soporta operaciones CRUD para varias entidades como usuarios, dispositivos, proyectos, configuraciones, datos de dispositivos y seguridad.

---

## Modelo de Datos para IoT

### Introducción a la Base de Datos IoT

La base de datos diseñada para este proyecto IoT está estructurada para gestionar eficazmente los datos generados por dispositivos de borde (edge devices). Esta base de datos se compone de varias tablas, cada una con un propósito específico:

- **Usuarios**: Almacena información sobre los usuarios del sistema, incluyendo su nombre, correo electrónico, rol y hash de la contraseña.
- **Dispositivos**: Contiene datos sobre los dispositivos IoT, como su nombre, tipo, ubicación e identificación del usuario asociado.
- **Proyectos**: Registra información sobre proyectos, incluyendo nombre, descripción, usuario responsable y fechas de inicio y fin.
- **Configuraciones**: Gestiona las configuraciones de los dispositivos, incluyendo parámetros y valores específicos.
- **Datos de Dispositivos**: Almacena los datos recolectados por los dispositivos, como valores medidos y unidades.
- **Seguridad**: Controla los permisos de seguridad, detallando qué usuario tiene acceso a qué dispositivo y con qué permisos.

Esta estructura permite un seguimiento detallado y eficiente de los datos generados y utilizados en un entorno IoT, asegurando que cada pieza de información esté correctamente relacionada y accesible según los permisos de seguridad establecidos.

### Metodología del Proyecto

El proyecto IoT sigue una metodología que integra el uso de dispositivos de borde, la recolección de datos, su almacenamiento en una base de datos y la gestión de estos datos a través de una API RESTful. La implementación incluye:

1. **Configuración de Dispositivos IoT**: Los dispositivos se configuran para recolectar datos específicos y transmitirlos a un servidor central.
2. **Recolección y Almacenamiento de Datos**: Los datos recolectados por los dispositivos se almacenan en una base de datos MySQL.
3. **Gestión de Datos**: A través de una API RESTful desarrollada con Flask, se gestionan las operaciones CRUD (Crear, Leer, Actualizar, Eliminar) sobre los datos almacenados.

---

## Funciones de las Tablas

### Tabla **Usuarios**

- **id_usuario**: Identificador único del usuario.
- **nombre**: Nombre del usuario.
- **email**: Correo electrónico del usuario.
- **rol**: Rol del usuario en el sistema.
- **password_hash**: Hash de la contraseña del usuario.
- **fecha_creacion**: Fecha y hora de creación del usuario.

### Tabla **Dispositivos**

- **id_dispositivo**: Identificador único del dispositivo.
- **nombre**: Nombre del dispositivo.
- **tipo**: Tipo de dispositivo.
- **ubicacion**: Ubicación del dispositivo.
- **id_usuario**: Identificador del usuario asociado al dispositivo.

### Tabla **Proyectos**

- **id_proyecto**: Identificador único del proyecto.
- **nombre**: Nombre del proyecto.
- **descripcion**: Descripción del proyecto.
- **id_usuario**: Identificador del usuario responsable del proyecto.
- **fecha_inicio**: Fecha de inicio del proyecto.
- **fecha_fin**: Fecha de fin del proyecto.

### Tabla **Configuraciones**

- **id_configuracion**: Identificador único de la configuración.
- **id_dispositivo**: Identificador del dispositivo asociado.
- **parametro**: Parámetro de configuración.
- **valor**: Valor del parámetro.
- **fecha_asignacion**: Fecha y hora de asignación de la configuración.

### Tabla **Datos_Dispositivos**

- **id_dato**: Identificador único del dato.
- **id_dispositivo**: Identificador del dispositivo que recolectó el dato.
- **fecha_recoleccion**: Fecha y hora en que el dato fue recolectado.
- **valor**: Valor del dato recolectado.
- **unidad**: Unidad de medida del valor recolectado.

### Tabla **Seguridad**

- **id_seguridad**: Identificador único del registro de seguridad.
- **id_usuario**: Identificador del usuario.
- **id_dispositivo**: Identificador del dispositivo.
- **permisos**: Permisos otorgados al usuario para el dispositivo.
- **fecha_asignacion**: Fecha y hora de asignación de los permisos.

---

## Descripción de las Rutas

### Ruta 1: **Configuraciones**

**Descripción**: Este módulo maneja las operaciones CRUD para las configuraciones de los dispositivos IoT.

- **GET /configuraciones/**: Obtiene todas las configuraciones.
- **GET /configuraciones/int:id**: Obtiene una configuración específica por ID.
- **POST /configuraciones/**: Crea una nueva configuración.
- **PUT /configuraciones/int:id**: Actualiza una configuración existente por ID.
- **DELETE /configuraciones/int:id**: Elimina una configuración por ID.

### Ruta 2: **Datos_Dispositivos**

**Descripción**: Maneja las operaciones CRUD para los datos recolectados por los dispositivos IoT.

- **GET /datos_dispositivos/**: Obtiene todos los datos recolectados.
- **GET /datos_dispositivos/int:id**: Obtiene un dato específico por ID.
- **POST /datos_dispositivos/**: Crea un nuevo registro de dato.
- **PUT /datos_dispositivos/int:id**: Actualiza un dato existente por ID.
- **DELETE /datos_dispositivos/int:id**: Elimina un dato por ID.

### Ruta 3: **Dispositivos**

**Descripción**: Maneja las operaciones CRUD para los dispositivos IoT.

- **GET /dispositivos/**: Obtiene todos los dispositivos.
- **GET /dispositivos/int:id**: Obtiene un dispositivo específico por ID.
- **POST /dispositivos/**: Crea un nuevo dispositivo.
- **PUT /dispositivos/int:id**: Actualiza un dispositivo existente por ID.
- **DELETE /dispositivos/int:id**: Elimina un dispositivo por ID.

### Ruta 4: **Proyectos**

**Descripción**: Maneja las operaciones CRUD para los proyectos.

- **GET /proyectos/**: Obtiene todos los proyectos.
- **GET /proyectos/int:id**: Obtiene un proyecto específico por ID.
- **POST /proyectos/**: Crea un nuevo proyecto.
- **PUT /proyectos/int:id**: Actualiza un proyecto existente por ID.
- **DELETE /proyectos/int:id**: Elimina un proyecto por ID.

### Ruta 5: **Seguridad**

**Descripción**: Maneja las operaciones CRUD para los permisos de seguridad.

- **GET /seguridad/**: Obtiene todos los registros de seguridad.
- **GET /seguridad/int:id**: Obtiene un registro de seguridad específico por ID.
- **POST /seguridad/**: Crea un nuevo registro de seguridad.
- **PUT /seguridad/int:id**: Actualiza un registro de seguridad existente por ID.
- **DELETE /seguridad/int:id**: Elimina un registro de seguridad por ID.

### Ruta 6: **Usuarios**

**Descripción**: Maneja las operaciones CRUD para los usuarios del sistema.

- **GET /usuarios/**: Obtiene todos los usuarios.
- **GET /usuarios/int:id**: Obtiene un usuario específico por ID.
- **POST /usuarios/**: Crea un nuevo usuario.
- **PUT /usuarios/int:id**: Actualiza un usuario existente por ID.
- **DELETE /usuarios/int:id**: Elimina un usuario por ID.

---

## Uso

### Autenticación

Se requiere una clave de API para todas las solicitudes. La clave debe ser incluida en el encabezado `X-API-KEY`. Claves válidas incluyen `jade`, `opalo`, `rubi`, `topaz`, y `plata`.

```bash
curl -H "X-API-KEY: jade" https://api.gonaiot.com/jade/usuarios/
```

### Licencia
Este proyecto está licenciado bajo los términos de la licencia MIT. Ver el archivo LICENSE para más detalles.