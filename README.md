# heroku-quarkus-angular-docker
Demo project to deploy Quarkus/PostgreSQL and Angular/Nginx as containers on Heroku

## Getting Started

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
    image: heroku/postgres:13.3
    build:
      context: ./postgresql/
      dockerfile: ./Dockerfile
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
      - DATABASE_HOST=heroku-postgresql
      - DATABASE_PORT=5432
      - DATABASE_NAME=postgres
      - DATABASE_USER=postgres
      - DATABASE_PASSWORD=postgres
      - PORT=8080
    
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
