!function r(i,a,o){function p(t,e){if(!a[t]){if(!i[t]){var s="function"==typeof require&&require;if(!e&&s)return s(t,!0);if(n)return n(t,!0);throw(e=new Error("Cannot find module '"+t+"'")).code="MODULE_NOT_FOUND",e}s=a[t]={exports:{}},i[t][0].call(s.exports,function(e){return p(i[t][1][e]||e)},s,s.exports,r,i,a,o)}return a[t].exports}for(var n="function"==typeof require&&require,e=0;e<o.length;e++)p(o[e]);return p}({1:[function(e,t,s){"use strict";function r(e,t){return{validate:e,compare:t}}Object.defineProperty(s,"__esModule",{value:!0}),s.formatNames=s.fastFormats=s.fullFormats=void 0,s.fullFormats={date:r(o,p),time:r(d,c),"date-time":r(function(e){e=e.split(m);return 2===e.length&&o(e[0])&&d(e[1],!0)},u),duration:/^P(?!$)((\d+Y)?(\d+M)?(\d+D)?(T(?=\d)(\d+H)?(\d+M)?(\d+S)?)?|(\d+W)?)$/,uri:function(e){return l.test(e)&&h.test(e)},"uri-reference":/^(?:[a-z][a-z0-9+\-.]*:)?(?:\/?\/(?:(?:[a-z0-9\-._~!$&'()*+,;=:]|%[0-9a-f]{2})*@)?(?:\[(?:(?:(?:(?:[0-9a-f]{1,4}:){6}|::(?:[0-9a-f]{1,4}:){5}|(?:[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){4}|(?:(?:[0-9a-f]{1,4}:){0,1}[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){3}|(?:(?:[0-9a-f]{1,4}:){0,2}[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){2}|(?:(?:[0-9a-f]{1,4}:){0,3}[0-9a-f]{1,4})?::[0-9a-f]{1,4}:|(?:(?:[0-9a-f]{1,4}:){0,4}[0-9a-f]{1,4})?::)(?:[0-9a-f]{1,4}:[0-9a-f]{1,4}|(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?))|(?:(?:[0-9a-f]{1,4}:){0,5}[0-9a-f]{1,4})?::[0-9a-f]{1,4}|(?:(?:[0-9a-f]{1,4}:){0,6}[0-9a-f]{1,4})?::)|[Vv][0-9a-f]+\.[a-z0-9\-._~!$&'()*+,;=:]+)\]|(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)|(?:[a-z0-9\-._~!$&'"()*+,;=]|%[0-9a-f]{2})*)(?::\d*)?(?:\/(?:[a-z0-9\-._~!$&'"()*+,;=:@]|%[0-9a-f]{2})*)*|\/(?:(?:[a-z0-9\-._~!$&'"()*+,;=:@]|%[0-9a-f]{2})+(?:\/(?:[a-z0-9\-._~!$&'"()*+,;=:@]|%[0-9a-f]{2})*)*)?|(?:[a-z0-9\-._~!$&'"()*+,;=:@]|%[0-9a-f]{2})+(?:\/(?:[a-z0-9\-._~!$&'"()*+,;=:@]|%[0-9a-f]{2})*)*)?(?:\?(?:[a-z0-9\-._~!$&'"()*+,;=:@/?]|%[0-9a-f]{2})*)?(?:#(?:[a-z0-9\-._~!$&'"()*+,;=:@/?]|%[0-9a-f]{2})*)?$/i,"uri-template":/^(?:(?:[^\x00-\x20"'<>%\\^`{|}]|%[0-9a-f]{2})|\{[+#./;?&=,!@|]?(?:[a-z0-9_]|%[0-9a-f]{2})+(?::[1-9][0-9]{0,3}|\*)?(?:,(?:[a-z0-9_]|%[0-9a-f]{2})+(?::[1-9][0-9]{0,3}|\*)?)*\})*$/i,url:/^(?:https?|ftp):\/\/(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z0-9\u{00a1}-\u{ffff}]+-)*[a-z0-9\u{00a1}-\u{ffff}]+)(?:\.(?:[a-z0-9\u{00a1}-\u{ffff}]+-)*[a-z0-9\u{00a1}-\u{ffff}]+)*(?:\.(?:[a-z\u{00a1}-\u{ffff}]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?$/iu,email:/^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$/i,hostname:/^(?=.{1,253}\.?$)[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?(?:\.[a-z0-9](?:[-0-9a-z]{0,61}[0-9a-z])?)*\.?$/i,ipv4:/^(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)$/,ipv6:/^((([0-9a-f]{1,4}:){7}([0-9a-f]{1,4}|:))|(([0-9a-f]{1,4}:){6}(:[0-9a-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9a-f]{1,4}:){5}(((:[0-9a-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9a-f]{1,4}:){4}(((:[0-9a-f]{1,4}){1,3})|((:[0-9a-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){3}(((:[0-9a-f]{1,4}){1,4})|((:[0-9a-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){2}(((:[0-9a-f]{1,4}){1,5})|((:[0-9a-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){1}(((:[0-9a-f]{1,4}){1,6})|((:[0-9a-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9a-f]{1,4}){1,7})|((:[0-9a-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))$/i,regex:function(e){if(P.test(e))return!1;try{return new RegExp(e),!0}catch(e){return!1}},uuid:/^(?:urn:uuid:)?[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}$/i,"json-pointer":/^(?:\/(?:[^~/]|~0|~1)*)*$/,"json-pointer-uri-fragment":/^#(?:\/(?:[a-z0-9_\-.!$&'()*+,;:=@]|%[0-9a-f]{2}|~0|~1)*)*$/i,"relative-json-pointer":/^(?:0|[1-9][0-9]*)(?:#|(?:\/(?:[^~/]|~0|~1)*)*)$/,byte:function(e){return y.lastIndex=0,y.test(e)},int32:{type:"number",validate:function(e){return Number.isInteger(e)&&e<=g&&e>=f}},int64:{type:"number",validate:function(e){return Number.isInteger(e)}},float:{type:"number",validate:v},double:{type:"number",validate:v},password:!0,binary:!0},s.fastFormats={...s.fullFormats,date:r(/^\d\d\d\d-[0-1]\d-[0-3]\d$/,p),time:r(/^(?:[0-2]\d:[0-5]\d:[0-5]\d|23:59:60)(?:\.\d+)?(?:z|[+-]\d\d(?::?\d\d)?)?$/i,c),"date-time":r(/^\d\d\d\d-[0-1]\d-[0-3]\d[t\s](?:[0-2]\d:[0-5]\d:[0-5]\d|23:59:60)(?:\.\d+)?(?:z|[+-]\d\d(?::?\d\d)?)$/i,u),uri:/^(?:[a-z][a-z0-9+\-.]*:)(?:\/?\/)?[^\s]*$/i,"uri-reference":/^(?:(?:[a-z][a-z0-9+\-.]*:)?\/?\/)?(?:[^\\\s#][^\s#]*)?(?:#[^\\\s]*)?$/i,email:/^[a-z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?(?:\.[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?)*$/i},s.formatNames=Object.keys(s.fullFormats);const i=/^(\d\d\d\d)-(\d\d)-(\d\d)$/,a=[0,31,28,31,30,31,30,31,31,30,31,30,31];function o(e){var t,s,e=i.exec(e);return!!e&&(t=+e[1],s=+e[2],e=+e[3],1<=s)&&s<=12&&1<=e&&e<=(2!=s||(e=t)%4!=0||e%100==0&&e%400!=0?a[s]:29)}function p(e,t){if(e&&t)return t<e?1:e<t?-1:0}const n=/^(\d\d):(\d\d):(\d\d)(\.\d+)?(z|[+-]\d\d(?::?\d\d)?)?$/i;function d(e,t){var s,r,i,e=n.exec(e);return!!e&&(s=+e[1],r=+e[2],i=+e[3],e=e[5],s<=23&&r<=59&&i<=59||23==s&&59==r&&60==i)&&(!t||""!==e)}function c(e,t){if(e&&t){var s=n.exec(e),r=n.exec(t);if(s&&r)return e=s[1]+s[2]+s[3]+(s[4]||""),(t=r[1]+r[2]+r[3]+(r[4]||""))<e?1:e<t?-1:0}}const m=/t|\s/i;function u(e,t){if(e&&t){var[e,s]=e.split(m),[t,r]=t.split(m),e=p(e,t);if(void 0!==e)return e||c(s,r)}}const l=/\/|:/,h=/^(?:[a-z][a-z0-9+\-.]*:)(?:\/?\/(?:(?:[a-z0-9\-._~!$&'()*+,;=:]|%[0-9a-f]{2})*@)?(?:\[(?:(?:(?:(?:[0-9a-f]{1,4}:){6}|::(?:[0-9a-f]{1,4}:){5}|(?:[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){4}|(?:(?:[0-9a-f]{1,4}:){0,1}[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){3}|(?:(?:[0-9a-f]{1,4}:){0,2}[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){2}|(?:(?:[0-9a-f]{1,4}:){0,3}[0-9a-f]{1,4})?::[0-9a-f]{1,4}:|(?:(?:[0-9a-f]{1,4}:){0,4}[0-9a-f]{1,4})?::)(?:[0-9a-f]{1,4}:[0-9a-f]{1,4}|(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?))|(?:(?:[0-9a-f]{1,4}:){0,5}[0-9a-f]{1,4})?::[0-9a-f]{1,4}|(?:(?:[0-9a-f]{1,4}:){0,6}[0-9a-f]{1,4})?::)|[Vv][0-9a-f]+\.[a-z0-9\-._~!$&'()*+,;=:]+)\]|(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)|(?:[a-z0-9\-._~!$&'()*+,;=]|%[0-9a-f]{2})*)(?::\d*)?(?:\/(?:[a-z0-9\-._~!$&'()*+,;=:@]|%[0-9a-f]{2})*)*|\/(?:(?:[a-z0-9\-._~!$&'()*+,;=:@]|%[0-9a-f]{2})+(?:\/(?:[a-z0-9\-._~!$&'()*+,;=:@]|%[0-9a-f]{2})*)*)?|(?:[a-z0-9\-._~!$&'()*+,;=:@]|%[0-9a-f]{2})+(?:\/(?:[a-z0-9\-._~!$&'()*+,;=:@]|%[0-9a-f]{2})*)*)(?:\?(?:[a-z0-9\-._~!$&'()*+,;=:@/?]|%[0-9a-f]{2})*)?(?:#(?:[a-z0-9\-._~!$&'()*+,;=:@/?]|%[0-9a-f]{2})*)?$/i;const y=/^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$/gm;const f=-(2**31),g=2**31-1;function v(){return!0}const P=/[^\\]\\Z/},{}],2:[function(e,t,s){let r=e("./validator.js");var i=Elm.Main.init({node:document.getElementById("app")});i.ports&&i.ports.sendData&&i.ports.sendData.subscribe(function(e){r(e,{allErrors:!0})?i.ports.receiveResult.send({valid:!0}):(i.ports.receiveResult.send({valid:!1,errors:r.errors}),console.log(r.errors))})},{"./validator.js":3}],3:[function(e,t,s){"use strict";t.exports=Te,t.exports.default=Te;const je={required:["name","productions","version"],additionalProperties:!1,type:"object",properties:{version:{type:"string",description:'The API version that is being used. MUST be the string "v1" for now.',enum:["v1"]},name:{type:"string",description:"The organization's name"},address:{type:"object",additionalProperties:!1,properties:{postalCode:{type:"string"},streetAddress:{type:"string"},city:{type:"string"}}},productions:{type:"array",description:"The collection of all productions in the repertoire. The value must be an object that maps from a unique production ID to a `Production` object describing the production.",items:{type:"object",description:"An object containing unchanging information about the production.",additionalProperties:!1,required:["title","description","events"],properties:{title:{type:"string",description:"The event title"},subtitle:{type:"string",description:"The event's optional subtitle"},description:{type:"string"},events:{type:"array",description:"List of current events offered by the organization",items:{type:"object",required:["startDate"],additionalProperties:!1,properties:{startDate:{type:"string",description:"The start date and time of the event (in ISO 8601 date format).",format:"date-time"},endDate:{type:"string",description:"The end date and time of the event (in ISO 8601 date format).",format:"date-time"},duration:{type:"integer",format:"int64",description:"The duration of the event in seconds.",minimum:-0x8000000000000000,maximum:0x8000000000000000},url:{type:"string",description:"Link to further information about the event",format:"uri"},location:{description:"Location where this event is happening.",type:"object",additionalProperties:!1,properties:{name:{type:"string"},postalCode:{type:"string"},streetAddress:{type:"string"},city:{type:"string"},wheelChairPlaces:{type:"array",description:"Describes the presence of reserved spots for wheelchairs in this location, as defined by [a11yjson](https://sozialhelden.github.io/a11yjson/describing-objects/interfaces/#wheelchairplaces).",items:{type:"object",additionalProperties:!1,description:"Describes the presence of reserved spots for wheelchairs, as defined by [a11yjson](https://sozialhelden.github.io/a11yjson/describing-objects/interfaces/#wheelchairplaces).",required:["count"],properties:{count:{type:"integer",description:"The number of designated places for wheelchairs in this location."},hasSpaceForAssistant:{type:"boolean",description:"Is there additional space for an assistant?"},wheelchairUserCapacity:{type:"integer",description:"The number of people using a wheelchair that can be accomodated at the same time. Use this when there is no designated space for wheelchair users, but the number is known."}}}}}},offers:{type:"array",items:{type:"object",additionalProperties:!1,properties:{name:{type:"string",description:'A descriptive name for this offer, e.g. "Normalpreis", "Ermäßigt", "Preisgruppe A", usw.'},price:{type:"number",format:"float",minimum:-3402823669209385e23,maximum:3402823669209385e23},priceCurrency:{type:"string",description:"The currency of the price. Use standard formats: TODO"},url:{type:"string",description:"Ticketing link of the event",format:"uri"}}}}}}},branch:{type:"string",description:'The branch of theatre this production belongs to, e.g. "Schauspiel", "Musiktheater", "Oper", etc.'},genre:{type:"string",description:"The genre of this production."},accessibility:{type:"object",additionalProperties:!1,properties:{accessModeSufficient:{type:"array",items:{type:"string",description:"A list of single or combined accessModes that are sufficient to understand all the intellectual content of a resource.",enum:["auditory","tactile","textual","visual"]}},accessibilityHazard:{type:"array",items:{type:"string",enum:["none","unknown","flashingHazard","motionSimulationHazard","soundHazard","noFlashingHazard","noMotionSimulationHazard","noSoundHazard","unknownFlashingHazard","unknownMotionSimulationHazard","unknownSoundHazard"]}},accessibilitySummary:{type:"string",description:"A human-readable summary of specific accessibility features or deficiencies"}}},contributors:{description:"List of people contributing to the production, e.g. director(s), stage designer(s), musical director(s), etc.",type:"array",items:{type:"object",additionalProperties:!1,properties:{name:{type:"string",description:"The person's name"},role:{type:"string",description:'This person\'s role in the production, e.g. "Regie" or "Dramaturgie". For performers, this should be the name of the role(s) they are performing.'}}}},performers:{description:"List of people performing in the production.",type:"array",items:{type:"object",additionalProperties:!1,properties:{name:{type:"string",description:"The person's name"},role:{type:"string",description:'This person\'s role in the production, e.g. "Regie" or "Dramaturgie". For performers, this should be the name of the role(s) they are performing.'}}}}}}}},$schema:"http://json-schema.org/draft-07/schema#"},Ae=Object.prototype.hasOwnProperty,$e=e("ajv-formats/dist/formats").fullFormats["date-time"],Ce=e("ajv-formats/dist/formats").fullFormats.int64,Se=e("ajv-formats/dist/formats").fullFormats.uri,qe=e("ajv-formats/dist/formats").fullFormats.float;function Te(e,{instancePath:r="",rootData:F=e}={}){let i=null,a=0;if(e&&"object"==typeof e&&!Array.isArray(e)){var M;void 0===e.name&&(s={instancePath:r,schemaPath:"#/required",keyword:"required",params:{missingProperty:"name"},message:"must have required property 'name'"},null===i?i=[s]:i.push(s),a++),void 0===e.productions&&(s={instancePath:r,schemaPath:"#/required",keyword:"required",params:{missingProperty:"productions"},message:"must have required property 'productions'"},null===i?i=[s]:i.push(s),a++),void 0===e.version&&(s={instancePath:r,schemaPath:"#/required",keyword:"required",params:{missingProperty:"version"},message:"must have required property 'version'"},null===i?i=[s]:i.push(s),a++);for(const H in e)"version"!==H&&"name"!==H&&"address"!==H&&"productions"!==H&&(M={instancePath:r,schemaPath:"#/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:H},message:"must NOT have additional properties"},null===i?i=[M]:i.push(M),a++);if(void 0!==e.version&&("string"!=typeof(s=e.version)&&(t={instancePath:r+"/version",schemaPath:"#/properties/version/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[t]:i.push(t),a++),"v1"!==s)&&(t={instancePath:r+"/version",schemaPath:"#/properties/version/enum",keyword:"enum",params:{allowedValues:je.properties.version.enum},message:"must be equal to one of the allowed values"},null===i?i=[t]:i.push(t),a++),void 0!==e.name&&"string"!=typeof e.name&&(s={instancePath:r+"/name",schemaPath:"#/properties/name/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[s]:i.push(s),a++),void 0!==e.address){var O,t=e.address;if(t&&"object"==typeof t&&!Array.isArray(t)){for(const ge in t)"postalCode"!==ge&&"streetAddress"!==ge&&"city"!==ge&&(O={instancePath:r+"/address",schemaPath:"#/properties/address/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:ge},message:"must NOT have additional properties"},null===i?i=[O]:i.push(O),a++);void 0!==t.postalCode&&"string"!=typeof t.postalCode&&(s={instancePath:r+"/address/postalCode",schemaPath:"#/properties/address/properties/postalCode/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[s]:i.push(s),a++),void 0!==t.streetAddress&&"string"!=typeof t.streetAddress&&(s={instancePath:r+"/address/streetAddress",schemaPath:"#/properties/address/properties/streetAddress/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[s]:i.push(s),a++),void 0!==t.city&&"string"!=typeof t.city&&(s={instancePath:r+"/address/city",schemaPath:"#/properties/address/properties/city/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[s]:i.push(s),a++)}else{t={instancePath:r+"/address",schemaPath:"#/properties/address/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[t]:i.push(t),a++}}if(void 0!==e.productions){var U=e.productions;if(Array.isArray(U)){var I=U.length;for(let s=0;s<I;s++){var o,E,p,n,d=U[s];if(d&&"object"==typeof d&&!Array.isArray(d)){void 0===d.title&&(o={instancePath:r+"/productions/"+s,schemaPath:"#/properties/productions/items/required",keyword:"required",params:{missingProperty:"title"},message:"must have required property 'title'"},null===i?i=[o]:i.push(o),a++),void 0===d.description&&(o={instancePath:r+"/productions/"+s,schemaPath:"#/properties/productions/items/required",keyword:"required",params:{missingProperty:"description"},message:"must have required property 'description'"},null===i?i=[o]:i.push(o),a++),void 0===d.events&&(p={instancePath:r+"/productions/"+s,schemaPath:"#/properties/productions/items/required",keyword:"required",params:{missingProperty:"events"},message:"must have required property 'events'"},null===i?i=[p]:i.push(p),a++);for(const ve in d)Ae.call(je.properties.productions.items.properties,ve)||(E={instancePath:r+"/productions/"+s,schemaPath:"#/properties/productions/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:ve},message:"must NOT have additional properties"},null===i?i=[E]:i.push(E),a++);if(void 0!==d.title&&"string"!=typeof d.title&&(p={instancePath:r+"/productions/"+s+"/title",schemaPath:"#/properties/productions/items/properties/title/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[p]:i.push(p),a++),void 0!==d.subtitle&&"string"!=typeof d.subtitle&&(n={instancePath:r+"/productions/"+s+"/subtitle",schemaPath:"#/properties/productions/items/properties/subtitle/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[n]:i.push(n),a++),void 0!==d.description&&"string"!=typeof d.description&&(n={instancePath:r+"/productions/"+s+"/description",schemaPath:"#/properties/productions/items/properties/description/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[n]:i.push(n),a++),void 0!==d.events){var L=d.events;if(Array.isArray(L)){var R=L.length;for(let t=0;t<R;t++){var V,Z,c,m,u,l,h=L[t];if(h&&"object"==typeof h&&!Array.isArray(h)){void 0===h.startDate&&(Z={instancePath:r+"/productions/"+s+"/events/"+t,schemaPath:"#/properties/productions/items/properties/events/items/required",keyword:"required",params:{missingProperty:"startDate"},message:"must have required property 'startDate'"},null===i?i=[Z]:i.push(Z),a++);for(const _ in h)"startDate"!==_&&"endDate"!==_&&"duration"!==_&&"url"!==_&&"location"!==_&&"offers"!==_&&(V={instancePath:r+"/productions/"+s+"/events/"+t,schemaPath:"#/properties/productions/items/properties/events/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:_},message:"must NOT have additional properties"},null===i?i=[V]:i.push(V),a++);if(void 0!==h.startDate&&("string"==typeof(Z=h.startDate)?$e.validate(Z)||(c={instancePath:r+"/productions/"+s+"/events/"+t+"/startDate",schemaPath:"#/properties/productions/items/properties/events/items/properties/startDate/format",keyword:"format",params:{format:"date-time"},message:'must match format "date-time"'},null===i?i=[c]:i.push(c),a++):(c={instancePath:r+"/productions/"+s+"/events/"+t+"/startDate",schemaPath:"#/properties/productions/items/properties/events/items/properties/startDate/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[c]:i.push(c),a++)),void 0!==h.endDate&&("string"==typeof(m=h.endDate)?$e.validate(m)||(m={instancePath:r+"/productions/"+s+"/events/"+t+"/endDate",schemaPath:"#/properties/productions/items/properties/events/items/properties/endDate/format",keyword:"format",params:{format:"date-time"},message:'must match format "date-time"'},null===i?i=[m]:i.push(m),a++):(m={instancePath:r+"/productions/"+s+"/events/"+t+"/endDate",schemaPath:"#/properties/productions/items/properties/events/items/properties/endDate/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[m]:i.push(m),a++)),void 0!==h.duration&&(("number"!=typeof(m=h.duration)||m%1||isNaN(m)||!isFinite(m))&&(u={instancePath:r+"/productions/"+s+"/events/"+t+"/duration",schemaPath:"#/properties/productions/items/properties/events/items/properties/duration/type",keyword:"type",params:{type:"integer"},message:"must be integer"},null===i?i=[u]:i.push(u),a++),"number"==typeof m)&&isFinite(m)&&((0x8000000000000000<m||isNaN(m))&&(u={instancePath:r+"/productions/"+s+"/events/"+t+"/duration",schemaPath:"#/properties/productions/items/properties/events/items/properties/duration/maximum",keyword:"maximum",params:{comparison:"<=",limit:0x8000000000000000},message:"must be <= 9223372036854776000"},null===i?i=[u]:i.push(u),a++),(m<-0x8000000000000000||isNaN(m))&&(l={instancePath:r+"/productions/"+s+"/events/"+t+"/duration",schemaPath:"#/properties/productions/items/properties/events/items/properties/duration/minimum",keyword:"minimum",params:{comparison:">=",limit:-0x8000000000000000},message:"must be >= -9223372036854776000"},null===i?i=[l]:i.push(l),a++),Ce.validate(m)||(l={instancePath:r+"/productions/"+s+"/events/"+t+"/duration",schemaPath:"#/properties/productions/items/properties/events/items/properties/duration/format",keyword:"format",params:{format:"int64"},message:'must match format "int64"'},null===i?i=[l]:i.push(l),a++)),void 0!==h.url&&("string"==typeof(g=h.url)?Se(g)||(g={instancePath:r+"/productions/"+s+"/events/"+t+"/url",schemaPath:"#/properties/productions/items/properties/events/items/properties/url/format",keyword:"format",params:{format:"uri"},message:'must match format "uri"'},null===i?i=[g]:i.push(g),a++):(g={instancePath:r+"/productions/"+s+"/events/"+t+"/url",schemaPath:"#/properties/productions/items/properties/events/items/properties/url/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[g]:i.push(g),a++)),void 0!==h.location){var B,y,f,g=h.location;if(g&&"object"==typeof g&&!Array.isArray(g)){for(const x in g)"name"!==x&&"postalCode"!==x&&"streetAddress"!==x&&"city"!==x&&"wheelChairPlaces"!==x&&(B={instancePath:r+"/productions/"+s+"/events/"+t+"/location",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:x},message:"must NOT have additional properties"},null===i?i=[B]:i.push(B),a++);if(void 0!==g.name&&"string"!=typeof g.name&&(y={instancePath:r+"/productions/"+s+"/events/"+t+"/location/name",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/name/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[y]:i.push(y),a++),void 0!==g.postalCode&&"string"!=typeof g.postalCode&&(y={instancePath:r+"/productions/"+s+"/events/"+t+"/location/postalCode",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/postalCode/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[y]:i.push(y),a++),void 0!==g.streetAddress&&"string"!=typeof g.streetAddress&&(f={instancePath:r+"/productions/"+s+"/events/"+t+"/location/streetAddress",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/streetAddress/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[f]:i.push(f),a++),void 0!==g.city&&"string"!=typeof g.city&&(f={instancePath:r+"/productions/"+s+"/events/"+t+"/location/city",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/city/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[f]:i.push(f),a++),void 0!==g.wheelChairPlaces){var W=g.wheelChairPlaces;if(Array.isArray(W)){var Y=W.length;for(let e=0;e<Y;e++){var G,v,P,b=W[e];if(b&&"object"==typeof b&&!Array.isArray(b)){void 0===b.count&&(v={instancePath:r+"/productions/"+s+"/events/"+t+"/location/wheelChairPlaces/"+e,schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/items/required",keyword:"required",params:{missingProperty:"count"},message:"must have required property 'count'"},null===i?i=[v]:i.push(v),a++);for(const Pe in b)"count"!==Pe&&"hasSpaceForAssistant"!==Pe&&"wheelchairUserCapacity"!==Pe&&(G={instancePath:r+"/productions/"+s+"/events/"+t+"/location/wheelChairPlaces/"+e,schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:Pe},message:"must NOT have additional properties"},null===i?i=[G]:i.push(G),a++);void 0!==b.count&&("number"!=typeof(v=b.count)||v%1||isNaN(v)||!isFinite(v))&&(P={instancePath:r+"/productions/"+s+"/events/"+t+"/location/wheelChairPlaces/"+e+"/count",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/items/properties/count/type",keyword:"type",params:{type:"integer"},message:"must be integer"},null===i?i=[P]:i.push(P),a++),void 0!==b.hasSpaceForAssistant&&"boolean"!=typeof b.hasSpaceForAssistant&&(P={instancePath:r+"/productions/"+s+"/events/"+t+"/location/wheelChairPlaces/"+e+"/hasSpaceForAssistant",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/items/properties/hasSpaceForAssistant/type",keyword:"type",params:{type:"boolean"},message:"must be boolean"},null===i?i=[P]:i.push(P),a++),void 0!==b.wheelchairUserCapacity&&("number"!=typeof(b=b.wheelchairUserCapacity)||b%1||isNaN(b)||!isFinite(b))&&(b={instancePath:r+"/productions/"+s+"/events/"+t+"/location/wheelChairPlaces/"+e+"/wheelchairUserCapacity",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/items/properties/wheelchairUserCapacity/type",keyword:"type",params:{type:"integer"},message:"must be integer"},null===i?i=[b]:i.push(b),a++)}else{b={instancePath:r+"/productions/"+s+"/events/"+t+"/location/wheelChairPlaces/"+e,schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/items/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[b]:i.push(b),a++}}}else{var J={instancePath:r+"/productions/"+s+"/events/"+t+"/location/wheelChairPlaces",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/type",keyword:"type",params:{type:"array"},message:"must be array"};null===i?i=[J]:i.push(J),a++}}}else{J={instancePath:r+"/productions/"+s+"/events/"+t+"/location",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[J]:i.push(J),a++}}if(void 0!==h.offers){var K=h.offers;if(Array.isArray(K)){var Q=K.length;for(let e=0;e<Q;e++){var X,w,z,k,ee,j=K[e];if(j&&"object"==typeof j&&!Array.isArray(j)){for(const be in j)"name"!==be&&"price"!==be&&"priceCurrency"!==be&&"url"!==be&&(X={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e,schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:be},message:"must NOT have additional properties"},null===i?i=[X]:i.push(X),a++);void 0!==j.name&&"string"!=typeof j.name&&(w={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e+"/name",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/name/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[w]:i.push(w),a++),void 0!==j.price&&("number"==typeof(w=j.price)&&isFinite(w)?((3402823669209385e23<w||isNaN(w))&&(z={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e+"/price",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/price/maximum",keyword:"maximum",params:{comparison:"<=",limit:3402823669209385e23},message:"must be <= 3.402823669209385e+38"},null===i?i=[z]:i.push(z),a++),(w<-3402823669209385e23||isNaN(w))&&(z={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e+"/price",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/price/minimum",keyword:"minimum",params:{comparison:">=",limit:-3402823669209385e23},message:"must be >= -3.402823669209385e+38"},null===i?i=[z]:i.push(z),a++),qe.validate(w)||(k={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e+"/price",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/price/format",keyword:"format",params:{format:"float"},message:'must match format "float"'},null===i?i=[k]:i.push(k),a++)):(k={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e+"/price",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/price/type",keyword:"type",params:{type:"number"},message:"must be number"},null===i?i=[k]:i.push(k),a++)),void 0!==j.priceCurrency&&"string"!=typeof j.priceCurrency&&(ee={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e+"/priceCurrency",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/priceCurrency/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[ee]:i.push(ee),a++),void 0!==j.url&&("string"==typeof(ee=j.url)?Se(ee)||(j={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e+"/url",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/url/format",keyword:"format",params:{format:"uri"},message:'must match format "uri"'},null===i?i=[j]:i.push(j),a++):(j={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e+"/url",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/url/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[j]:i.push(j),a++))}else{j={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e,schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[j]:i.push(j),a++}}}else{h={instancePath:r+"/productions/"+s+"/events/"+t+"/offers",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/type",keyword:"type",params:{type:"array"},message:"must be array"};null===i?i=[h]:i.push(h),a++}}}else{h={instancePath:r+"/productions/"+s+"/events/"+t,schemaPath:"#/properties/productions/items/properties/events/items/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[h]:i.push(h),a++}}}else{var te={instancePath:r+"/productions/"+s+"/events",schemaPath:"#/properties/productions/items/properties/events/type",keyword:"type",params:{type:"array"},message:"must be array"};null===i?i=[te]:i.push(te),a++}}if(void 0!==d.branch&&"string"!=typeof d.branch&&(te={instancePath:r+"/productions/"+s+"/branch",schemaPath:"#/properties/productions/items/properties/branch/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[te]:i.push(te),a++),void 0!==d.genre&&"string"!=typeof d.genre&&(A={instancePath:r+"/productions/"+s+"/genre",schemaPath:"#/properties/productions/items/properties/genre/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[A]:i.push(A),a++),void 0!==d.accessibility){var se,A=d.accessibility;if(A&&"object"==typeof A&&!Array.isArray(A)){for(const we in A)"accessModeSufficient"!==we&&"accessibilityHazard"!==we&&"accessibilitySummary"!==we&&(se={instancePath:r+"/productions/"+s+"/accessibility",schemaPath:"#/properties/productions/items/properties/accessibility/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:we},message:"must NOT have additional properties"},null===i?i=[se]:i.push(se),a++);if(void 0!==A.accessModeSufficient){var re=A.accessModeSufficient;if(Array.isArray(re)){var ie=re.length;for(let e=0;e<ie;e++){var $,ae=re[e];"string"!=typeof ae&&($={instancePath:r+"/productions/"+s+"/accessibility/accessModeSufficient/"+e,schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessModeSufficient/items/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[$]:i.push($),a++),"auditory"!==ae&&"tactile"!==ae&&"textual"!==ae&&"visual"!==ae&&($={instancePath:r+"/productions/"+s+"/accessibility/accessModeSufficient/"+e,schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessModeSufficient/items/enum",keyword:"enum",params:{allowedValues:je.properties.productions.items.properties.accessibility.properties.accessModeSufficient.items.enum},message:"must be equal to one of the allowed values"},null===i?i=[$]:i.push($),a++)}}else{var oe={instancePath:r+"/productions/"+s+"/accessibility/accessModeSufficient",schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessModeSufficient/type",keyword:"type",params:{type:"array"},message:"must be array"};null===i?i=[oe]:i.push(oe),a++}}if(void 0!==A.accessibilityHazard){var pe=A.accessibilityHazard;if(Array.isArray(pe)){var ne=pe.length;for(let e=0;e<ne;e++){var C,S=pe[e];"string"!=typeof S&&(C={instancePath:r+"/productions/"+s+"/accessibility/accessibilityHazard/"+e,schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessibilityHazard/items/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[C]:i.push(C),a++),"none"!==S&&"unknown"!==S&&"flashingHazard"!==S&&"motionSimulationHazard"!==S&&"soundHazard"!==S&&"noFlashingHazard"!==S&&"noMotionSimulationHazard"!==S&&"noSoundHazard"!==S&&"unknownFlashingHazard"!==S&&"unknownMotionSimulationHazard"!==S&&"unknownSoundHazard"!==S&&(C={instancePath:r+"/productions/"+s+"/accessibility/accessibilityHazard/"+e,schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessibilityHazard/items/enum",keyword:"enum",params:{allowedValues:je.properties.productions.items.properties.accessibility.properties.accessibilityHazard.items.enum},message:"must be equal to one of the allowed values"},null===i?i=[C]:i.push(C),a++)}}else{oe={instancePath:r+"/productions/"+s+"/accessibility/accessibilityHazard",schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessibilityHazard/type",keyword:"type",params:{type:"array"},message:"must be array"};null===i?i=[oe]:i.push(oe),a++}}void 0!==A.accessibilitySummary&&"string"!=typeof A.accessibilitySummary&&(de={instancePath:r+"/productions/"+s+"/accessibility/accessibilitySummary",schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessibilitySummary/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[de]:i.push(de),a++)}else{var de={instancePath:r+"/productions/"+s+"/accessibility",schemaPath:"#/properties/productions/items/properties/accessibility/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[de]:i.push(de),a++}}if(void 0!==d.contributors){var ce=d.contributors;if(Array.isArray(ce)){var me=ce.length;for(let e=0;e<me;e++){var ue,q,T=ce[e];if(T&&"object"==typeof T&&!Array.isArray(T)){for(const ze in T)"name"!==ze&&"role"!==ze&&(ue={instancePath:r+"/productions/"+s+"/contributors/"+e,schemaPath:"#/properties/productions/items/properties/contributors/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:ze},message:"must NOT have additional properties"},null===i?i=[ue]:i.push(ue),a++);void 0!==T.name&&"string"!=typeof T.name&&(q={instancePath:r+"/productions/"+s+"/contributors/"+e+"/name",schemaPath:"#/properties/productions/items/properties/contributors/items/properties/name/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[q]:i.push(q),a++),void 0!==T.role&&"string"!=typeof T.role&&(q={instancePath:r+"/productions/"+s+"/contributors/"+e+"/role",schemaPath:"#/properties/productions/items/properties/contributors/items/properties/role/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[q]:i.push(q),a++)}else{T={instancePath:r+"/productions/"+s+"/contributors/"+e,schemaPath:"#/properties/productions/items/properties/contributors/items/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[T]:i.push(T),a++}}}else{var le={instancePath:r+"/productions/"+s+"/contributors",schemaPath:"#/properties/productions/items/properties/contributors/type",keyword:"type",params:{type:"array"},message:"must be array"};null===i?i=[le]:i.push(le),a++}}if(void 0!==d.performers){var he=d.performers;if(Array.isArray(he)){var ye=he.length;for(let e=0;e<ye;e++){var fe,D,N=he[e];if(N&&"object"==typeof N&&!Array.isArray(N)){for(const ke in N)"name"!==ke&&"role"!==ke&&(fe={instancePath:r+"/productions/"+s+"/performers/"+e,schemaPath:"#/properties/productions/items/properties/performers/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:ke},message:"must NOT have additional properties"},null===i?i=[fe]:i.push(fe),a++);void 0!==N.name&&"string"!=typeof N.name&&(D={instancePath:r+"/productions/"+s+"/performers/"+e+"/name",schemaPath:"#/properties/productions/items/properties/performers/items/properties/name/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[D]:i.push(D),a++),void 0!==N.role&&"string"!=typeof N.role&&(D={instancePath:r+"/productions/"+s+"/performers/"+e+"/role",schemaPath:"#/properties/productions/items/properties/performers/items/properties/role/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[D]:i.push(D),a++)}else{N={instancePath:r+"/productions/"+s+"/performers/"+e,schemaPath:"#/properties/productions/items/properties/performers/items/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[N]:i.push(N),a++}}}else{le={instancePath:r+"/productions/"+s+"/performers",schemaPath:"#/properties/productions/items/properties/performers/type",keyword:"type",params:{type:"array"},message:"must be array"};null===i?i=[le]:i.push(le),a++}}}else{d={instancePath:r+"/productions/"+s,schemaPath:"#/properties/productions/items/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[d]:i.push(d),a++}}}else{var s={instancePath:r+"/productions",schemaPath:"#/properties/productions/type",keyword:"type",params:{type:"array"},message:"must be array"};null===i?i=[s]:i.push(s),a++}}}else{t={instancePath:r,schemaPath:"#/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[t]:i.push(t),a++}return Te.errors=i,0===a}},{"ajv-formats/dist/formats":1}]},{},[2]);