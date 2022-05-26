# sylius-image

## Docker sizes

| Image             | Size                                                                                |
|-------------------|-------------------------------------------------------------------------------------|
| 1.11              | ![Docker Hub](https://badgen.net/docker/size/ferror/sylius-image/1.11)              |
| 1.11-headless     | ![Docker Hub](https://badgen.net/docker/size/ferror/sylius-image/1.11-headless)     |
| 1.11-experimental | ![Docker Hub](https://badgen.net/docker/size/ferror/sylius-image/1.11-experimental) |
| 1.11-roadrunner   | ![Docker Hub](https://badgen.net/docker/size/ferror/sylius-image/1.11-roadrunner)   |

## Example usage
### Production environment
#### Dockerfile

```dockerfile
FROM ferror/sylius-image:1.11

COPY . /app

RUN composer install --no-scripts
RUN php bin/console cache:warmup --no-debug --env=prod
RUN yarn install --pure-lockfile && yarn build
```

In case of memory exhaustion you can increase PHP `memory_limit` config or add `--no-optional-warmers` flag
```dockerfile
RUN php bin/console cache:warmup --no-debug --env=prod --no-optional-warmers
```

#### Kubernetes
[https://github.com/ferror/sylius-kubernetes](https://github.com/ferror/sylius-kubernetes)

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
            - 80:80     # HTTP
            - 443:443   # HTTPS
            - 8080:8080 # Traefik UI dashboard
        volumes:
            - ./.docker/traefik.yaml:/etc/traefik/traefik.yaml
            - /var/run/docker.sock:/var/run/docker.sock:ro
        networks:
            - sylius

    app:
        image: ferror/sylius-image:1.11
        volumes:
            - ./:/app:delegated
        depends_on:
            - traefik
            - mysql
            - postgres
        networks:
            - sylius

    mysql:
        image: mysql:5.7
        platform: linux/amd64 # mysql does not support arm images :(
        environment:
            - MYSQL_ROOT_PASSWORD=mysql
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
            - POSTGRES_USER=root
            - POSTGRES_PASSWORD=postgres
# You may want to initialize postgres server with some dump files
#        volumes:
#            - ./.docker/dev/postgres:/docker-entrypoint-initdb.d:delegated
        ports:
            - 5432:5432
        depends_on:
            - traefik
        networks:
            - sylius

networks:
    sylius:
        driver: bridge
```
