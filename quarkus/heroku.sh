#!/bin/sh
# =============================================================================
# This script automatically splits the Heroku ENV DATABASE_URL variable
# into the three JDBC variables needed from Quarkus.
# 
# It will only do the split if the DB_HEROKU_SPLIT is set to "true".
#
# If you set DB_HEROKU_SPLIT to 'false', you must pass the Quarkus parameters:
#   - DB_JDBC_URL;
#   - DB_JDBC_USER;
#   - DB_JDBC_PASSWORD.
# 
# For test purposes, you can set the DB_ECHO_VALUES to 'true' and check if the
# values are correct.
# 
# Pattern of DATABASE_URL from Heroku:
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

echo DB_HEROKU_SPLIT=[$DB_HEROKU_SPLIT] 

# check for 'true' in string (case insensitive)
if [[ "${DB_HEROKU_SPLIT,,}" == "true" ]]; then

  # cut the DATABASE_URL after '@'
  export DB_JDBC_URL=jdbc:postgresql://${DATABASE_URL#*@}

  # substring the DATABASE_URL between '//' and ':'
  export DB_JDBC_USER=$(expr $DATABASE_URL : '.*/\([^:]*\):.*')

  # substring the DATABASE_URL between ':' and '@'
  export DB_JDBC_PASSWORD=$(expr $DATABASE_URL : '.*:\([^@]*\)@.*')

fi

# check for 'true' in string (case insensitive)
if [[ "${DB_ECHO_VALUES,,}" == "true" ]]; then

  echo DATABASE_URL=[$DATABASE_URL]
  echo DB_JDBC_URL=[$DB_JDBC_URL]
  echo DB_JDBC_USER=[$DB_JDBC_USER] 
  echo DB_JDBC_PASSWORD=[$DB_JDBC_PASSWORD]

fi