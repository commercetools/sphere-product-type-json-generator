#!/bin/bash

set -e

usage() {
  echo "$(basename $0) - Upload several product types"
  echo ""
  echo "Arguments:"
  echo "-p <project-key> - Your SPHERE.IO project key."
  echo "-t <token> - Your SPHERE.IO API access token."
  echo "-d <dir> - the directory, where the JSON files are located."
}

upload() {
  for pt in "${JSON_DIR}/"product-type-*.json; do
    echo "Uploading product type from file ${pt} ..."
    curl -H "Authorization: Bearer ${ACCESS_TOKEN}" -X POST -d @"${pt}" "https://api.sphere.io/${PROJECT_KEY}/product-types"
  done
}

while getopts "p:t:d:" OPT; do
  case "${OPT}" in
    p)
      readonly PROJECT_KEY=${OPTARG}
      ;;
    t)
      readonly ACCESS_TOKEN=${OPTARG}
      ;;
    d)
      readonly JSON_DIR=${OPTARG}
      ;;
  esac
done

if [ -z "${PROJECT_KEY}" -o -z "${ACCESS_TOKEN}" -o -z "${JSON_DIR}" ]; then
  usage
  exit 1
fi

upload
