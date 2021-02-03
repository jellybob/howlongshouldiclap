#!/usr/bin/env bash
set -e

rm -rf data
mkdir -p data
pushd data

for AREA in E92000001 N92000002 S92000003 W92000004; do
    curl "https://api.coronavirus.data.gov.uk/v2/data?areaType=nation&areaCode=${AREA}&metric=cumDeathsByPublishDate&format=json" > $AREA.json
done