#!/bin/bash
set -e
HOSTNAME=$1
LDAP_HOST=$2
LDAP_ACCOUNTBASE=$3
DOCKER_IMAGE=openfrontier/gerrit
LOCAL_VOLUME=~/gerrit_volume
GERRIT_DOCKER_NAME=gerrit
PG_DOCKER_NAME=pg-gerrit
docker run --name $PG_DOCKER_NAME -p 5432:5432 -e POSTGRES_USER=gerrit2 -e POSTGRES_PASSWORD=gerrit -e POSTGRES_DB=reviewdb -d postgres
sleep 5
mkdir -p ${LOCAL_VOLUME}
docker run --name $GERRIT_DOCKER_NAME --link $PG_DOCKER_NAME:db -p 8080:8080 -p 29418:29418 -v ${LOCAL_VOLUME}:/var/gerrit/review_site -e WEBURL=http://${HOSTNAME}:8080 -e DATABASE_TYPE=postgresql -e AUTH_TYPE=LDAP -e LDAP_HOST=${LDAP_HOST} -e LDAP_ACCOUNTBASE="${LDAP_ACCOUNTBASE}" -d ${DOCKER_IMAGE}

