# heroku-quarkus-angular-docker
This is a demo project to deploy Quarkus/PostgreSQL and Angular/Nginx as containers on Heroku.

## Medium Articles

[Deploying Quarkus/PostgreSQL and Quarkus/Nginx on Heroku as containers](https://medium.com/@felipewind/deploying-quarkus-postgresql-and-angular-nginx-on-heroku-as-containers-7244507e548f)

[Bash script to extract Quarkus jdbc.url, username and password from Heroku DATABASE_URL](https://medium.com/@felipewind/bash-script-to-extract-quarkus-jdbc-url-username-and-password-from-heroku-database-url-fde31cf6e722)

## Getting Started with script

Run this script to build Quarkus, Angular and to bring up docker-compose:
```bash
$ chmod +x run-after-local-build.sh
$ ./run-with-local-build.sh
```

## Getting Started manually

Build the Quarkus project:
```bash
$ cd quarkus/
$ ./mvnw package
```

Build the Angular project:
```
$ cd angular/
$ npm install
$ ng build
```

Bring up the following docker-compose.yml:

```yml
version: "3.8"

services:
  heroku-postgresql:
    container_name: heroku-postgres
    image: postgres:13.3
    environment:
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=postgres
      - POSTGRES_USER=postgres
    ports:
        - 5432:5432
    networks:
      - heroku-net

  heroku-quarkus:
    container_name: heroku-quarkus
    image: heroku/quarkus-jvm:1.0
    build:
      context: ./quarkus/
      dockerfile: ./src/main/docker/Dockerfile.jvm
    ports:
      - 8080:8080
    networks:
      - heroku-net
    depends_on:
      - heroku-postgresql
    environment:
      - DB_ECHO_VALUES=true      
      - PORT=8080
        ### Using the DB_HEROKU_SPLIT = true  ###
      - DB_HEROKU_SPLIT=true
      - DATABASE_URL=postgres://postgres:postgres@heroku-postgresql:5432/postgres
        ### Using the DB_HEROKU_SPLIT = false ###
      # - DB_HEROKU_SPLIT=false
      # - DB_JDBC_URL=jdbc:postgresql://heroku-postgresql:5432/postgres
      # - DB_JDBC_USER=postgres
      # - DB_JDBC_PASSWORD=postgres
    
  heroku-angular:
    container_name: heroku-angular
    image: heroku/angular:1.0
    build:
      context: ./angular/
      dockerfile: ./Dockerfile
    ports:
      - 80:80
    networks:
      - heroku-net
    depends_on:      
      - heroku-quarkus
    environment:      
      - API_URL=http://localhost:8080
      - PORT=80

networks:
  heroku-net:
    driver: bridge
```

Access the Quarkus Swagger UI at http://localhost:8080/q/swagger-ui and the Angular front end at http://localhost
