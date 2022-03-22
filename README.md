# sylius-image

## Docker sizes

| Image | Size                                                                     |
|-------|--------------------------------------------------------------------------|
| DEV   | ![Docker Hub](https://badgen.net/docker/size/ferror/sylius-image/latest) |
| 1.11  | ![Docker Hub](https://badgen.net/docker/size/ferror/sylius-image/1.11)   |

## Example usage
### Production
#### Dockerfile

```dockerfile
FROM ferror/sylius-image:1.11

COPY . /app

RUN composer install --no-scripts
RUN bin/console cache:warmup
```

### Development environment
#### Traefik config file

```yaml
log:
    level: ERROR

api:
    insecure: true

entrypoints:
    web:
        address: :80

providers:
    docker:
        exposedByDefault: true
        # https://masterminds.github.io/sprig/strings.html
        # Please define your own routing rules based on local domain
        defaultRule: "Host(`{{ .Name }}.domain.localhost`)"
```

#### Docker Compose
```yaml
services:
    traefik:
        image: traefik:2.6
        ports:
            - "80:80"     # HTTP
            - "443:443"   # HTTPS
            - "8080:8080" # Traefik UI dashboard
        volumes:
            - ./.docker/traefik.yaml:/etc/traefik/traefik.yaml
            - /var/run/docker.sock:/var/run/docker.sock:ro
        networks:
            sylius:
                ipv4_address: 192.168.10.2

    app:
        image: ferror/sylius-image:1.11
        volumes:
            - ./:/app:delegated
        depends_on:
            - traefik
            - mysql
        networks:
            - sylius

    mysql:
        image: mysql:5.7
        platform: linux/amd64
        environment:
            - MYSQL_ALLOW_EMPTY_PASSWORD=true
# You may want to initialize mysql server with some dump files
#        volumes:
#            - ./.docker/dev/mysql:/docker-entrypoint-initdb.d:delegated
        ports:
            - "3306:3306"
        depends_on:
            - traefik
        networks:
            - sylius

    postgres:
        image: postgres:13
        environment:
            - POSTGRES_PASSWORD=1234
# You may want to initialize postgres server with some dump files
#        volumes:
#            - ./.docker/dev/postgres:/docker-entrypoint-initdb.d:delegated
        ports:
            - "5432:5432"
        depends_on:
            - traefik
        networks:
            - sylius

networks:
    sylius:
        driver: bridge
        ipam:
            driver: default
            config:
                - subnet: 192.168.10.0/24
```
