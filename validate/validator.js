"use strict";module.exports = validate20;module.exports.default = validate20;const schema22 = {"required":["name","productions","events"],"additionalProperties":false,"type":"object","properties":{"name":{"type":"string","description":"The organization's name"},"address":{"type":"object","additionalProperties":false,"properties":{"postalCode":{"type":"string"},"streetAddress":{"type":"string"},"city":{"type":"string"}}},"productions":{"type":"object","description":"The collection of all productions in the repertoire. The value must be an object that maps from a unique production ID to a `Production` object describing the production.","additionalProperties":{"type":"object","description":"An object containing unchanging information about the production.","required":["title","description"],"properties":{"title":{"type":"string","description":"The event title"},"subtitle":{"type":"string","description":"The event's optional subtitle"},"description":{"type":"string"},"accessibility":{"type":"object","additionalProperties":false,"properties":{"accessModeSufficient":{"type":"array","items":{"type":"string","description":"A list of single or combined accessModes that are sufficient to understand all the intellectual content of a resource.","enum":["auditory","tactile","textual","visual"]}},"accessibilityHazard":{"type":"array","items":{"type":"string","enum":["none","unknown","flashingHazard","motionSimulationHazard","soundHazard","noFlashingHazard","noMotionSimulationHazard","noSoundHazard","unknownFlashingHazard","unknownMotionSimulationHazard","unknownSoundHazard"]}},"accessibilitySummary":{"type":"string","description":"A human-readable summary of specific accessibility features or deficiencies"}}},"location":{"description":"Location where this event is happening.","type":"object","additionalProperties":false,"properties":{"name":{"type":"string"},"postalCode":{"type":"string"},"streetAddress":{"type":"string"},"city":{"type":"string"}}},"contributors":{"description":"List of people contributing to the production, e.g. director(s), stage designer(s), musical director(s), etc.","type":"array","items":{"type":"object","additionalProperties":false,"properties":{"name":{"type":"string","description":"The person's name"},"role":{"type":"string","description":"This person's role in the production, e.g. \"Regie\" or \"Dramaturgie\". For performers, this should be the name of the role(s) they are performing."}}}},"performers":{"description":"List of people performing in the production.","type":"array","items":{"type":"object","additionalProperties":false,"properties":{"name":{"type":"string","description":"The person's name"},"role":{"type":"string","description":"This person's role in the production, e.g. \"Regie\" or \"Dramaturgie\". For performers, this should be the name of the role(s) they are performing."}}}}}}},"events":{"type":"array","description":"List of current events offered by the organization","items":{"type":"object","required":["productionId","startDate"],"additionalProperties":false,"properties":{"productionId":{"type":"string","description":"Reference to the production that this event belongs to. This value MUST match one of the keys in the top-level `productions` object."},"startDate":{"type":"string","description":"The start date and time of the event (in ISO 8601 date format).","format":"date-time"},"endDate":{"type":"string","description":"The end date and time of the event (in ISO 8601 date format).","format":"date-time"},"duration":{"type":"integer","format":"int64","description":"The duration of the event in seconds.","minimum":-9223372036854776000,"maximum":9223372036854776000},"url":{"type":"string","description":"Link to further information about the event","format":"uri"},"offers":{"type":"array","items":{"type":"object","additionalProperties":false,"properties":{"name":{"type":"string","description":"A descriptive name for this offer, e.g. \"Normalpreis\", \"Ermäßigt\", \"Preisgruppe A\", usw."},"price":{"type":"number","format":"float","minimum":-3.402823669209385e+38,"maximum":3.402823669209385e+38},"priceCurrency":{"type":"string","description":"The currency of the price. Use standard formats: TODO"},"url":{"type":"string","description":"Ticketing link of the event","format":"uri"}}}}}}}},"$schema":"http://json-schema.org/draft-07/schema#"};const formats0 = require("ajv-formats/dist/formats").fullFormats["date-time"];const formats4 = require("ajv-formats/dist/formats").fullFormats.int64;const formats6 = require("ajv-formats/dist/formats").fullFormats.uri;const formats8 = require("ajv-formats/dist/formats").fullFormats.float;function validate20(data, {instancePath="", parentData, parentDataProperty, rootData=data}={}){let vErrors = null;let errors = 0;if(data && typeof data == "object" && !Array.isArray(data)){if(data.name === undefined){const err0 = {instancePath,schemaPath:"#/required",keyword:"required",params:{missingProperty: "name"},message:"must have required property '"+"name"+"'"};if(vErrors === null){vErrors = [err0];}else {vErrors.push(err0);}errors++;}if(data.productions === undefined){const err1 = {instancePath,schemaPath:"#/required",keyword:"required",params:{missingProperty: "productions"},message:"must have required property '"+"productions"+"'"};if(vErrors === null){vErrors = [err1];}else {vErrors.push(err1);}errors++;}if(data.events === undefined){const err2 = {instancePath,schemaPath:"#/required",keyword:"required",params:{missingProperty: "events"},message:"must have required property '"+"events"+"'"};if(vErrors === null){vErrors = [err2];}else {vErrors.push(err2);}errors++;}for(const key0 in data){if(!((((key0 === "name") || (key0 === "address")) || (key0 === "productions")) || (key0 === "events"))){const err3 = {instancePath,schemaPath:"#/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key0},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err3];}else {vErrors.push(err3);}errors++;}}if(data.name !== undefined){if(typeof data.name !== "string"){const err4 = {instancePath:instancePath+"/name",schemaPath:"#/properties/name/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err4];}else {vErrors.push(err4);}errors++;}}if(data.address !== undefined){let data1 = data.address;if(data1 && typeof data1 == "object" && !Array.isArray(data1)){for(const key1 in data1){if(!(((key1 === "postalCode") || (key1 === "streetAddress")) || (key1 === "city"))){const err5 = {instancePath:instancePath+"/address",schemaPath:"#/properties/address/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key1},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err5];}else {vErrors.push(err5);}errors++;}}if(data1.postalCode !== undefined){if(typeof data1.postalCode !== "string"){const err6 = {instancePath:instancePath+"/address/postalCode",schemaPath:"#/properties/address/properties/postalCode/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err6];}else {vErrors.push(err6);}errors++;}}if(data1.streetAddress !== undefined){if(typeof data1.streetAddress !== "string"){const err7 = {instancePath:instancePath+"/address/streetAddress",schemaPath:"#/properties/address/properties/streetAddress/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err7];}else {vErrors.push(err7);}errors++;}}if(data1.city !== undefined){if(typeof data1.city !== "string"){const err8 = {instancePath:instancePath+"/address/city",schemaPath:"#/properties/address/properties/city/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err8];}else {vErrors.push(err8);}errors++;}}}else {const err9 = {instancePath:instancePath+"/address",schemaPath:"#/properties/address/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err9];}else {vErrors.push(err9);}errors++;}}if(data.productions !== undefined){let data5 = data.productions;if(data5 && typeof data5 == "object" && !Array.isArray(data5)){for(const key2 in data5){let data6 = data5[key2];if(data6 && typeof data6 == "object" && !Array.isArray(data6)){if(data6.title === undefined){const err10 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1"),schemaPath:"#/properties/productions/additionalProperties/required",keyword:"required",params:{missingProperty: "title"},message:"must have required property '"+"title"+"'"};if(vErrors === null){vErrors = [err10];}else {vErrors.push(err10);}errors++;}if(data6.description === undefined){const err11 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1"),schemaPath:"#/properties/productions/additionalProperties/required",keyword:"required",params:{missingProperty: "description"},message:"must have required property '"+"description"+"'"};if(vErrors === null){vErrors = [err11];}else {vErrors.push(err11);}errors++;}if(data6.title !== undefined){if(typeof data6.title !== "string"){const err12 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/title",schemaPath:"#/properties/productions/additionalProperties/properties/title/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err12];}else {vErrors.push(err12);}errors++;}}if(data6.subtitle !== undefined){if(typeof data6.subtitle !== "string"){const err13 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/subtitle",schemaPath:"#/properties/productions/additionalProperties/properties/subtitle/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err13];}else {vErrors.push(err13);}errors++;}}if(data6.description !== undefined){if(typeof data6.description !== "string"){const err14 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/description",schemaPath:"#/properties/productions/additionalProperties/properties/description/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err14];}else {vErrors.push(err14);}errors++;}}if(data6.accessibility !== undefined){let data10 = data6.accessibility;if(data10 && typeof data10 == "object" && !Array.isArray(data10)){for(const key3 in data10){if(!(((key3 === "accessModeSufficient") || (key3 === "accessibilityHazard")) || (key3 === "accessibilitySummary"))){const err15 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/accessibility",schemaPath:"#/properties/productions/additionalProperties/properties/accessibility/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key3},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err15];}else {vErrors.push(err15);}errors++;}}if(data10.accessModeSufficient !== undefined){let data11 = data10.accessModeSufficient;if(Array.isArray(data11)){const len0 = data11.length;for(let i0=0; i0<len0; i0++){let data12 = data11[i0];if(typeof data12 !== "string"){const err16 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/accessibility/accessModeSufficient/" + i0,schemaPath:"#/properties/productions/additionalProperties/properties/accessibility/properties/accessModeSufficient/items/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err16];}else {vErrors.push(err16);}errors++;}if(!((((data12 === "auditory") || (data12 === "tactile")) || (data12 === "textual")) || (data12 === "visual"))){const err17 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/accessibility/accessModeSufficient/" + i0,schemaPath:"#/properties/productions/additionalProperties/properties/accessibility/properties/accessModeSufficient/items/enum",keyword:"enum",params:{allowedValues: schema22.properties.productions.additionalProperties.properties.accessibility.properties.accessModeSufficient.items.enum},message:"must be equal to one of the allowed values"};if(vErrors === null){vErrors = [err17];}else {vErrors.push(err17);}errors++;}}}else {const err18 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/accessibility/accessModeSufficient",schemaPath:"#/properties/productions/additionalProperties/properties/accessibility/properties/accessModeSufficient/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err18];}else {vErrors.push(err18);}errors++;}}if(data10.accessibilityHazard !== undefined){let data13 = data10.accessibilityHazard;if(Array.isArray(data13)){const len1 = data13.length;for(let i1=0; i1<len1; i1++){let data14 = data13[i1];if(typeof data14 !== "string"){const err19 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/accessibility/accessibilityHazard/" + i1,schemaPath:"#/properties/productions/additionalProperties/properties/accessibility/properties/accessibilityHazard/items/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err19];}else {vErrors.push(err19);}errors++;}if(!(((((((((((data14 === "none") || (data14 === "unknown")) || (data14 === "flashingHazard")) || (data14 === "motionSimulationHazard")) || (data14 === "soundHazard")) || (data14 === "noFlashingHazard")) || (data14 === "noMotionSimulationHazard")) || (data14 === "noSoundHazard")) || (data14 === "unknownFlashingHazard")) || (data14 === "unknownMotionSimulationHazard")) || (data14 === "unknownSoundHazard"))){const err20 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/accessibility/accessibilityHazard/" + i1,schemaPath:"#/properties/productions/additionalProperties/properties/accessibility/properties/accessibilityHazard/items/enum",keyword:"enum",params:{allowedValues: schema22.properties.productions.additionalProperties.properties.accessibility.properties.accessibilityHazard.items.enum},message:"must be equal to one of the allowed values"};if(vErrors === null){vErrors = [err20];}else {vErrors.push(err20);}errors++;}}}else {const err21 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/accessibility/accessibilityHazard",schemaPath:"#/properties/productions/additionalProperties/properties/accessibility/properties/accessibilityHazard/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err21];}else {vErrors.push(err21);}errors++;}}if(data10.accessibilitySummary !== undefined){if(typeof data10.accessibilitySummary !== "string"){const err22 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/accessibility/accessibilitySummary",schemaPath:"#/properties/productions/additionalProperties/properties/accessibility/properties/accessibilitySummary/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err22];}else {vErrors.push(err22);}errors++;}}}else {const err23 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/accessibility",schemaPath:"#/properties/productions/additionalProperties/properties/accessibility/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err23];}else {vErrors.push(err23);}errors++;}}if(data6.location !== undefined){let data16 = data6.location;if(data16 && typeof data16 == "object" && !Array.isArray(data16)){for(const key4 in data16){if(!((((key4 === "name") || (key4 === "postalCode")) || (key4 === "streetAddress")) || (key4 === "city"))){const err24 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/location",schemaPath:"#/properties/productions/additionalProperties/properties/location/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key4},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err24];}else {vErrors.push(err24);}errors++;}}if(data16.name !== undefined){if(typeof data16.name !== "string"){const err25 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/location/name",schemaPath:"#/properties/productions/additionalProperties/properties/location/properties/name/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err25];}else {vErrors.push(err25);}errors++;}}if(data16.postalCode !== undefined){if(typeof data16.postalCode !== "string"){const err26 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/location/postalCode",schemaPath:"#/properties/productions/additionalProperties/properties/location/properties/postalCode/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err26];}else {vErrors.push(err26);}errors++;}}if(data16.streetAddress !== undefined){if(typeof data16.streetAddress !== "string"){const err27 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/location/streetAddress",schemaPath:"#/properties/productions/additionalProperties/properties/location/properties/streetAddress/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err27];}else {vErrors.push(err27);}errors++;}}if(data16.city !== undefined){if(typeof data16.city !== "string"){const err28 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/location/city",schemaPath:"#/properties/productions/additionalProperties/properties/location/properties/city/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err28];}else {vErrors.push(err28);}errors++;}}}else {const err29 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/location",schemaPath:"#/properties/productions/additionalProperties/properties/location/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err29];}else {vErrors.push(err29);}errors++;}}if(data6.contributors !== undefined){let data21 = data6.contributors;if(Array.isArray(data21)){const len2 = data21.length;for(let i2=0; i2<len2; i2++){let data22 = data21[i2];if(data22 && typeof data22 == "object" && !Array.isArray(data22)){for(const key5 in data22){if(!((key5 === "name") || (key5 === "role"))){const err30 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/contributors/" + i2,schemaPath:"#/properties/productions/additionalProperties/properties/contributors/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key5},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err30];}else {vErrors.push(err30);}errors++;}}if(data22.name !== undefined){if(typeof data22.name !== "string"){const err31 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/contributors/" + i2+"/name",schemaPath:"#/properties/productions/additionalProperties/properties/contributors/items/properties/name/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err31];}else {vErrors.push(err31);}errors++;}}if(data22.role !== undefined){if(typeof data22.role !== "string"){const err32 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/contributors/" + i2+"/role",schemaPath:"#/properties/productions/additionalProperties/properties/contributors/items/properties/role/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err32];}else {vErrors.push(err32);}errors++;}}}else {const err33 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/contributors/" + i2,schemaPath:"#/properties/productions/additionalProperties/properties/contributors/items/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err33];}else {vErrors.push(err33);}errors++;}}}else {const err34 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/contributors",schemaPath:"#/properties/productions/additionalProperties/properties/contributors/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err34];}else {vErrors.push(err34);}errors++;}}if(data6.performers !== undefined){let data25 = data6.performers;if(Array.isArray(data25)){const len3 = data25.length;for(let i3=0; i3<len3; i3++){let data26 = data25[i3];if(data26 && typeof data26 == "object" && !Array.isArray(data26)){for(const key6 in data26){if(!((key6 === "name") || (key6 === "role"))){const err35 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/performers/" + i3,schemaPath:"#/properties/productions/additionalProperties/properties/performers/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key6},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err35];}else {vErrors.push(err35);}errors++;}}if(data26.name !== undefined){if(typeof data26.name !== "string"){const err36 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/performers/" + i3+"/name",schemaPath:"#/properties/productions/additionalProperties/properties/performers/items/properties/name/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err36];}else {vErrors.push(err36);}errors++;}}if(data26.role !== undefined){if(typeof data26.role !== "string"){const err37 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/performers/" + i3+"/role",schemaPath:"#/properties/productions/additionalProperties/properties/performers/items/properties/role/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err37];}else {vErrors.push(err37);}errors++;}}}else {const err38 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/performers/" + i3,schemaPath:"#/properties/productions/additionalProperties/properties/performers/items/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err38];}else {vErrors.push(err38);}errors++;}}}else {const err39 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1")+"/performers",schemaPath:"#/properties/productions/additionalProperties/properties/performers/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err39];}else {vErrors.push(err39);}errors++;}}}else {const err40 = {instancePath:instancePath+"/productions/" + key2.replace(/~/g, "~0").replace(/\//g, "~1"),schemaPath:"#/properties/productions/additionalProperties/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err40];}else {vErrors.push(err40);}errors++;}}}else {const err41 = {instancePath:instancePath+"/productions",schemaPath:"#/properties/productions/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err41];}else {vErrors.push(err41);}errors++;}}if(data.events !== undefined){let data29 = data.events;if(Array.isArray(data29)){const len4 = data29.length;for(let i4=0; i4<len4; i4++){let data30 = data29[i4];if(data30 && typeof data30 == "object" && !Array.isArray(data30)){if(data30.productionId === undefined){const err42 = {instancePath:instancePath+"/events/" + i4,schemaPath:"#/properties/events/items/required",keyword:"required",params:{missingProperty: "productionId"},message:"must have required property '"+"productionId"+"'"};if(vErrors === null){vErrors = [err42];}else {vErrors.push(err42);}errors++;}if(data30.startDate === undefined){const err43 = {instancePath:instancePath+"/events/" + i4,schemaPath:"#/properties/events/items/required",keyword:"required",params:{missingProperty: "startDate"},message:"must have required property '"+"startDate"+"'"};if(vErrors === null){vErrors = [err43];}else {vErrors.push(err43);}errors++;}for(const key7 in data30){if(!((((((key7 === "productionId") || (key7 === "startDate")) || (key7 === "endDate")) || (key7 === "duration")) || (key7 === "url")) || (key7 === "offers"))){const err44 = {instancePath:instancePath+"/events/" + i4,schemaPath:"#/properties/events/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key7},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err44];}else {vErrors.push(err44);}errors++;}}if(data30.productionId !== undefined){if(typeof data30.productionId !== "string"){const err45 = {instancePath:instancePath+"/events/" + i4+"/productionId",schemaPath:"#/properties/events/items/properties/productionId/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err45];}else {vErrors.push(err45);}errors++;}}if(data30.startDate !== undefined){let data32 = data30.startDate;if(typeof data32 === "string"){if(!(formats0.validate(data32))){const err46 = {instancePath:instancePath+"/events/" + i4+"/startDate",schemaPath:"#/properties/events/items/properties/startDate/format",keyword:"format",params:{format: "date-time"},message:"must match format \""+"date-time"+"\""};if(vErrors === null){vErrors = [err46];}else {vErrors.push(err46);}errors++;}}else {const err47 = {instancePath:instancePath+"/events/" + i4+"/startDate",schemaPath:"#/properties/events/items/properties/startDate/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err47];}else {vErrors.push(err47);}errors++;}}if(data30.endDate !== undefined){let data33 = data30.endDate;if(typeof data33 === "string"){if(!(formats0.validate(data33))){const err48 = {instancePath:instancePath+"/events/" + i4+"/endDate",schemaPath:"#/properties/events/items/properties/endDate/format",keyword:"format",params:{format: "date-time"},message:"must match format \""+"date-time"+"\""};if(vErrors === null){vErrors = [err48];}else {vErrors.push(err48);}errors++;}}else {const err49 = {instancePath:instancePath+"/events/" + i4+"/endDate",schemaPath:"#/properties/events/items/properties/endDate/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err49];}else {vErrors.push(err49);}errors++;}}if(data30.duration !== undefined){let data34 = data30.duration;if(!(((typeof data34 == "number") && (!(data34 % 1) && !isNaN(data34))) && (isFinite(data34)))){const err50 = {instancePath:instancePath+"/events/" + i4+"/duration",schemaPath:"#/properties/events/items/properties/duration/type",keyword:"type",params:{type: "integer"},message:"must be integer"};if(vErrors === null){vErrors = [err50];}else {vErrors.push(err50);}errors++;}if((typeof data34 == "number") && (isFinite(data34))){if(data34 > 9223372036854776000 || isNaN(data34)){const err51 = {instancePath:instancePath+"/events/" + i4+"/duration",schemaPath:"#/properties/events/items/properties/duration/maximum",keyword:"maximum",params:{comparison: "<=", limit: 9223372036854776000},message:"must be <= 9223372036854776000"};if(vErrors === null){vErrors = [err51];}else {vErrors.push(err51);}errors++;}if(data34 < -9223372036854776000 || isNaN(data34)){const err52 = {instancePath:instancePath+"/events/" + i4+"/duration",schemaPath:"#/properties/events/items/properties/duration/minimum",keyword:"minimum",params:{comparison: ">=", limit: -9223372036854776000},message:"must be >= -9223372036854776000"};if(vErrors === null){vErrors = [err52];}else {vErrors.push(err52);}errors++;}if(!(formats4.validate(data34))){const err53 = {instancePath:instancePath+"/events/" + i4+"/duration",schemaPath:"#/properties/events/items/properties/duration/format",keyword:"format",params:{format: "int64"},message:"must match format \""+"int64"+"\""};if(vErrors === null){vErrors = [err53];}else {vErrors.push(err53);}errors++;}}}if(data30.url !== undefined){let data35 = data30.url;if(typeof data35 === "string"){if(!(formats6(data35))){const err54 = {instancePath:instancePath+"/events/" + i4+"/url",schemaPath:"#/properties/events/items/properties/url/format",keyword:"format",params:{format: "uri"},message:"must match format \""+"uri"+"\""};if(vErrors === null){vErrors = [err54];}else {vErrors.push(err54);}errors++;}}else {const err55 = {instancePath:instancePath+"/events/" + i4+"/url",schemaPath:"#/properties/events/items/properties/url/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err55];}else {vErrors.push(err55);}errors++;}}if(data30.offers !== undefined){let data36 = data30.offers;if(Array.isArray(data36)){const len5 = data36.length;for(let i5=0; i5<len5; i5++){let data37 = data36[i5];if(data37 && typeof data37 == "object" && !Array.isArray(data37)){for(const key8 in data37){if(!((((key8 === "name") || (key8 === "price")) || (key8 === "priceCurrency")) || (key8 === "url"))){const err56 = {instancePath:instancePath+"/events/" + i4+"/offers/" + i5,schemaPath:"#/properties/events/items/properties/offers/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key8},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err56];}else {vErrors.push(err56);}errors++;}}if(data37.name !== undefined){if(typeof data37.name !== "string"){const err57 = {instancePath:instancePath+"/events/" + i4+"/offers/" + i5+"/name",schemaPath:"#/properties/events/items/properties/offers/items/properties/name/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err57];}else {vErrors.push(err57);}errors++;}}if(data37.price !== undefined){let data39 = data37.price;if((typeof data39 == "number") && (isFinite(data39))){if(data39 > 3.402823669209385e+38 || isNaN(data39)){const err58 = {instancePath:instancePath+"/events/" + i4+"/offers/" + i5+"/price",schemaPath:"#/properties/events/items/properties/offers/items/properties/price/maximum",keyword:"maximum",params:{comparison: "<=", limit: 3.402823669209385e+38},message:"must be <= 3.402823669209385e+38"};if(vErrors === null){vErrors = [err58];}else {vErrors.push(err58);}errors++;}if(data39 < -3.402823669209385e+38 || isNaN(data39)){const err59 = {instancePath:instancePath+"/events/" + i4+"/offers/" + i5+"/price",schemaPath:"#/properties/events/items/properties/offers/items/properties/price/minimum",keyword:"minimum",params:{comparison: ">=", limit: -3.402823669209385e+38},message:"must be >= -3.402823669209385e+38"};if(vErrors === null){vErrors = [err59];}else {vErrors.push(err59);}errors++;}if(!(formats8.validate(data39))){const err60 = {instancePath:instancePath+"/events/" + i4+"/offers/" + i5+"/price",schemaPath:"#/properties/events/items/properties/offers/items/properties/price/format",keyword:"format",params:{format: "float"},message:"must match format \""+"float"+"\""};if(vErrors === null){vErrors = [err60];}else {vErrors.push(err60);}errors++;}}else {const err61 = {instancePath:instancePath+"/events/" + i4+"/offers/" + i5+"/price",schemaPath:"#/properties/events/items/properties/offers/items/properties/price/type",keyword:"type",params:{type: "number"},message:"must be number"};if(vErrors === null){vErrors = [err61];}else {vErrors.push(err61);}errors++;}}if(data37.priceCurrency !== undefined){if(typeof data37.priceCurrency !== "string"){const err62 = {instancePath:instancePath+"/events/" + i4+"/offers/" + i5+"/priceCurrency",schemaPath:"#/properties/events/items/properties/offers/items/properties/priceCurrency/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err62];}else {vErrors.push(err62);}errors++;}}if(data37.url !== undefined){let data41 = data37.url;if(typeof data41 === "string"){if(!(formats6(data41))){const err63 = {instancePath:instancePath+"/events/" + i4+"/offers/" + i5+"/url",schemaPath:"#/properties/events/items/properties/offers/items/properties/url/format",keyword:"format",params:{format: "uri"},message:"must match format \""+"uri"+"\""};if(vErrors === null){vErrors = [err63];}else {vErrors.push(err63);}errors++;}}else {const err64 = {instancePath:instancePath+"/events/" + i4+"/offers/" + i5+"/url",schemaPath:"#/properties/events/items/properties/offers/items/properties/url/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err64];}else {vErrors.push(err64);}errors++;}}}else {const err65 = {instancePath:instancePath+"/events/" + i4+"/offers/" + i5,schemaPath:"#/properties/events/items/properties/offers/items/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err65];}else {vErrors.push(err65);}errors++;}}}else {const err66 = {instancePath:instancePath+"/events/" + i4+"/offers",schemaPath:"#/properties/events/items/properties/offers/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err66];}else {vErrors.push(err66);}errors++;}}}else {const err67 = {instancePath:instancePath+"/events/" + i4,schemaPath:"#/properties/events/items/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err67];}else {vErrors.push(err67);}errors++;}}}else {const err68 = {instancePath:instancePath+"/events",schemaPath:"#/properties/events/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err68];}else {vErrors.push(err68);}errors++;}}}else {const err69 = {instancePath,schemaPath:"#/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err69];}else {vErrors.push(err69);}errors++;}validate20.errors = vErrors;return errors === 0;}