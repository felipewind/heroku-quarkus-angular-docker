#!/bin/sh
# =============================================================================
# This script automatically splits the env variable DATASOURCE_URL from
# Heroku into the three JDBC variables needed from Quarkus.
# 
# It will only do the split if the DB_AUTO_SPLIT is set to "true".
#
# If you set DB_AUTO_SPLIT to 'false', you must pass the Quarkus parameters:
#   - DATASOURCE_JDBC_URL;
#   - DATASOURCE_JDBC_USER;
#   - DATASOURCE_JDBC_PASSWORD.
# 
# For test purposes, you can set the ECHO_DB_VALUES to 'true' and check if the
# values are correct.
# 
# Pattern of DATASOURCE_URL from Heroku:
# --------------------------------------
#   postgres://username:password@host:port/databasename
# 
# Pattern of JDBC variables of Quarkus:
# -------------------------------------
#   quarkus.datasource.jdbc.url=jdbc:postgresql://host:port/databasename
#   quarkus.datasource.username=username
#   quarkus.datasource.password=password
# 
# =============================================================================

echo DB_AUTO_SPLIT=[$DB_AUTO_SPLIT] 

# check for 'true' in string (case insensitive)
if [[ "${DB_AUTO_SPLIT,,}" == "true" ]]; then

  export DATASOURCE_JDBC_URL=jdbc:postgresql://${DATABASE_URL#*@}

  export DATASOURCE_JDBC_USER=$(expr $DATABASE_URL : '.*/\([^:]*\):.*')

  export DATASOURCE_JDBC_PASSWORD=$(expr $DATABASE_URL : '.*:\([^@]*\)@.*')

fi

# check for 'true' in string (case insensitive)
if [[ "${ECHO_DB_VALUES,,}" == "true" ]]; then

  echo DATABASE_URL=[$DATABASE_URL]
  echo DATASOURCE_JDBC_URL=[$DATASOURCE_JDBC_URL]
  echo DATASOURCE_JDBC_USER=[$DATASOURCE_JDBC_USER] 
  echo DATASOURCE_JDBC_PASSWORD=[$DATASOURCE_JDBC_PASSWORD]

fi