!function r(i,a,o){function p(t,e){if(!a[t]){if(!i[t]){var s="function"==typeof require&&require;if(!e&&s)return s(t,!0);if(n)return n(t,!0);throw(e=new Error("Cannot find module '"+t+"'")).code="MODULE_NOT_FOUND",e}s=a[t]={exports:{}},i[t][0].call(s.exports,function(e){return p(i[t][1][e]||e)},s,s.exports,r,i,a,o)}return a[t].exports}for(var n="function"==typeof require&&require,e=0;e<o.length;e++)p(o[e]);return p}({1:[function(e,t,s){"use strict";function r(e,t){return{validate:e,compare:t}}Object.defineProperty(s,"__esModule",{value:!0}),s.formatNames=s.fastFormats=s.fullFormats=void 0,s.fullFormats={date:r(o,p),time:r(d,c),"date-time":r(function(e){e=e.split(m);return 2===e.length&&o(e[0])&&d(e[1],!0)},u),duration:/^P(?!$)((\d+Y)?(\d+M)?(\d+D)?(T(?=\d)(\d+H)?(\d+M)?(\d+S)?)?|(\d+W)?)$/,uri:function(e){return l.test(e)&&h.test(e)},"uri-reference":/^(?:[a-z][a-z0-9+\-.]*:)?(?:\/?\/(?:(?:[a-z0-9\-._~!$&'()*+,;=:]|%[0-9a-f]{2})*@)?(?:\[(?:(?:(?:(?:[0-9a-f]{1,4}:){6}|::(?:[0-9a-f]{1,4}:){5}|(?:[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){4}|(?:(?:[0-9a-f]{1,4}:){0,1}[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){3}|(?:(?:[0-9a-f]{1,4}:){0,2}[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){2}|(?:(?:[0-9a-f]{1,4}:){0,3}[0-9a-f]{1,4})?::[0-9a-f]{1,4}:|(?:(?:[0-9a-f]{1,4}:){0,4}[0-9a-f]{1,4})?::)(?:[0-9a-f]{1,4}:[0-9a-f]{1,4}|(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?))|(?:(?:[0-9a-f]{1,4}:){0,5}[0-9a-f]{1,4})?::[0-9a-f]{1,4}|(?:(?:[0-9a-f]{1,4}:){0,6}[0-9a-f]{1,4})?::)|[Vv][0-9a-f]+\.[a-z0-9\-._~!$&'()*+,;=:]+)\]|(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)|(?:[a-z0-9\-._~!$&'"()*+,;=]|%[0-9a-f]{2})*)(?::\d*)?(?:\/(?:[a-z0-9\-._~!$&'"()*+,;=:@]|%[0-9a-f]{2})*)*|\/(?:(?:[a-z0-9\-._~!$&'"()*+,;=:@]|%[0-9a-f]{2})+(?:\/(?:[a-z0-9\-._~!$&'"()*+,;=:@]|%[0-9a-f]{2})*)*)?|(?:[a-z0-9\-._~!$&'"()*+,;=:@]|%[0-9a-f]{2})+(?:\/(?:[a-z0-9\-._~!$&'"()*+,;=:@]|%[0-9a-f]{2})*)*)?(?:\?(?:[a-z0-9\-._~!$&'"()*+,;=:@/?]|%[0-9a-f]{2})*)?(?:#(?:[a-z0-9\-._~!$&'"()*+,;=:@/?]|%[0-9a-f]{2})*)?$/i,"uri-template":/^(?:(?:[^\x00-\x20"'<>%\\^`{|}]|%[0-9a-f]{2})|\{[+#./;?&=,!@|]?(?:[a-z0-9_]|%[0-9a-f]{2})+(?::[1-9][0-9]{0,3}|\*)?(?:,(?:[a-z0-9_]|%[0-9a-f]{2})+(?::[1-9][0-9]{0,3}|\*)?)*\})*$/i,url:/^(?:https?|ftp):\/\/(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z0-9\u{00a1}-\u{ffff}]+-)*[a-z0-9\u{00a1}-\u{ffff}]+)(?:\.(?:[a-z0-9\u{00a1}-\u{ffff}]+-)*[a-z0-9\u{00a1}-\u{ffff}]+)*(?:\.(?:[a-z\u{00a1}-\u{ffff}]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?$/iu,email:/^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$/i,hostname:/^(?=.{1,253}\.?$)[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?(?:\.[a-z0-9](?:[-0-9a-z]{0,61}[0-9a-z])?)*\.?$/i,ipv4:/^(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)$/,ipv6:/^((([0-9a-f]{1,4}:){7}([0-9a-f]{1,4}|:))|(([0-9a-f]{1,4}:){6}(:[0-9a-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9a-f]{1,4}:){5}(((:[0-9a-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9a-f]{1,4}:){4}(((:[0-9a-f]{1,4}){1,3})|((:[0-9a-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){3}(((:[0-9a-f]{1,4}){1,4})|((:[0-9a-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){2}(((:[0-9a-f]{1,4}){1,5})|((:[0-9a-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){1}(((:[0-9a-f]{1,4}){1,6})|((:[0-9a-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9a-f]{1,4}){1,7})|((:[0-9a-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))$/i,regex:function(e){if(P.test(e))return!1;try{return new RegExp(e),!0}catch(e){return!1}},uuid:/^(?:urn:uuid:)?[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}$/i,"json-pointer":/^(?:\/(?:[^~/]|~0|~1)*)*$/,"json-pointer-uri-fragment":/^#(?:\/(?:[a-z0-9_\-.!$&'()*+,;:=@]|%[0-9a-f]{2}|~0|~1)*)*$/i,"relative-json-pointer":/^(?:0|[1-9][0-9]*)(?:#|(?:\/(?:[^~/]|~0|~1)*)*)$/,byte:function(e){return y.lastIndex=0,y.test(e)},int32:{type:"number",validate:function(e){return Number.isInteger(e)&&e<=g&&e>=f}},int64:{type:"number",validate:function(e){return Number.isInteger(e)}},float:{type:"number",validate:v},double:{type:"number",validate:v},password:!0,binary:!0},s.fastFormats={...s.fullFormats,date:r(/^\d\d\d\d-[0-1]\d-[0-3]\d$/,p),time:r(/^(?:[0-2]\d:[0-5]\d:[0-5]\d|23:59:60)(?:\.\d+)?(?:z|[+-]\d\d(?::?\d\d)?)?$/i,c),"date-time":r(/^\d\d\d\d-[0-1]\d-[0-3]\d[t\s](?:[0-2]\d:[0-5]\d:[0-5]\d|23:59:60)(?:\.\d+)?(?:z|[+-]\d\d(?::?\d\d)?)$/i,u),uri:/^(?:[a-z][a-z0-9+\-.]*:)(?:\/?\/)?[^\s]*$/i,"uri-reference":/^(?:(?:[a-z][a-z0-9+\-.]*:)?\/?\/)?(?:[^\\\s#][^\s#]*)?(?:#[^\\\s]*)?$/i,email:/^[a-z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?(?:\.[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?)*$/i},s.formatNames=Object.keys(s.fullFormats);const i=/^(\d\d\d\d)-(\d\d)-(\d\d)$/,a=[0,31,28,31,30,31,30,31,31,30,31,30,31];function o(e){var t,s,e=i.exec(e);return!!e&&(t=+e[1],s=+e[2],e=+e[3],1<=s)&&s<=12&&1<=e&&e<=(2!=s||(e=t)%4!=0||e%100==0&&e%400!=0?a[s]:29)}function p(e,t){if(e&&t)return t<e?1:e<t?-1:0}const n=/^(\d\d):(\d\d):(\d\d)(\.\d+)?(z|[+-]\d\d(?::?\d\d)?)?$/i;function d(e,t){var s,r,i,e=n.exec(e);return!!e&&(s=+e[1],r=+e[2],i=+e[3],e=e[5],s<=23&&r<=59&&i<=59||23==s&&59==r&&60==i)&&(!t||""!==e)}function c(e,t){if(e&&t){var s=n.exec(e),r=n.exec(t);if(s&&r)return e=s[1]+s[2]+s[3]+(s[4]||""),(t=r[1]+r[2]+r[3]+(r[4]||""))<e?1:e<t?-1:0}}const m=/t|\s/i;function u(e,t){if(e&&t){var[e,s]=e.split(m),[t,r]=t.split(m),e=p(e,t);if(void 0!==e)return e||c(s,r)}}const l=/\/|:/,h=/^(?:[a-z][a-z0-9+\-.]*:)(?:\/?\/(?:(?:[a-z0-9\-._~!$&'()*+,;=:]|%[0-9a-f]{2})*@)?(?:\[(?:(?:(?:(?:[0-9a-f]{1,4}:){6}|::(?:[0-9a-f]{1,4}:){5}|(?:[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){4}|(?:(?:[0-9a-f]{1,4}:){0,1}[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){3}|(?:(?:[0-9a-f]{1,4}:){0,2}[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){2}|(?:(?:[0-9a-f]{1,4}:){0,3}[0-9a-f]{1,4})?::[0-9a-f]{1,4}:|(?:(?:[0-9a-f]{1,4}:){0,4}[0-9a-f]{1,4})?::)(?:[0-9a-f]{1,4}:[0-9a-f]{1,4}|(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?))|(?:(?:[0-9a-f]{1,4}:){0,5}[0-9a-f]{1,4})?::[0-9a-f]{1,4}|(?:(?:[0-9a-f]{1,4}:){0,6}[0-9a-f]{1,4})?::)|[Vv][0-9a-f]+\.[a-z0-9\-._~!$&'()*+,;=:]+)\]|(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)|(?:[a-z0-9\-._~!$&'()*+,;=]|%[0-9a-f]{2})*)(?::\d*)?(?:\/(?:[a-z0-9\-._~!$&'()*+,;=:@]|%[0-9a-f]{2})*)*|\/(?:(?:[a-z0-9\-._~!$&'()*+,;=:@]|%[0-9a-f]{2})+(?:\/(?:[a-z0-9\-._~!$&'()*+,;=:@]|%[0-9a-f]{2})*)*)?|(?:[a-z0-9\-._~!$&'()*+,;=:@]|%[0-9a-f]{2})+(?:\/(?:[a-z0-9\-._~!$&'()*+,;=:@]|%[0-9a-f]{2})*)*)(?:\?(?:[a-z0-9\-._~!$&'()*+,;=:@/?]|%[0-9a-f]{2})*)?(?:#(?:[a-z0-9\-._~!$&'()*+,;=:@/?]|%[0-9a-f]{2})*)?$/i;const y=/^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$/gm;const f=-(2**31),g=2**31-1;function v(){return!0}const P=/[^\\]\\Z/},{}],2:[function(e,t,s){let r=e("./validator.js");var i=Elm.Main.init({node:document.getElementById("app")});i.ports&&i.ports.sendData&&i.ports.sendData.subscribe(function(e){r(e,{allErrors:!0})?i.ports.receiveResult.send({valid:!0}):(i.ports.receiveResult.send({valid:!1,errors:r.errors}),console.log(r.errors))})},{"./validator.js":3}],3:[function(e,t,s){"use strict";t.exports=Ae,t.exports.default=Ae;const ve={required:["name","productions","version"],additionalProperties:!1,type:"object",properties:{version:{type:"string",description:'The API version that is being used. MUST be the string "v1" for now.',enum:["v1"]},name:{type:"string",description:"The organization's name"},address:{type:"object",additionalProperties:!1,properties:{postalCode:{type:"string"},streetAddress:{type:"string"},city:{type:"string"}}},productions:{type:"array",description:"The collection of all productions in the repertoire.",items:{type:"object",description:"An object containing unchanging information about the production.",additionalProperties:!1,required:["title","events"],properties:{title:{type:"string",description:"The event title"},subtitle:{type:"string",description:"The event's optional subtitle"},description:{type:"string",description:"A text describing the production"},teaser:{type:"string",description:"A short text describing the production"},additionalInfo:{type:"string",description:"Additional information about the production"},events:{type:"array",description:"List of current events offered by the organization",items:{type:"object",required:["startDate"],additionalProperties:!1,properties:{startDate:{type:"string",description:"The start date and time of the event (in ISO 8601 date format).",format:"date-time"},endDate:{type:"string",description:"The end date and time of the event (in ISO 8601 date format).",format:"date-time"},duration:{type:"integer",format:"int64",description:"The duration of the event in minutes.",minimum:0,maximum:0x8000000000000000},url:{type:"string",description:"Link to further information about the event",format:"uri"},location:{description:"Location where this event is happening.",type:"object",additionalProperties:!1,properties:{name:{type:"string"},postalCode:{type:"string"},streetAddress:{type:"string"},city:{type:"string"},wheelChairPlaces:{type:"object",description:"Describes the presence of reserved spots for wheelchairs in this location, as defined by [a11yjson](https://sozialhelden.github.io/a11yjson/describing-objects/interfaces/#wheelchairplaces).",additionalProperties:!1,required:["count"],properties:{count:{type:"integer",description:"The number of designated places for wheelchairs in this location."},hasSpaceForAssistant:{type:"boolean",description:"Is there additional space for an assistant?"},wheelchairUserCapacity:{type:"integer",description:"The number of people using a wheelchair that can be accomodated at the same time. Use this when there is no designated space for wheelchair users, but the number is known."}}}}},offers:{type:"array",items:{type:"object",additionalProperties:!1,properties:{name:{type:"string",description:'A descriptive name for this offer, e.g. "Normalpreis", "Ermäßigt", "Preisgruppe A", usw.'},price:{type:"number",format:"float",minimum:0,maximum:3402823669209385e23},priceCurrency:{type:"string",description:"The currency of the price. Use standard formats: TODO"},url:{type:"string",description:"Ticketing link of the event",format:"uri"}}}}}}},branch:{type:"string",description:'The branch of theatre this production belongs to, e.g. "Schauspiel", "Musiktheater", "Oper", etc.'},genre:{type:"string",description:"The genre of this production."},accessibility:{type:"object",additionalProperties:!1,properties:{accessModeSufficient:{type:"array",items:{type:"string",description:"A list of single or combined accessModes that are sufficient to understand all the intellectual content of a resource.",enum:["auditory","tactile","textual","visual"]}},accessibilityHazard:{type:"array",items:{type:"string",enum:["none","unknown","flashingHazard","motionSimulationHazard","soundHazard","noFlashingHazard","noMotionSimulationHazard","noSoundHazard","unknownFlashingHazard","unknownMotionSimulationHazard","unknownSoundHazard"]}},accessibilitySummary:{type:"string",description:"A human-readable summary of specific accessibility features or deficiencies of the production."}}},participants:{description:"List of all people contributing to and participating in the production, e.g. directors, stage designers, musical directors, performers, etc.\n\nIf multiple people perform the same role/function (e.g. there is multiple directors or multiple actors perform the same role on stage at the same time),\neach person should get their own entry in the `participants` array.",type:"array",items:{type:"object",required:["names"],additionalProperties:!1,properties:{function:{type:"string",description:'This participant\'s function in the production, e.g. "Regie", "Dramaturgie", or "Schauspiel". Can take one of the pre-defined values.'},roleName:{type:"string",description:"The name of the role(s) this participant is performing on stage, if any."},names:{type:"array",items:{type:"string"},description:"The name(s) of the person(s) performing this function/role. Must contain at least one name. Can contain multiple names, if multiple persons are performing the same role, but not at the same time.",minItems:1}}}}}}}},$schema:"http://json-schema.org/draft-07/schema#"},Pe=Object.prototype.hasOwnProperty,be=e("ajv-formats/dist/formats").fullFormats["date-time"],we=e("ajv-formats/dist/formats").fullFormats.int64,ke=e("ajv-formats/dist/formats").fullFormats.uri,ze=e("ajv-formats/dist/formats").fullFormats.float;function Ae(e,{instancePath:r="",rootData:F=e}={}){let i=null,a=0;if(e&&"object"==typeof e&&!Array.isArray(e)){var M;void 0===e.name&&(s={instancePath:r,schemaPath:"#/required",keyword:"required",params:{missingProperty:"name"},message:"must have required property 'name'"},null===i?i=[s]:i.push(s),a++),void 0===e.productions&&(s={instancePath:r,schemaPath:"#/required",keyword:"required",params:{missingProperty:"productions"},message:"must have required property 'productions'"},null===i?i=[s]:i.push(s),a++),void 0===e.version&&(s={instancePath:r,schemaPath:"#/required",keyword:"required",params:{missingProperty:"version"},message:"must have required property 'version'"},null===i?i=[s]:i.push(s),a++);for(const _ in e)"version"!==_&&"name"!==_&&"address"!==_&&"productions"!==_&&(M={instancePath:r,schemaPath:"#/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:_},message:"must NOT have additional properties"},null===i?i=[M]:i.push(M),a++);if(void 0!==e.version&&("string"!=typeof(s=e.version)&&(t={instancePath:r+"/version",schemaPath:"#/properties/version/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[t]:i.push(t),a++),"v1"!==s)&&(t={instancePath:r+"/version",schemaPath:"#/properties/version/enum",keyword:"enum",params:{allowedValues:ve.properties.version.enum},message:"must be equal to one of the allowed values"},null===i?i=[t]:i.push(t),a++),void 0!==e.name&&"string"!=typeof e.name&&(s={instancePath:r+"/name",schemaPath:"#/properties/name/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[s]:i.push(s),a++),void 0!==e.address){var O,t=e.address;if(t&&"object"==typeof t&&!Array.isArray(t)){for(const ue in t)"postalCode"!==ue&&"streetAddress"!==ue&&"city"!==ue&&(O={instancePath:r+"/address",schemaPath:"#/properties/address/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:ue},message:"must NOT have additional properties"},null===i?i=[O]:i.push(O),a++);void 0!==t.postalCode&&"string"!=typeof t.postalCode&&(s={instancePath:r+"/address/postalCode",schemaPath:"#/properties/address/properties/postalCode/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[s]:i.push(s),a++),void 0!==t.streetAddress&&"string"!=typeof t.streetAddress&&(s={instancePath:r+"/address/streetAddress",schemaPath:"#/properties/address/properties/streetAddress/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[s]:i.push(s),a++),void 0!==t.city&&"string"!=typeof t.city&&(s={instancePath:r+"/address/city",schemaPath:"#/properties/address/properties/city/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[s]:i.push(s),a++)}else{t={instancePath:r+"/address",schemaPath:"#/properties/address/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[t]:i.push(t),a++}}if(void 0!==e.productions){var I=e.productions;if(Array.isArray(I)){var U=I.length;for(let s=0;s<U;s++){var o,E,p,n,d,c=I[s];if(c&&"object"==typeof c&&!Array.isArray(c)){void 0===c.title&&(o={instancePath:r+"/productions/"+s,schemaPath:"#/properties/productions/items/required",keyword:"required",params:{missingProperty:"title"},message:"must have required property 'title'"},null===i?i=[o]:i.push(o),a++),void 0===c.events&&(o={instancePath:r+"/productions/"+s,schemaPath:"#/properties/productions/items/required",keyword:"required",params:{missingProperty:"events"},message:"must have required property 'events'"},null===i?i=[o]:i.push(o),a++);for(const le in c)Pe.call(ve.properties.productions.items.properties,le)||(E={instancePath:r+"/productions/"+s,schemaPath:"#/properties/productions/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:le},message:"must NOT have additional properties"},null===i?i=[E]:i.push(E),a++);if(void 0!==c.title&&"string"!=typeof c.title&&(p={instancePath:r+"/productions/"+s+"/title",schemaPath:"#/properties/productions/items/properties/title/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[p]:i.push(p),a++),void 0!==c.subtitle&&"string"!=typeof c.subtitle&&(p={instancePath:r+"/productions/"+s+"/subtitle",schemaPath:"#/properties/productions/items/properties/subtitle/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[p]:i.push(p),a++),void 0!==c.description&&"string"!=typeof c.description&&(n={instancePath:r+"/productions/"+s+"/description",schemaPath:"#/properties/productions/items/properties/description/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[n]:i.push(n),a++),void 0!==c.teaser&&"string"!=typeof c.teaser&&(n={instancePath:r+"/productions/"+s+"/teaser",schemaPath:"#/properties/productions/items/properties/teaser/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[n]:i.push(n),a++),void 0!==c.additionalInfo&&"string"!=typeof c.additionalInfo&&(Q={instancePath:r+"/productions/"+s+"/additionalInfo",schemaPath:"#/properties/productions/items/properties/additionalInfo/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[Q]:i.push(Q),a++),void 0!==c.events){var L=c.events;if(Array.isArray(L)){var V=L.length;for(let t=0;t<V;t++){var R,Z,m,u,l,h,y=L[t];if(y&&"object"==typeof y&&!Array.isArray(y)){void 0===y.startDate&&(Z={instancePath:r+"/productions/"+s+"/events/"+t,schemaPath:"#/properties/productions/items/properties/events/items/required",keyword:"required",params:{missingProperty:"startDate"},message:"must have required property 'startDate'"},null===i?i=[Z]:i.push(Z),a++);for(const D in y)"startDate"!==D&&"endDate"!==D&&"duration"!==D&&"url"!==D&&"location"!==D&&"offers"!==D&&(R={instancePath:r+"/productions/"+s+"/events/"+t,schemaPath:"#/properties/productions/items/properties/events/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:D},message:"must NOT have additional properties"},null===i?i=[R]:i.push(R),a++);if(void 0!==y.startDate&&("string"==typeof(Z=y.startDate)?be.validate(Z)||(m={instancePath:r+"/productions/"+s+"/events/"+t+"/startDate",schemaPath:"#/properties/productions/items/properties/events/items/properties/startDate/format",keyword:"format",params:{format:"date-time"},message:'must match format "date-time"'},null===i?i=[m]:i.push(m),a++):(m={instancePath:r+"/productions/"+s+"/events/"+t+"/startDate",schemaPath:"#/properties/productions/items/properties/events/items/properties/startDate/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[m]:i.push(m),a++)),void 0!==y.endDate&&("string"==typeof(u=y.endDate)?be.validate(u)||(u={instancePath:r+"/productions/"+s+"/events/"+t+"/endDate",schemaPath:"#/properties/productions/items/properties/events/items/properties/endDate/format",keyword:"format",params:{format:"date-time"},message:'must match format "date-time"'},null===i?i=[u]:i.push(u),a++):(u={instancePath:r+"/productions/"+s+"/events/"+t+"/endDate",schemaPath:"#/properties/productions/items/properties/events/items/properties/endDate/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[u]:i.push(u),a++)),void 0!==y.duration&&(("number"!=typeof(u=y.duration)||u%1||isNaN(u)||!isFinite(u))&&(l={instancePath:r+"/productions/"+s+"/events/"+t+"/duration",schemaPath:"#/properties/productions/items/properties/events/items/properties/duration/type",keyword:"type",params:{type:"integer"},message:"must be integer"},null===i?i=[l]:i.push(l),a++),"number"==typeof u)&&isFinite(u)&&((0x8000000000000000<u||isNaN(u))&&(l={instancePath:r+"/productions/"+s+"/events/"+t+"/duration",schemaPath:"#/properties/productions/items/properties/events/items/properties/duration/maximum",keyword:"maximum",params:{comparison:"<=",limit:0x8000000000000000},message:"must be <= 9223372036854776000"},null===i?i=[l]:i.push(l),a++),(u<0||isNaN(u))&&(h={instancePath:r+"/productions/"+s+"/events/"+t+"/duration",schemaPath:"#/properties/productions/items/properties/events/items/properties/duration/minimum",keyword:"minimum",params:{comparison:">=",limit:0},message:"must be >= 0"},null===i?i=[h]:i.push(h),a++),we.validate(u)||(h={instancePath:r+"/productions/"+s+"/events/"+t+"/duration",schemaPath:"#/properties/productions/items/properties/events/items/properties/duration/format",keyword:"format",params:{format:"int64"},message:'must match format "int64"'},null===i?i=[h]:i.push(h),a++)),void 0!==y.url&&("string"==typeof(v=y.url)?ke(v)||(v={instancePath:r+"/productions/"+s+"/events/"+t+"/url",schemaPath:"#/properties/productions/items/properties/events/items/properties/url/format",keyword:"format",params:{format:"uri"},message:'must match format "uri"'},null===i?i=[v]:i.push(v),a++):(v={instancePath:r+"/productions/"+s+"/events/"+t+"/url",schemaPath:"#/properties/productions/items/properties/events/items/properties/url/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[v]:i.push(v),a++)),void 0!==y.location){var B,f,g,v=y.location;if(v&&"object"==typeof v&&!Array.isArray(v)){for(const x in v)"name"!==x&&"postalCode"!==x&&"streetAddress"!==x&&"city"!==x&&"wheelChairPlaces"!==x&&(B={instancePath:r+"/productions/"+s+"/events/"+t+"/location",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:x},message:"must NOT have additional properties"},null===i?i=[B]:i.push(B),a++);if(void 0!==v.name&&"string"!=typeof v.name&&(f={instancePath:r+"/productions/"+s+"/events/"+t+"/location/name",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/name/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[f]:i.push(f),a++),void 0!==v.postalCode&&"string"!=typeof v.postalCode&&(f={instancePath:r+"/productions/"+s+"/events/"+t+"/location/postalCode",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/postalCode/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[f]:i.push(f),a++),void 0!==v.streetAddress&&"string"!=typeof v.streetAddress&&(g={instancePath:r+"/productions/"+s+"/events/"+t+"/location/streetAddress",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/streetAddress/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[g]:i.push(g),a++),void 0!==v.city&&"string"!=typeof v.city&&(g={instancePath:r+"/productions/"+s+"/events/"+t+"/location/city",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/city/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[g]:i.push(g),a++),void 0!==v.wheelChairPlaces){var W,P,b,w=v.wheelChairPlaces;if(w&&"object"==typeof w&&!Array.isArray(w)){void 0===w.count&&(P={instancePath:r+"/productions/"+s+"/events/"+t+"/location/wheelChairPlaces",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/required",keyword:"required",params:{missingProperty:"count"},message:"must have required property 'count'"},null===i?i=[P]:i.push(P),a++);for(const he in w)"count"!==he&&"hasSpaceForAssistant"!==he&&"wheelchairUserCapacity"!==he&&(W={instancePath:r+"/productions/"+s+"/events/"+t+"/location/wheelChairPlaces",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:he},message:"must NOT have additional properties"},null===i?i=[W]:i.push(W),a++);void 0!==w.count&&("number"!=typeof(P=w.count)||P%1||isNaN(P)||!isFinite(P))&&(b={instancePath:r+"/productions/"+s+"/events/"+t+"/location/wheelChairPlaces/count",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/properties/count/type",keyword:"type",params:{type:"integer"},message:"must be integer"},null===i?i=[b]:i.push(b),a++),void 0!==w.hasSpaceForAssistant&&"boolean"!=typeof w.hasSpaceForAssistant&&(b={instancePath:r+"/productions/"+s+"/events/"+t+"/location/wheelChairPlaces/hasSpaceForAssistant",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/properties/hasSpaceForAssistant/type",keyword:"type",params:{type:"boolean"},message:"must be boolean"},null===i?i=[b]:i.push(b),a++),void 0!==w.wheelchairUserCapacity&&("number"!=typeof(w=w.wheelchairUserCapacity)||w%1||isNaN(w)||!isFinite(w))&&(w={instancePath:r+"/productions/"+s+"/events/"+t+"/location/wheelChairPlaces/wheelchairUserCapacity",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/properties/wheelchairUserCapacity/type",keyword:"type",params:{type:"integer"},message:"must be integer"},null===i?i=[w]:i.push(w),a++)}else{w={instancePath:r+"/productions/"+s+"/events/"+t+"/location/wheelChairPlaces",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/properties/wheelChairPlaces/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[w]:i.push(w),a++}}}else{w={instancePath:r+"/productions/"+s+"/events/"+t+"/location",schemaPath:"#/properties/productions/items/properties/events/items/properties/location/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[w]:i.push(w),a++}}if(void 0!==y.offers){var Y=y.offers;if(Array.isArray(Y)){var G=Y.length;for(let e=0;e<G;e++){var J,k,z,A,K,j=Y[e];if(j&&"object"==typeof j&&!Array.isArray(j)){for(const ye in j)"name"!==ye&&"price"!==ye&&"priceCurrency"!==ye&&"url"!==ye&&(J={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e,schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:ye},message:"must NOT have additional properties"},null===i?i=[J]:i.push(J),a++);void 0!==j.name&&"string"!=typeof j.name&&(k={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e+"/name",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/name/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[k]:i.push(k),a++),void 0!==j.price&&("number"==typeof(k=j.price)&&isFinite(k)?((3402823669209385e23<k||isNaN(k))&&(z={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e+"/price",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/price/maximum",keyword:"maximum",params:{comparison:"<=",limit:3402823669209385e23},message:"must be <= 3.402823669209385e+38"},null===i?i=[z]:i.push(z),a++),(k<0||isNaN(k))&&(z={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e+"/price",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/price/minimum",keyword:"minimum",params:{comparison:">=",limit:0},message:"must be >= 0"},null===i?i=[z]:i.push(z),a++),ze.validate(k)||(A={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e+"/price",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/price/format",keyword:"format",params:{format:"float"},message:'must match format "float"'},null===i?i=[A]:i.push(A),a++)):(A={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e+"/price",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/price/type",keyword:"type",params:{type:"number"},message:"must be number"},null===i?i=[A]:i.push(A),a++)),void 0!==j.priceCurrency&&"string"!=typeof j.priceCurrency&&(K={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e+"/priceCurrency",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/priceCurrency/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[K]:i.push(K),a++),void 0!==j.url&&("string"==typeof(K=j.url)?ke(K)||(j={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e+"/url",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/url/format",keyword:"format",params:{format:"uri"},message:'must match format "uri"'},null===i?i=[j]:i.push(j),a++):(j={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e+"/url",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/properties/url/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[j]:i.push(j),a++))}else{j={instancePath:r+"/productions/"+s+"/events/"+t+"/offers/"+e,schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/items/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[j]:i.push(j),a++}}}else{y={instancePath:r+"/productions/"+s+"/events/"+t+"/offers",schemaPath:"#/properties/productions/items/properties/events/items/properties/offers/type",keyword:"type",params:{type:"array"},message:"must be array"};null===i?i=[y]:i.push(y),a++}}}else{y={instancePath:r+"/productions/"+s+"/events/"+t,schemaPath:"#/properties/productions/items/properties/events/items/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[y]:i.push(y),a++}}}else{var Q={instancePath:r+"/productions/"+s+"/events",schemaPath:"#/properties/productions/items/properties/events/type",keyword:"type",params:{type:"array"},message:"must be array"};null===i?i=[Q]:i.push(Q),a++}}if(void 0!==c.branch&&"string"!=typeof c.branch&&(d={instancePath:r+"/productions/"+s+"/branch",schemaPath:"#/properties/productions/items/properties/branch/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[d]:i.push(d),a++),void 0!==c.genre&&"string"!=typeof c.genre&&(d={instancePath:r+"/productions/"+s+"/genre",schemaPath:"#/properties/productions/items/properties/genre/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[d]:i.push(d),a++),void 0!==c.accessibility){var X,$=c.accessibility;if($&&"object"==typeof $&&!Array.isArray($)){for(const fe in $)"accessModeSufficient"!==fe&&"accessibilityHazard"!==fe&&"accessibilitySummary"!==fe&&(X={instancePath:r+"/productions/"+s+"/accessibility",schemaPath:"#/properties/productions/items/properties/accessibility/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:fe},message:"must NOT have additional properties"},null===i?i=[X]:i.push(X),a++);if(void 0!==$.accessModeSufficient){var ee=$.accessModeSufficient;if(Array.isArray(ee)){var te=ee.length;for(let e=0;e<te;e++){var C,se=ee[e];"string"!=typeof se&&(C={instancePath:r+"/productions/"+s+"/accessibility/accessModeSufficient/"+e,schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessModeSufficient/items/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[C]:i.push(C),a++),"auditory"!==se&&"tactile"!==se&&"textual"!==se&&"visual"!==se&&(C={instancePath:r+"/productions/"+s+"/accessibility/accessModeSufficient/"+e,schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessModeSufficient/items/enum",keyword:"enum",params:{allowedValues:ve.properties.productions.items.properties.accessibility.properties.accessModeSufficient.items.enum},message:"must be equal to one of the allowed values"},null===i?i=[C]:i.push(C),a++)}}else{var re={instancePath:r+"/productions/"+s+"/accessibility/accessModeSufficient",schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessModeSufficient/type",keyword:"type",params:{type:"array"},message:"must be array"};null===i?i=[re]:i.push(re),a++}}if(void 0!==$.accessibilityHazard){var ie=$.accessibilityHazard;if(Array.isArray(ie)){var ae=ie.length;for(let e=0;e<ae;e++){var S,N=ie[e];"string"!=typeof N&&(S={instancePath:r+"/productions/"+s+"/accessibility/accessibilityHazard/"+e,schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessibilityHazard/items/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[S]:i.push(S),a++),"none"!==N&&"unknown"!==N&&"flashingHazard"!==N&&"motionSimulationHazard"!==N&&"soundHazard"!==N&&"noFlashingHazard"!==N&&"noMotionSimulationHazard"!==N&&"noSoundHazard"!==N&&"unknownFlashingHazard"!==N&&"unknownMotionSimulationHazard"!==N&&"unknownSoundHazard"!==N&&(S={instancePath:r+"/productions/"+s+"/accessibility/accessibilityHazard/"+e,schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessibilityHazard/items/enum",keyword:"enum",params:{allowedValues:ve.properties.productions.items.properties.accessibility.properties.accessibilityHazard.items.enum},message:"must be equal to one of the allowed values"},null===i?i=[S]:i.push(S),a++)}}else{re={instancePath:r+"/productions/"+s+"/accessibility/accessibilityHazard",schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessibilityHazard/type",keyword:"type",params:{type:"array"},message:"must be array"};null===i?i=[re]:i.push(re),a++}}void 0!==$.accessibilitySummary&&"string"!=typeof $.accessibilitySummary&&($={instancePath:r+"/productions/"+s+"/accessibility/accessibilitySummary",schemaPath:"#/properties/productions/items/properties/accessibility/properties/accessibilitySummary/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[$]:i.push($),a++)}else{$={instancePath:r+"/productions/"+s+"/accessibility",schemaPath:"#/properties/productions/items/properties/accessibility/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[$]:i.push($),a++}}if(void 0!==c.participants){var oe=c.participants;if(Array.isArray(oe)){var pe=oe.length;for(let t=0;t<pe;t++){var ne,q,T=oe[t];if(T&&"object"==typeof T&&!Array.isArray(T)){void 0===T.names&&(q={instancePath:r+"/productions/"+s+"/participants/"+t,schemaPath:"#/properties/productions/items/properties/participants/items/required",keyword:"required",params:{missingProperty:"names"},message:"must have required property 'names'"},null===i?i=[q]:i.push(q),a++);for(const ge in T)"function"!==ge&&"roleName"!==ge&&"names"!==ge&&(ne={instancePath:r+"/productions/"+s+"/participants/"+t,schemaPath:"#/properties/productions/items/properties/participants/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty:ge},message:"must NOT have additional properties"},null===i?i=[ne]:i.push(ne),a++);if(void 0!==T.function&&"string"!=typeof T.function&&(q={instancePath:r+"/productions/"+s+"/participants/"+t+"/function",schemaPath:"#/properties/productions/items/properties/participants/items/properties/function/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[q]:i.push(q),a++),void 0!==T.roleName&&"string"!=typeof T.roleName&&(H={instancePath:r+"/productions/"+s+"/participants/"+t+"/roleName",schemaPath:"#/properties/productions/items/properties/participants/items/properties/roleName/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[H]:i.push(H),a++),void 0!==T.names){var de=T.names;if(Array.isArray(de)){de.length<1&&(H={instancePath:r+"/productions/"+s+"/participants/"+t+"/names",schemaPath:"#/properties/productions/items/properties/participants/items/properties/names/minItems",keyword:"minItems",params:{limit:1},message:"must NOT have fewer than 1 items"},null===i?i=[H]:i.push(H),a++);var H,ce,me=de.length;for(let e=0;e<me;e++)"string"!=typeof de[e]&&(ce={instancePath:r+"/productions/"+s+"/participants/"+t+"/names/"+e,schemaPath:"#/properties/productions/items/properties/participants/items/properties/names/items/type",keyword:"type",params:{type:"string"},message:"must be string"},null===i?i=[ce]:i.push(ce),a++)}else{T={instancePath:r+"/productions/"+s+"/participants/"+t+"/names",schemaPath:"#/properties/productions/items/properties/participants/items/properties/names/type",keyword:"type",params:{type:"array"},message:"must be array"};null===i?i=[T]:i.push(T),a++}}}else{T={instancePath:r+"/productions/"+s+"/participants/"+t,schemaPath:"#/properties/productions/items/properties/participants/items/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[T]:i.push(T),a++}}}else{$={instancePath:r+"/productions/"+s+"/participants",schemaPath:"#/properties/productions/items/properties/participants/type",keyword:"type",params:{type:"array"},message:"must be array"};null===i?i=[$]:i.push($),a++}}}else{c={instancePath:r+"/productions/"+s,schemaPath:"#/properties/productions/items/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[c]:i.push(c),a++}}}else{var s={instancePath:r+"/productions",schemaPath:"#/properties/productions/type",keyword:"type",params:{type:"array"},message:"must be array"};null===i?i=[s]:i.push(s),a++}}}else{t={instancePath:r,schemaPath:"#/type",keyword:"type",params:{type:"object"},message:"must be object"};null===i?i=[t]:i.push(t),a++}return Ae.errors=i,0===a}},{"ajv-formats/dist/formats":1}]},{},[2]);