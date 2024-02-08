"use strict";module.exports = validate20;module.exports.default = validate20;const schema22 = {"required":["name","productions","version"],"additionalProperties":false,"type":"object","properties":{"version":{"type":"string","description":"The API version that is being used. MUST be the string \"v1\" for now.","enum":["v1"]},"name":{"type":"string","description":"The organization's name"},"address":{"type":"object","additionalProperties":false,"properties":{"postalCode":{"type":"string"},"streetAddress":{"type":"string"},"city":{"type":"string"}}},"productions":{"type":"array","description":"The collection of all productions in the repertoire.","items":{"type":"object","description":"An object containing unchanging information about the production.","additionalProperties":false,"required":["title","events"],"properties":{"title":{"type":"string","description":"The event title"},"subtitle":{"type":"string","description":"The event's optional subtitle"},"description":{"type":"string","description":"A text describing the production"},"teaser":{"type":"string","description":"A short text describing the production"},"additionalInfo":{"type":"string","description":"Additional information about the production"},"events":{"type":"array","description":"List of current events offered by the organization","items":{"type":"object","required":["startDate"],"additionalProperties":false,"properties":{"startDate":{"type":"string","description":"The start date and time of the event (in ISO 8601 date format).","format":"date-time"},"endDate":{"type":"string","description":"The end date and time of the event (in ISO 8601 date format).","format":"date-time"},"duration":{"type":"integer","format":"int64","description":"The duration of the event in minutes.","minimum":0,"maximum":9223372036854776000},"url":{"type":"string","description":"Link to further information about the event","format":"uri"},"location":{"description":"Location where this event is happening.","type":"object","additionalProperties":false,"properties":{"name":{"type":"string"},"postalCode":{"type":"string"},"streetAddress":{"type":"string"},"city":{"type":"string"},"wheelChairPlaces":{"type":"object","description":"Describes the presence of reserved spots for wheelchairs in this location, as defined by [a11yjson](https://sozialhelden.github.io/a11yjson/describing-objects/interfaces/#wheelchairplaces).","additionalProperties":false,"required":["count"],"properties":{"count":{"type":"integer","description":"The number of designated places for wheelchairs in this location."},"hasSpaceForAssistant":{"type":"boolean","description":"Is there additional space for an assistant?"},"wheelchairUserCapacity":{"type":"integer","description":"The number of people using a wheelchair that can be accomodated at the same time. Use this when there is no designated space for wheelchair users, but the number is known."}}}}},"offers":{"type":"array","items":{"type":"object","additionalProperties":false,"properties":{"name":{"type":"string","description":"A descriptive name for this offer, e.g. \"Normalpreis\", \"Ermäßigt\", \"Preisgruppe A\", usw."},"price":{"type":"number","format":"float","minimum":0,"maximum":3.402823669209385e+38},"priceCurrency":{"type":"string","description":"The currency of the price. Use standard formats: TODO"},"url":{"type":"string","description":"Ticketing link of the event","format":"uri"}}}}}}},"branch":{"type":"string","description":"The branch of theatre this production belongs to, e.g. \"Schauspiel\", \"Musiktheater\", \"Oper\", etc."},"genre":{"type":"string","description":"The genre of this production."},"accessibility":{"type":"object","additionalProperties":false,"properties":{"accessModeSufficient":{"type":"array","items":{"type":"string","description":"A list of single or combined accessModes that are sufficient to understand all the intellectual content of a resource.","enum":["auditory","tactile","textual","visual"]}},"accessibilityHazard":{"type":"array","items":{"type":"string","enum":["none","unknown","flashingHazard","motionSimulationHazard","soundHazard","noFlashingHazard","noMotionSimulationHazard","noSoundHazard","unknownFlashingHazard","unknownMotionSimulationHazard","unknownSoundHazard"]}},"accessibilitySummary":{"type":"string","description":"A human-readable summary of specific accessibility features or deficiencies of the production."}}},"participants":{"description":"List of all people contributing to and participating in the production, e.g. directors, stage designers, musical directors, performers, etc.\n\nIf multiple people perform the same role/function (e.g. there is multiple directors or multiple actors perform the same role on stage at the same time),\neach person should get their own entry in the `participants` array.","type":"array","items":{"type":"object","required":["names"],"additionalProperties":false,"properties":{"function":{"type":"string","description":"This participant's function in the production, e.g. \"Regie\", \"Dramaturgie\", or \"Schauspiel\". Can take one of the pre-defined values."},"roleName":{"type":"string","description":"The name of the role(s) this participant is performing on stage, if any."},"names":{"type":"array","items":{"type":"string"},"description":"The name(s) of the person(s) performing this function/role. Must contain at least one name. Can contain multiple names, if multiple persons are performing the same role, but not at the same time.","minItems":1}}}}}}}},"$schema":"http://json-schema.org/draft-07/schema#"};const func4 = Object.prototype.hasOwnProperty;const formats0 = require("ajv-formats/dist/formats").fullFormats["date-time"];const formats4 = require("ajv-formats/dist/formats").fullFormats.int64;const formats6 = require("ajv-formats/dist/formats").fullFormats.uri;const formats8 = require("ajv-formats/dist/formats").fullFormats.float;function validate20(data, {instancePath="", parentData, parentDataProperty, rootData=data}={}){let vErrors = null;let errors = 0;if(data && typeof data == "object" && !Array.isArray(data)){if(data.name === undefined){const err0 = {instancePath,schemaPath:"#/required",keyword:"required",params:{missingProperty: "name"},message:"must have required property '"+"name"+"'"};if(vErrors === null){vErrors = [err0];}else {vErrors.push(err0);}errors++;}if(data.productions === undefined){const err1 = {instancePath,schemaPath:"#/required",keyword:"required",params:{missingProperty: "productions"},message:"must have required property '"+"productions"+"'"};if(vErrors === null){vErrors = [err1];}else {vErrors.push(err1);}errors++;}if(data.version === undefined){const err2 = {instancePath,schemaPath:"#/required",keyword:"required",params:{missingProperty: "version"},message:"must have required property '"+"version"+"'"};if(vErrors === null){vErrors = [err2];}else {vErrors.push(err2);}errors++;}for(const key0 in data){if(!((((key0 === "version") || (key0 === "name")) || (key0 === "address")) || (key0 === "productions"))){const err3 = {instancePath,schemaPath:"#/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key0},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err3];}else {vErrors.push(err3);}errors++;}}if(data.version !== undefined){let data0 = data.version;if(typeof data0 !== "string"){const err4 = {instancePath:instancePath+"/version",schemaPath:"#/properties/version/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err4];}else {vErrors.push(err4);}errors++;}if(!(data0 === "v1")){const err5 = {instancePath:instancePath+"/version",schemaPath:"#/properties/version/enum",keyword:"enum",params:{allowedValues: schema22.properties.version.enum},message:"must be equal to one of the allowed values"};if(vErrors === null){vErrors = [err5];}else {vErrors.push(err5);}errors++;}}if(data.name !== undefined){if(typeof data.name !== "string"){const err6 = {instancePath:instancePath+"/name",schemaPath:"#/properties/name/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err6];}else {vErrors.push(err6);}errors++;}}if(data.address !== undefined){let data2 = data.address;if(data2 && typeof data2 == "object" && !Array.isArray(data2)){for(const key1 in data2){if(!(((key1 === "postalCode") || (key1 === "streetAddress")) || (key1 === "city"))){const err7 = {instancePath:instancePath+"/address",schemaPath:"#/properties/address/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key1},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err7];}else {vErrors.push(err7);}errors++;}}if(data2.postalCode !== undefined){if(typeof data2.postalCode !== "string"){const err8 = {instancePath:instancePath+"/address/postalCode",schemaPath:"#/properties/address/properties/postalCode/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err8];}else {vErrors.push(err8);}errors++;}}if(data2.streetAddress !== undefined){if(typeof data2.streetAddress !== "string"){const err9 = {instancePath:instancePath+"/address/streetAddress",schemaPath:"#/properties/address/properties/streetAddress/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err9];}else {vErrors.push(err9);}errors++;}}if(data2.city !== undefined){if(typeof data2.city !== "string"){const err10 = {instancePath:instancePath+"/address/city",schemaPath:"#/properties/address/properties/city/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err10];}else {vErrors.push(err10);}errors++;}}}else {const err11 = {instancePath:instancePath+"/address",schemaPath:"#/properties/address/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err11];}else {vErrors.push(err11);}errors++;}}if(data.productions !== undefined){let data6 = data.productions;if(Array.isArray(data6)){const len0 = data6.length;for(let i0=0; i0<len0; i0++){let data7 = data6[i0];if(data7 && typeof data7 == "object" && !Array.isArray(data7)){if(data7.title === undefined){const err12 = {instancePath:instancePath+"/productions/" + i0,schemaPath:"#/properties/productions/items/required",keyword:"required",params:{missingProperty: "title"},message:"must have required property '"+"title"+"'"};if(vErrors === null){vErrors = [err12];}else {vErrors.push(err12);}errors++;}if(data7.events === undefined){const err13 = {instancePath:instancePath+"/productions/" + i0,schemaPath:"#/properties/productions/items/required",keyword:"required",params:{missingProperty: "events"},message:"must have required property '"+"events"+"'"};if(vErrors === null){vErrors = [err13];}else {vErrors.push(err13);}errors++;}for(const key2 in data7){if(!(func4.call(schema22.properties.productions.items.properties, key2))){const err14 = {instancePath:instancePath+"/productions/" + i0,schemaPath:"#/properties/productions/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key2},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err14];}else {vErrors.push(err14);}errors++;}}if(data7.title !== undefined){if(typeof data7.title !== "string"){const err15 = {instancePath:instancePath+"/productions/" + i0+"/title",schemaPath:"#/properties/productions/items/properties/title/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err15];}else {vErrors.push(err15);}errors++;}}if(data7.subtitle !== undefined){if(typeof data7.subtitle !== "string"){const err16 = {instancePath:instancePath+"/productions/" + i0+"/subtitle",schemaPath:"#/properties/productions/items/properties/subtitle/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err16];}else {vErrors.push(err16);}errors++;}}if(data7.description !== undefined){if(typeof data7.description !== "string"){const err17 = {instancePath:instancePath+"/productions/" + i0+"/description",schemaPath:"#/properties/productions/items/properties/description/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err17];}else {vErrors.push(err17);}errors++;}}if(data7.teaser !== undefined){if(typeof data7.teaser !== "string"){const err18 = {instancePath:instancePath+"/productions/" + i0+"/teaser",schemaPath:"#/properties/productions/items/properties/teaser/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err18];}else {vErrors.push(err18);}errors++;}}if(data7.additionalInfo !== undefined){if(typeof data7.additionalInfo !== "string"){const err19 = {instancePath:instancePath+"/productions/" + i0+"/additionalInfo",schemaPath:"#/properties/productions/items/properties/additionalInfo/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err19];}else {vErrors.push(err19);}errors++;}}if(data7.events !== undefined){let data13 = data7.events;if(Array.isArray(data13)){const len1 = data13.length;for(let i1=0; i1<len1; i1++){let data14 = data13[i1];if(data14 && typeof data14 == "object" && !Array.isArray(data14)){if(data14.startDate === undefined){const err20 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1,schemaPath:"#/properties/productions/items/properties/events/items/required",keyword:"required",params:{missingProperty: "startDate"},message:"must have required property '"+"startDate"+"'"};if(vErrors === null){vErrors = [err20];}else {vErrors.push(err20);}errors++;}for(const key3 in data14){if(!((((((key3 === "startDate") || (key3 === "endDate")) || (key3 === "duration")) || (key3 === "url")) || (key3 === "location")) || (key3 === "offers"))){const err21 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1,schemaPath:"#/properties/productions/items/properties/events/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key3},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err21];}else {vErrors.push(err21);}errors++;}}if(data14.startDate !== undefined){let data15 = data14.startDate;if(typeof data15 === "string"){if(!(formats0.validate(data15))){const err22 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/startDate",schemaPath:"#/properties/productions/items/properties/events/items/properties/startDate/format",keyword:"format",params:{format: "date-time"},message:"must match format \""+"date-time"+"\""};if(vErrors === null){vErrors = [err22];}else {vErrors.push(err22);}errors++;}}else {const err23 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/startDate",schemaPath:"#/properties/productions/items/properties/events/items/properties/startDate/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err23];}else {vErrors.push(err23);}errors++;}}if(data14.endDate !== undefined){let data16 = data14.endDate;if(typeof data16 === "string"){if(!(formats0.validate(data16))){const err24 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/endDate",schemaPath:"#/properties/productions/items/properties/events/items/properties/endDate/format",keyword:"format",params:{format: "date-time"},message:"must match format \""+"date-time"+"\""};if(vErrors === null){vErrors = [err24];}else {vErrors.push(err24);}errors++;}}else {const err25 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/endDate",schemaPath:"#/properties/productions/items/properties/events/items/properties/endDate/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err25];}else {vErrors.push(err25);}errors++;}}if(data14.duration !== undefined){let data17 = data14.duration;if(!(((typeof data17 == "number") && (!(data17 % 1) && !isNaN(data17))) && (isFinite(data17)))){const err26 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/duration",schemaPath:"#/properties/productions/items/properties/events/items/properties/duration/type",keyword:"type",params:{type: "integer"},message:"must be integer"};if(vErrors === null){vErrors = [err26];}else {vErrors.push(err26);}errors++;}if((typeof data17 == "number") && (isFinite(data17))){if(data17 > 9223372036854776000 || isNaN(data17)){const err27 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/duration",schemaPath:"#/properties/productions/items/properties/events/items/properties/duration/maximum",keyword:"maximum",params:{comparison: "<=", limit: 9223372036854776000},message:"must be <= 9223372036854776000"};if(vErrors === null){vErrors = [err27];}else {vErrors.push(err27);}errors++;}if(data17 < 0 || isNaN(data17)){const err28 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/duration",schemaPath:"#/properties/productions/items/properties/events/items/properties/duration/minimum",keyword:"minimum",params:{comparison: ">=", limit: 0},message:"must be >= 0"};if(vErrors === null){vErrors = [err28];}else {vErrors.push(err28);}errors++;}if(!(formats4.validate(data17))){const err29 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/duration",schemaPath:"#/properties/productions/items/properties/events/items/properties/duration/format",keyword:"format",params:{format: "int64"},message:"must match format \""+"int64"+"\""};if(vErrors === null){vErrors = [err29];}else {vErrors.push(err29);}errors++;}}}if(data14.url !== undefined){let data18 = data14.url;if(typeof data18 === "string"){if(!(formats6(data18))){const err30 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/url",schemaPath:"#/properties/productions/items/properties/events/items/properties/url/format",keyword:"format",params:{format: "uri"},message:"must match format \""+"uri"+"\""};if(vErrors === null){vErrors = [err30];}else {vErrors.push(err30);}errors++;}}else {const err31 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/url",schemaPath:"#/properties/productions/items/properties/events/items/properties/url/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err31];}else {vErrors.push(err31);}errors++;}}if(data14.location !== undefined){let data19 = data14.location;if(data19 && typeof data19 == "object" && !Array.isArray(data19)){for(const key4 in data19){if(!(((((key4 === "name") || (key4 === "postalCode")) || (key4 === "streetAddress")) || (key4 === "city")) || (key4 === "wheelChairPlaces"))){const err32 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/location",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key4},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err32];}else {vErrors.push(err32);}errors++;}}if(data19.name !== undefined){if(typeof data19.name !== "string"){const err33 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/location/name",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/name/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err33];}else {vErrors.push(err33);}errors++;}}if(data19.postalCode !== undefined){if(typeof data19.postalCode !== "string"){const err34 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/location/postalCode",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/postalCode/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err34];}else {vErrors.push(err34);}errors++;}}if(data19.streetAddress !== undefined){if(typeof data19.streetAddress !== "string"){const err35 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/location/streetAddress",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/streetAddress/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err35];}else {vErrors.push(err35);}errors++;}}if(data19.city !== undefined){if(typeof data19.city !== "string"){const err36 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/location/city",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/city/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err36];}else {vErrors.push(err36);}errors++;}}if(data19.wheelChairPlaces !== undefined){let data24 = data19.wheelChairPlaces;if(data24 && typeof data24 == "object" && !Array.isArray(data24)){if(data24.count === undefined){const err37 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/location/wheelChairPlaces",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/required",keyword:"required",params:{missingProperty: "count"},message:"must have required property '"+"count"+"'"};if(vErrors === null){vErrors = [err37];}else {vErrors.push(err37);}errors++;}for(const key5 in data24){if(!(((key5 === "count") || (key5 === "hasSpaceForAssistant")) || (key5 === "wheelchairUserCapacity"))){const err38 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/location/wheelChairPlaces",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key5},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err38];}else {vErrors.push(err38);}errors++;}}if(data24.count !== undefined){let data25 = data24.count;if(!(((typeof data25 == "number") && (!(data25 % 1) && !isNaN(data25))) && (isFinite(data25)))){const err39 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/location/wheelChairPlaces/count",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/properties/count/type",keyword:"type",params:{type: "integer"},message:"must be integer"};if(vErrors === null){vErrors = [err39];}else {vErrors.push(err39);}errors++;}}if(data24.hasSpaceForAssistant !== undefined){if(typeof data24.hasSpaceForAssistant !== "boolean"){const err40 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/location/wheelChairPlaces/hasSpaceForAssistant",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/properties/hasSpaceForAssistant/type",keyword:"type",params:{type: "boolean"},message:"must be boolean"};if(vErrors === null){vErrors = [err40];}else {vErrors.push(err40);}errors++;}}if(data24.wheelchairUserCapacity !== undefined){let data27 = data24.wheelchairUserCapacity;if(!(((typeof data27 == "number") && (!(data27 % 1) && !isNaN(data27))) && (isFinite(data27)))){const err41 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/location/wheelChairPlaces/wheelchairUserCapacity",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/properties/wheelchairUserCapacity/type",keyword:"type",params:{type: "integer"},message:"must be integer"};if(vErrors === null){vErrors = [err41];}else {vErrors.push(err41);}errors++;}}}else {const err42 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/location/wheelChairPlaces",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err42];}else {vErrors.push(err42);}errors++;}}}else {const err43 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/location",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err43];}else {vErrors.push(err43);}errors++;}}if(data14.offers !== undefined){let data28 = data14.offers;if(Array.isArray(data28)){const len2 = data28.length;for(let i2=0; i2<len2; i2++){let data29 = data28[i2];if(data29 && typeof data29 == "object" && !Array.isArray(data29)){for(const key6 in data29){if(!((((key6 === "name") || (key6 === "price")) || (key6 === "priceCurrency")) || (key6 === "url"))){const err44 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/offers/" + i2,schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key6},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err44];}else {vErrors.push(err44);}errors++;}}if(data29.name !== undefined){if(typeof data29.name !== "string"){const err45 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/offers/" + i2+"/name",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/name/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err45];}else {vErrors.push(err45);}errors++;}}if(data29.price !== undefined){let data31 = data29.price;if((typeof data31 == "number") && (isFinite(data31))){if(data31 > 3.402823669209385e+38 || isNaN(data31)){const err46 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/offers/" + i2+"/price",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/price/maximum",keyword:"maximum",params:{comparison: "<=", limit: 3.402823669209385e+38},message:"must be <= 3.402823669209385e+38"};if(vErrors === null){vErrors = [err46];}else {vErrors.push(err46);}errors++;}if(data31 < 0 || isNaN(data31)){const err47 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/offers/" + i2+"/price",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/price/minimum",keyword:"minimum",params:{comparison: ">=", limit: 0},message:"must be >= 0"};if(vErrors === null){vErrors = [err47];}else {vErrors.push(err47);}errors++;}if(!(formats8.validate(data31))){const err48 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/offers/" + i2+"/price",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/price/format",keyword:"format",params:{format: "float"},message:"must match format \""+"float"+"\""};if(vErrors === null){vErrors = [err48];}else {vErrors.push(err48);}errors++;}}else {const err49 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/offers/" + i2+"/price",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/price/type",keyword:"type",params:{type: "number"},message:"must be number"};if(vErrors === null){vErrors = [err49];}else {vErrors.push(err49);}errors++;}}if(data29.priceCurrency !== undefined){if(typeof data29.priceCurrency !== "string"){const err50 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/offers/" + i2+"/priceCurrency",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/priceCurrency/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err50];}else {vErrors.push(err50);}errors++;}}if(data29.url !== undefined){let data33 = data29.url;if(typeof data33 === "string"){if(!(formats6(data33))){const err51 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/offers/" + i2+"/url",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/url/format",keyword:"format",params:{format: "uri"},message:"must match format \""+"uri"+"\""};if(vErrors === null){vErrors = [err51];}else {vErrors.push(err51);}errors++;}}else {const err52 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/offers/" + i2+"/url",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/url/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err52];}else {vErrors.push(err52);}errors++;}}}else {const err53 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/offers/" + i2,schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err53];}else {vErrors.push(err53);}errors++;}}}else {const err54 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1+"/offers",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err54];}else {vErrors.push(err54);}errors++;}}}else {const err55 = {instancePath:instancePath+"/productions/" + i0+"/events/" + i1,schemaPath:"#/properties/productions/items/properties/events/items/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err55];}else {vErrors.push(err55);}errors++;}}}else {const err56 = {instancePath:instancePath+"/productions/" + i0+"/events",schemaPath:"#/properties/productions/items/properties/events/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err56];}else {vErrors.push(err56);}errors++;}}if(data7.branch !== undefined){if(typeof data7.branch !== "string"){const err57 = {instancePath:instancePath+"/productions/" + i0+"/branch",schemaPath:"#/properties/productions/items/properties/branch/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err57];}else {vErrors.push(err57);}errors++;}}if(data7.genre !== undefined){if(typeof data7.genre !== "string"){const err58 = {instancePath:instancePath+"/productions/" + i0+"/genre",schemaPath:"#/properties/productions/items/properties/genre/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err58];}else {vErrors.push(err58);}errors++;}}if(data7.accessibility !== undefined){let data36 = data7.accessibility;if(data36 && typeof data36 == "object" && !Array.isArray(data36)){for(const key7 in data36){if(!(((key7 === "accessModeSufficient") || (key7 === "accessibilityHazard")) || (key7 === "accessibilitySummary"))){const err59 = {instancePath:instancePath+"/productions/" + i0+"/accessibility",schemaPath:"#/properties/productions/items/properties/accessibility/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key7},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err59];}else {vErrors.push(err59);}errors++;}}if(data36.accessModeSufficient !== undefined){let data37 = data36.accessModeSufficient;if(Array.isArray(data37)){const len3 = data37.length;for(let i3=0; i3<len3; i3++){let data38 = data37[i3];if(typeof data38 !== "string"){const err60 = {instancePath:instancePath+"/productions/" + i0+"/accessibility/accessModeSufficient/" + i3,schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessModeSufficient/items/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err60];}else {vErrors.push(err60);}errors++;}if(!((((data38 === "auditory") || (data38 === "tactile")) || (data38 === "textual")) || (data38 === "visual"))){const err61 = {instancePath:instancePath+"/productions/" + i0+"/accessibility/accessModeSufficient/" + i3,schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessModeSufficient/items/enum",keyword:"enum",params:{allowedValues: schema22.properties.productions.items.properties.accessibility.properties.accessModeSufficient.items.enum},message:"must be equal to one of the allowed values"};if(vErrors === null){vErrors = [err61];}else {vErrors.push(err61);}errors++;}}}else {const err62 = {instancePath:instancePath+"/productions/" + i0+"/accessibility/accessModeSufficient",schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessModeSufficient/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err62];}else {vErrors.push(err62);}errors++;}}if(data36.accessibilityHazard !== undefined){let data39 = data36.accessibilityHazard;if(Array.isArray(data39)){const len4 = data39.length;for(let i4=0; i4<len4; i4++){let data40 = data39[i4];if(typeof data40 !== "string"){const err63 = {instancePath:instancePath+"/productions/" + i0+"/accessibility/accessibilityHazard/" + i4,schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessibilityHazard/items/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err63];}else {vErrors.push(err63);}errors++;}if(!(((((((((((data40 === "none") || (data40 === "unknown")) || (data40 === "flashingHazard")) || (data40 === "motionSimulationHazard")) || (data40 === "soundHazard")) || (data40 === "noFlashingHazard")) || (data40 === "noMotionSimulationHazard")) || (data40 === "noSoundHazard")) || (data40 === "unknownFlashingHazard")) || (data40 === "unknownMotionSimulationHazard")) || (data40 === "unknownSoundHazard"))){const err64 = {instancePath:instancePath+"/productions/" + i0+"/accessibility/accessibilityHazard/" + i4,schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessibilityHazard/items/enum",keyword:"enum",params:{allowedValues: schema22.properties.productions.items.properties.accessibility.properties.accessibilityHazard.items.enum},message:"must be equal to one of the allowed values"};if(vErrors === null){vErrors = [err64];}else {vErrors.push(err64);}errors++;}}}else {const err65 = {instancePath:instancePath+"/productions/" + i0+"/accessibility/accessibilityHazard",schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessibilityHazard/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err65];}else {vErrors.push(err65);}errors++;}}if(data36.accessibilitySummary !== undefined){if(typeof data36.accessibilitySummary !== "string"){const err66 = {instancePath:instancePath+"/productions/" + i0+"/accessibility/accessibilitySummary",schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessibilitySummary/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err66];}else {vErrors.push(err66);}errors++;}}}else {const err67 = {instancePath:instancePath+"/productions/" + i0+"/accessibility",schemaPath:"#/properties/productions/items/properties/accessibility/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err67];}else {vErrors.push(err67);}errors++;}}if(data7.participants !== undefined){let data42 = data7.participants;if(Array.isArray(data42)){const len5 = data42.length;for(let i5=0; i5<len5; i5++){let data43 = data42[i5];if(data43 && typeof data43 == "object" && !Array.isArray(data43)){if(data43.names === undefined){const err68 = {instancePath:instancePath+"/productions/" + i0+"/participants/" + i5,schemaPath:"#/properties/productions/items/properties/participants/items/required",keyword:"required",params:{missingProperty: "names"},message:"must have required property '"+"names"+"'"};if(vErrors === null){vErrors = [err68];}else {vErrors.push(err68);}errors++;}for(const key8 in data43){if(!(((key8 === "function") || (key8 === "roleName")) || (key8 === "names"))){const err69 = {instancePath:instancePath+"/productions/" + i0+"/participants/" + i5,schemaPath:"#/properties/productions/items/properties/participants/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key8},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err69];}else {vErrors.push(err69);}errors++;}}if(data43.function !== undefined){if(typeof data43.function !== "string"){const err70 = {instancePath:instancePath+"/productions/" + i0+"/participants/" + i5+"/function",schemaPath:"#/properties/productions/items/properties/participants/items/properties/function/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err70];}else {vErrors.push(err70);}errors++;}}if(data43.roleName !== undefined){if(typeof data43.roleName !== "string"){const err71 = {instancePath:instancePath+"/productions/" + i0+"/participants/" + i5+"/roleName",schemaPath:"#/properties/productions/items/properties/participants/items/properties/roleName/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err71];}else {vErrors.push(err71);}errors++;}}if(data43.names !== undefined){let data46 = data43.names;if(Array.isArray(data46)){if(data46.length < 1){const err72 = {instancePath:instancePath+"/productions/" + i0+"/participants/" + i5+"/names",schemaPath:"#/properties/productions/items/properties/participants/items/properties/names/minItems",keyword:"minItems",params:{limit: 1},message:"must NOT have fewer than 1 items"};if(vErrors === null){vErrors = [err72];}else {vErrors.push(err72);}errors++;}const len6 = data46.length;for(let i6=0; i6<len6; i6++){if(typeof data46[i6] !== "string"){const err73 = {instancePath:instancePath+"/productions/" + i0+"/participants/" + i5+"/names/" + i6,schemaPath:"#/properties/productions/items/properties/participants/items/properties/names/items/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err73];}else {vErrors.push(err73);}errors++;}}}else {const err74 = {instancePath:instancePath+"/productions/" + i0+"/participants/" + i5+"/names",schemaPath:"#/properties/productions/items/properties/participants/items/properties/names/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err74];}else {vErrors.push(err74);}errors++;}}}else {const err75 = {instancePath:instancePath+"/productions/" + i0+"/participants/" + i5,schemaPath:"#/properties/productions/items/properties/participants/items/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err75];}else {vErrors.push(err75);}errors++;}}}else {const err76 = {instancePath:instancePath+"/productions/" + i0+"/participants",schemaPath:"#/properties/productions/items/properties/participants/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err76];}else {vErrors.push(err76);}errors++;}}}else {const err77 = {instancePath:instancePath+"/productions/" + i0,schemaPath:"#/properties/productions/items/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err77];}else {vErrors.push(err77);}errors++;}}}else {const err78 = {instancePath:instancePath+"/productions",schemaPath:"#/properties/productions/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err78];}else {vErrors.push(err78);}errors++;}}}else {const err79 = {instancePath,schemaPath:"#/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err79];}else {vErrors.push(err79);}errors++;}validate20.errors = vErrors;return errors === 0;}