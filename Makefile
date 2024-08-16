schemas = internationalized-string \
		  postal-address \
		  person \
		  organization \
		  person-or-organization \
		  event
sources = InternationalizedString \
		  PostalAddress \
		  Person \
		  Organization \
		  PersonOrOrganization \
		  Event
schema_files = $(foreach schema,$(schemas),schemas/$(schema).json)
src_files = $(foreach source,$(sources),elm/src/Data/$(source).elm)
src_files += elm/src/Data/Root.elm
src_files += elm/src/Helper/Encode.elm

.PHONY : all
all : index.html \
		validate/validator.js validate/bundle.js validate/main.min.js \
		view/bundle.js view/main.min.js

.PHONY : clean
clean :
		rm -f index.html
		rm -f validate/validator.js validate/bundle.js validate/main.js validate/main.min.js
		rm -f view/bundle.js view/main.js view/main.min.js
		rm -f schemas/*.json
		rm -rf js2e_output/*
		rm -rf elm/src/Data/*

index.html : openapi.yml
	npx @redocly/cli build-docs openapi.yml -o index.html \
		--theme.openapi.disableSearch \
		--theme.openapi.expandResponses=all \
		--theme.openapi.jsonSampleExpandLevel=3 \
		--theme.openapi.schemaExpansionLevel=2

validate/validator.js : schemas/schema.json $(schema_files)
	npx ajv compile $(foreach schema,$(schema_files),-r $(schema)) -s schemas/schema.json -o ./validate/validator.js --spec=draft7 -c ajv-cli-custom -c ajv-formats --all-errors


schemas/%.json : schemas/%.yml
	# Convert YML file to JSON
	npx js-yaml $< > $@
	# Expand relative references to other schema-files to fully-qualified schema URLs
	jq '(..|objects|select(has("$$ref"))).["$$ref"] |= sub("\\.(?<n>.*)\\.yml"; "https://peret.github.io/uc3-openapi\(.n).json")' $@ > $@.tmp
	mv $@.tmp $@

validate/bundle.js view/bundle.js : %/bundle.js : %/interop.js
	npx browserify $< | npx uglifyjs --mangle --compress --output $@

validate/main.js : elm/src/Validate.elm $(src_files)
	cd elm; \
	elm make src/Validate.elm --optimize --output=../validate/main.js

view/main.js : elm/src/View.elm $(src_files)
	cd elm; \
	elm make src/View.elm --optimize --output=../view/main.js

%/main.min.js : %/main.js
	npx uglifyjs $< --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | npx uglifyjs --mangle --output $@

js2e_output/src/Data/%.elm &: schemas/
	./js2e schemas/

$(src_files) : elm/src/%.elm : js2e_output/src/%.elm
	mkdir -p elm/src/Data
	cp $< $@
