BUILD_DIR = build
SCHEMA_DIR = $(BUILD_DIR)/schemas
VALIDATE_DIR = $(BUILD_DIR)/validate
VIEW_DIR = $(BUILD_DIR)/view

schemas = internationalized-string \
		  postal-address \
		  person \
		  organization \
		  agent \
		  super-event \
		  event \
		  image-object \
		  video-object \
		  work
sources = InternationalizedString \
		  PostalAddress \
		  Person \
		  Organization \
		  Agent \
		  SuperEvent \
		  Event \
		  ImageObject \
		  VideoObject \
		  Work
schema_files = $(foreach schema,$(schemas),$(SCHEMA_DIR)/$(schema).json)

generated_elm_files = $(foreach source,$(sources),elm/src/Data/$(source).elm)
generated_elm_files += elm/src/Data/Root.elm
generated_elm_files += elm/src/Helper/Encode.elm

elm_src_files = $(wildcard elm/src/Components/*)
elm_src_files += $(wildcard elm/src/Helper/*)

.PHONY : all
all : $(BUILD_DIR)/index.html \
		$(BUILD_DIR)/example.json \
		$(BUILD_DIR)/images \
		$(VALIDATE_DIR)/validator.js $(VALIDATE_DIR)/bundle.js $(VALIDATE_DIR)/main.min.js \
		$(VIEW_DIR)/bundle.js $(VIEW_DIR)/main.min.js

.PHONY : clean
clean :
		rm -rf $(BUILD_DIR)
		rm -rf js2e_output/*
		rm -rf elm/src/Data/*
		rm -rf elm/src/Helper/Encode.elm

$(SCHEMA_DIR) :
	mkdir -p $(SCHEMA_DIR)

$(VIEW_DIR) : | view/
	cp -R view/ $(VIEW_DIR)

$(BUILD_DIR)/images : | images/
	cp -R images/ $(BUILD_DIR)/images

$(VALIDATE_DIR) : | validate/
	cp -R validate/ $(VALIDATE_DIR)

$(BUILD_DIR)/example.json : example.json
	cp example.json $(BUILD_DIR)/example.json

$(BUILD_DIR)/index.html : openapi.yml $(schema_files)
	npx @redocly/cli build-docs openapi.yml -o $(BUILD_DIR)/index.html \
		--theme.openapi.disableSearch \
		--theme.openapi.expandResponses=all \
		--theme.openapi.jsonSampleExpandLevel=3 \
		--theme.openapi.schemaExpansionLevel=2

$(VALIDATE_DIR)/validator.js : $(SCHEMA_DIR)/schema.json $(schema_files) | $(VALIDATE_DIR)
	npx ajv compile $(foreach schema,$(schema_files),-r $(schema)) -s $(SCHEMA_DIR)/schema.json -o $(VALIDATE_DIR)/validator.js --spec=draft7 -c ajv-cli-custom -c ajv-formats --all-errors


$(SCHEMA_DIR)/%.json : schemas/%.yml | $(SCHEMA_DIR)
	# Convert YML file to JSON
	npx js-yaml $< > $@
	# Expand relative references to other schema-files to fully-qualified schema URLs
	jq '(..|objects|select(has("$$ref"))).["$$ref"] |= sub("\\.(?<n>.*)\\.yml"; "https://buehnenverein.github.io/open-repertoire\(.n).json")' $@ > $@.tmp
	mv $@.tmp $@

$(VALIDATE_DIR)/bundle.js : validate/interop.js $(VALIDATE_DIR)/validator.js
	cp validate/interop.js $(VALIDATE_DIR)/interop.js
	npx browserify $(VALIDATE_DIR)/interop.js | npx uglifyjs --mangle --compress --output $(VALIDATE_DIR)/bundle.js

$(VIEW_DIR)/bundle.js : view/interop.js | $(VIEW_DIR)
	cp view/interop.js $(VIEW_DIR)/interop.js
	npx browserify view/interop.js | npx uglifyjs --mangle --compress --output $(VIEW_DIR)/bundle.js

$(VALIDATE_DIR)/main.js : elm/src/Validate.elm $(elm_src_files) $(generated_elm_files)
	cd elm; \
	elm make src/Validate.elm --optimize --output=../$(VALIDATE_DIR)/main.js

$(VIEW_DIR)/main.js : elm/src/View.elm $(elm_src_files) $(generated_elm_files)
	cd elm; \
	elm make src/View.elm --optimize --output=../$(VIEW_DIR)/main.js

%/main.min.js : %/main.js
	npx uglifyjs $< --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | npx uglifyjs --mangle --output $@

js2e_output/src/%.elm &: $(SCHEMA_DIR)
	./js2e $(SCHEMA_DIR)

$(generated_elm_files) : elm/src/%.elm : js2e_output/src/%.elm
	mkdir -p elm/src/Data
	cp $< $@
