#!/bin/bash

. "$(pwd)/all_scripts/hosts.txt"

TAIL_LENGTH=10
TARGETS="nginx app"

while [ "$1" != "" ]; do
  case "$1" in
    '-n' )
        TAIL_LENGTH=$2
        shift 2
        ;;
    '-t' )
        TARGETS=$2
        shift 2
        ;;
    * )
        shift
        ;;
  esac
done

NGINX_COMMAND="hostname && echo '' && ( \$(pwd)/scripts/log_nginx.sh | tail -n ${TAIL_LENGTH} )"
# nginx
if [ "${TARGETS}" == *"nginx"* ]; then
  for i in ${NGINX_HOSTS[@]}; do
    echo ""
    echo $i
    ssh "${ISUCONUSER}@${i}" "${NGINX_COMMAND}"
  done
fi

APP_COMMAND="hostname && echo '' && ( \$(pwd)/scripts/log_app.sh | tail -n ${TAIL_LENGTH} )"
# app
if [ "${TARGETS}" == *"app"* ]; then
  for i in ${WEB_HOSTS[@]}; do
    echo ""
    echo $i
    ssh "${ISUCONUSER}@${i}" "${APP_COMMAND}"
  done
fi
