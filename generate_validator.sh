#!/usr/bin/env bash

set -e

npx openapi2schema -i openapi.yml -p | jq '."/events".get.responses."200"' | jq '."$schema" = "http://json-schema.org/draft-07/schema#"' > schema.json
npx ajv compile -s schema.json -o validator.js --spec=draft7 -c ajv-formats
npx browserify validate.js > bundle.js
