#!/usr/bin/env bash

set -e

mkdir -p tmp
# Extract endpoint schema from OpenAPI specification.
npx @redocly/cli bundle --dereferenced true --ext json openapi.yml | jq '.paths."/events".get.responses."200".content."application/json".schema' > tmp/openapi.json

# Convert OpenAPI schema to JSON schema.
npx  @openapi-contrib/openapi-schema-to-json-schema -f tmp/openapi.json -o tmp/converted.json
cat tmp/converted.json | jq '."$schema" = "http://json-schema.org/draft-07/schema#"' > schema.json

# Build documentation page.
npx @redocly/cli build-docs openapi.yml -o index.html \
  --theme.openapi.disableSearch \
  --theme.openapi.expandResponses=all \
  --theme.openapi.jsonSampleExpandLevel=3 \
  --theme.openapi.schemaExpansionLevel=2

# Build static JSON schema validator script.
npx ajv compile -s schema.json -o ./validate/validator.js --spec=draft7 -c ajv-formats --all-errors

# Compile validator app.
cd validate
elm make src/Main.elm --optimize --output=main.js
npx uglifyjs main.js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | npx uglifyjs --mangle --output main.min.js
npx browserify ./interop.js | npx uglifyjs --mangle --compress --output ./bundle.js
