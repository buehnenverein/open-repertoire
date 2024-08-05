#!/usr/bin/env bash

set -e

mkdir -p tmp

# Build documentation page.
npx @redocly/cli build-docs openapi.yml -o index.html \
  --theme.openapi.disableSearch \
  --theme.openapi.expandResponses=all \
  --theme.openapi.jsonSampleExpandLevel=3 \
  --theme.openapi.schemaExpansionLevel=2

# Convert schema.yml to JSON
npx js-yaml schema.yml > schema.json

# Build static JSON schema validator script.
npx ajv compile -s schema.json -o ./validate/validator.js --spec=draft7 -c ajv-cli-custom -c ajv-formats --all-errors

./js2e schema.json
cp ./js2e_output/src/Data/Root.elm ./elm/src/Data/Root.elm
cp ./js2e_output/src/Helper/Encode.elm ./elm/src/Helper/Encode.elm

# Compile validator app.
cd elm
elm make src/Validate.elm --optimize --output=../validate/main.js
npx uglifyjs ../validate/main.js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | npx uglifyjs --mangle --output ../validate/main.min.js
npx browserify ../validate/interop.js | npx uglifyjs --mangle --compress --output ../validate/bundle.js

elm make src/View.elm --optimize --output=../view/main.js
npx uglifyjs ../view/main.js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | npx uglifyjs --mangle --output ../view/main.min.js
npx browserify ../view/interop.js | npx uglifyjs --mangle --compress --output ../view/bundle.js


