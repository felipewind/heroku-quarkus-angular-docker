####
#
# Build the image with:
#
# docker build -t heroku/postgres:13.3 .
#
# Then run the container using:
#
# docker run -i --name postgres-heroku --rm -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=postgres heroku/postgres:13.3
# docker run -i --name postgres-heroku --rm --network=host -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=postgres heroku/postgres:13.3
#
###

FROM postgres:13.3

COPY init.sql /docker-entrypoint-initdb.d/init.sql