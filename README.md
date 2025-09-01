## What are Containers?

Containers are an abstraction at the application layer that packages code and dependencies together. Multiple containers can run on the same machine and share the OS kernel with other containers, each running as isolated processes in user space. Containers take up less space than virtual machines (VMs), can handle more applications, and require fewer OS resources.

## What are Virtual Machines?

Virtual Machines (VMs) abstract physical hardware, allowing one server to host multiple virtual servers. Each VM includes a full operating system, the application, necessary binaries, and libraries, taking up tens of GBs. VMs also have slower boot times.

## Why Docker and What Problems Does It Solve?

Before Docker, developers and testers often faced environment inconsistencies. Code working on a developer's machine might fail on a tester's machine due to missing dependencies or environment variables. Docker solves this by creating a consistent environment.

### Docker vs Virtual Machines

| Feature        | Virtual Machine | Docker                  |
| -------------- | --------------- | ----------------------- |
| Memory Usage   | High            | Low                     |
| Boot Time      | Slow            | Fast (uses host kernel) |
| Scalability    | Hard            | Easy                    |
| Efficiency     | Low             | High                    |
| Shared Storage | No              | Yes                     |

## Docker Engine Workflow

1. Write a Dockerfile with instructions to build an image.
2. Build the image using `docker build`.
3. Run the image as a container with `docker run`.
4. Manage containers using Docker client commands.
5. Push images to a registry like Docker Hub if needed.

## Dockerfile vs Docker Compose

* **Dockerfile:** Builds a single Docker image.
* **Docker Compose:** Defines and runs multiple containers for an application.

### Common Dockerfile Commands

* `FROM`: Specifies the base image.
* `RUN`: Executes a command in the container during build.
* `CMD`: Sets the default command to run when the container starts.
* `COPY`: Copies a file from the host machine to the container.

### Common Docker Compose Keys

* `services`: Defines application services (containers).
* `volumes`: Sets up persistent storage.
* `networks`: Configures networking between containers.

## Common Docker Commands and Explanation

* `docker build`: Builds an image from a Dockerfile.
* `docker run`: Starts a container from an image.
* `docker pull`: Downloads an image from a registry.
* `docker push`: Uploads an image to a registry.
* `docker ps`: Lists running containers.
* `docker stop`: Stops a running container.
* `docker rm`: Removes a stopped container.
* `docker rmi`: Removes an image.
* `docker exec`: Runs a command inside a running container.
* `docker logs`: Shows logs from a container.

## Common Docker Compose Commands and Explanation

* `up`: Creates and starts containers defined in the Compose file.
* `down`: Stops and removes containers, networks, and volumes (using -v) created by `up`.
* `start`: Starts existing stopped containers.
* `stop`: Stops running containers.
* `restart`: Restarts containers.
* `build`: Builds images defined in the Compose file.
* `ps`: Lists containers managed by Compose.
* `logs`: Displays logs from containers.
* `exec`: Runs a command inside a running container.
* `pull`: Pulls images for services.
* `push`: Pushes built images to a registry.

## Docker Networks
Used to enable comunication between containers.

* **Bridge:** Default network; containers communicate with each other and the host.
* **Host:** Uses host network; no isolation.
* **Overlay:** Connects containers across different Docker hosts.
* **Macvlan:** Containers get unique IPs on the host subnet.

## Docker Volumes
Persists data and can be shared.

* **Bind Mount:** Maps host directory into container.
* **Named Volume:** Managed by Docker.

## MariaDB

MariaDB is an open-source RDBMS, drop-in replacement for MySQL.

## WordPress

WordPress is a CMS based on PHP and MySQL.

### FastCGI / PHP-FPM

* Protocol to execute PHP scripts efficiently.
* PHP-FPM manages worker processes for PHP.

## NGINX

NGINX is a high-performance web server and reverse proxy.
