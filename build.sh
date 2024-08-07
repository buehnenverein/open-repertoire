#!/usr/bin/env bash

set -e

mkdir -p tmp

# Build documentation page.
npx @redocly/cli build-docs openapi.yml -o index.html \
  --theme.openapi.disableSearch \
  --theme.openapi.expandResponses=all \
  --theme.openapi.jsonSampleExpandLevel=3 \
  --theme.openapi.schemaExpansionLevel=2

SCHEMAS=(
  "postal-address"
  "person"
  "organization"
  "person-or-organization"
  "event"
  "schema"
)
ARGS=()
for SCHEMA in ${SCHEMAS[@]}; do
  # Convert YML file to JSON
  npx js-yaml schemas/$SCHEMA.yml > schemas/$SCHEMA.json

  # Expand relative references to other schema-files to fully-qualified schema URLs
  jq '(..|objects|select(has("$ref"))).["$ref"] |= sub("\\.(?<n>.*)\\.yml"; "https://peret.github.io/uc3-openapi\(.n).json")' schemas/$SCHEMA.json > schemas/$SCHEMA.json.tmp
  mv schemas/$SCHEMA.json.tmp schemas/$SCHEMA.json

  ARGS+=("-s" "schemas/$SCHEMA.json")
done

# Build static JSON schema validator script.
npx ajv compile ${ARGS[@]} -o ./validate/validator.js --spec=draft7 -c ajv-cli-custom -c ajv-formats --all-errors
./js2e schemas/
mkdir -p ./elm/src/Data
mkdir -p ./elm/src/Helper
cp ./js2e_output/src/Data/*.elm ./elm/src/Data/
cp ./js2e_output/src/Helper/*.elm ./elm/src/Helper/

# Compile validator app.
cd elm
elm make src/Validate.elm --optimize --output=../validate/main.js
npx uglifyjs ../validate/main.js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | npx uglifyjs --mangle --output ../validate/main.min.js
npx browserify ../validate/interop.js | npx uglifyjs --mangle --compress --output ../validate/bundle.js

elm make src/View.elm --optimize --output=../view/main.js
npx uglifyjs ../view/main.js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | npx uglifyjs --mangle --output ../view/main.min.js
npx browserify ../view/interop.js | npx uglifyjs --mangle --compress --output ../view/bundle.js

