# Flujo del servidor

## Actores

### NGINX
	El servidor web. Recibe las peticiones de los usuarios.
### PHP-FPM
	Interprete de PHP. Se mantiene a la espera de las peticiones de NGINX para WordPress.
	Se instalará en el entorno del contenedor de WordPress.
### WordPress
	La aplicación. Es un conjunto de archivos en PHP que define como procesar peticiones dinámicas. Necesita un interprete (ej:PHP-FPM).
### MariaDB
	La base de datos. Es a memoria a largo plazo de WordPress.

## Flujo de Petición Dinámica (Página PHP)

1.	Usuario → Nginx
	Un navegador envía una petición HTTP al puerto público (ej. `443`)

2.	Nginx → WordPress
	Nginx determina que la petición es para un recurso dinámico (un fichero `.php`).
	Reenvía la petición a través de la red interna al puerto 9000 del servicio `wordpress`.
	Los archivos de WordPress se interpretan mediante PHP-FPM.

3.	WordPress ↔ MariaDB
	El proceso PHP de WordPress se ejecuta.
	Para construir la página, realiza consultas SQL al servicio `mariadb` en el puerto `3306`.
	MariaDB procesa las consultas y devuelve los datos a WordPress.

4.	WordPress → Nginx
	Con los datos de la base de datos, WordPress termina de generar la página HTML completa.
	Envía el HTML resultante de vuelta a Nginx.

5.	Nginx → Usuario
	Nginx recibe el HTML y lo reenvía al navegador del usuario como respuesta final.

## Flujo de Petición Estática (Imagen, CSS, JS)

1.	Usuario → Nginx
	El navegador solicita un fichero estático (ej. `style.css` o `logo.png`).

2.	Nginx → Usuario
	Nginx localiza el fichero directamente en el volumen montado (`/var/www/html`).
	Sirve el fichero directamente al usuario sin contactar a ningún otro servicio.
	En este segundo flujo, los contenedores de `WordPress` y `MariaDB` no realizan ningún trabajo, lo que reduce la carga y aumenta la velocidad.
