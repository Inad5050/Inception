FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    rm -rf /var/lib/apt/lists/*

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["mysqld", "--user=mysql", "--bind-address=0.0.0.0"]