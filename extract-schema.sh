#!/usr/bin/env bash
npx openapi2schema -i datenraumkultur.yml -p | jq '."/events".get.responses."200"' > schema.json

