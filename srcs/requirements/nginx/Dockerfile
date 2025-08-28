FROM debian:11

RUN apt-get update && apt-get install -y \
    nginx \
    openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=ESP/ST=EUS/L=BILBAO/O=42/OU=42/CN=dangonz3.42.com/UID=dangonz3"

COPY conf/nginx.conf /etc/nginx/conf.d/wp-conf.conf

RUN chown -R www-data:www-data /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
