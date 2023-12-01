(function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.formatNames = exports.fastFormats = exports.fullFormats = void 0;
function fmtDef(validate, compare) {
    return { validate, compare };
}
exports.fullFormats = {
    // date: http://tools.ietf.org/html/rfc3339#section-5.6
    date: fmtDef(date, compareDate),
    // date-time: http://tools.ietf.org/html/rfc3339#section-5.6
    time: fmtDef(time, compareTime),
    "date-time": fmtDef(date_time, compareDateTime),
    // duration: https://tools.ietf.org/html/rfc3339#appendix-A
    duration: /^P(?!$)((\d+Y)?(\d+M)?(\d+D)?(T(?=\d)(\d+H)?(\d+M)?(\d+S)?)?|(\d+W)?)$/,
    uri,
    "uri-reference": /^(?:[a-z][a-z0-9+\-.]*:)?(?:\/?\/(?:(?:[a-z0-9\-._~!$&'()*+,;=:]|%[0-9a-f]{2})*@)?(?:\[(?:(?:(?:(?:[0-9a-f]{1,4}:){6}|::(?:[0-9a-f]{1,4}:){5}|(?:[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){4}|(?:(?:[0-9a-f]{1,4}:){0,1}[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){3}|(?:(?:[0-9a-f]{1,4}:){0,2}[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){2}|(?:(?:[0-9a-f]{1,4}:){0,3}[0-9a-f]{1,4})?::[0-9a-f]{1,4}:|(?:(?:[0-9a-f]{1,4}:){0,4}[0-9a-f]{1,4})?::)(?:[0-9a-f]{1,4}:[0-9a-f]{1,4}|(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?))|(?:(?:[0-9a-f]{1,4}:){0,5}[0-9a-f]{1,4})?::[0-9a-f]{1,4}|(?:(?:[0-9a-f]{1,4}:){0,6}[0-9a-f]{1,4})?::)|[Vv][0-9a-f]+\.[a-z0-9\-._~!$&'()*+,;=:]+)\]|(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)|(?:[a-z0-9\-._~!$&'"()*+,;=]|%[0-9a-f]{2})*)(?::\d*)?(?:\/(?:[a-z0-9\-._~!$&'"()*+,;=:@]|%[0-9a-f]{2})*)*|\/(?:(?:[a-z0-9\-._~!$&'"()*+,;=:@]|%[0-9a-f]{2})+(?:\/(?:[a-z0-9\-._~!$&'"()*+,;=:@]|%[0-9a-f]{2})*)*)?|(?:[a-z0-9\-._~!$&'"()*+,;=:@]|%[0-9a-f]{2})+(?:\/(?:[a-z0-9\-._~!$&'"()*+,;=:@]|%[0-9a-f]{2})*)*)?(?:\?(?:[a-z0-9\-._~!$&'"()*+,;=:@/?]|%[0-9a-f]{2})*)?(?:#(?:[a-z0-9\-._~!$&'"()*+,;=:@/?]|%[0-9a-f]{2})*)?$/i,
    // uri-template: https://tools.ietf.org/html/rfc6570
    "uri-template": /^(?:(?:[^\x00-\x20"'<>%\\^`{|}]|%[0-9a-f]{2})|\{[+#./;?&=,!@|]?(?:[a-z0-9_]|%[0-9a-f]{2})+(?::[1-9][0-9]{0,3}|\*)?(?:,(?:[a-z0-9_]|%[0-9a-f]{2})+(?::[1-9][0-9]{0,3}|\*)?)*\})*$/i,
    // For the source: https://gist.github.com/dperini/729294
    // For test cases: https://mathiasbynens.be/demo/url-regex
    url: /^(?:https?|ftp):\/\/(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z0-9\u{00a1}-\u{ffff}]+-)*[a-z0-9\u{00a1}-\u{ffff}]+)(?:\.(?:[a-z0-9\u{00a1}-\u{ffff}]+-)*[a-z0-9\u{00a1}-\u{ffff}]+)*(?:\.(?:[a-z\u{00a1}-\u{ffff}]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?$/iu,
    email: /^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$/i,
    hostname: /^(?=.{1,253}\.?$)[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?(?:\.[a-z0-9](?:[-0-9a-z]{0,61}[0-9a-z])?)*\.?$/i,
    // optimized https://www.safaribooksonline.com/library/view/regular-expressions-cookbook/9780596802837/ch07s16.html
    ipv4: /^(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)$/,
    ipv6: /^((([0-9a-f]{1,4}:){7}([0-9a-f]{1,4}|:))|(([0-9a-f]{1,4}:){6}(:[0-9a-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9a-f]{1,4}:){5}(((:[0-9a-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9a-f]{1,4}:){4}(((:[0-9a-f]{1,4}){1,3})|((:[0-9a-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){3}(((:[0-9a-f]{1,4}){1,4})|((:[0-9a-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){2}(((:[0-9a-f]{1,4}){1,5})|((:[0-9a-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){1}(((:[0-9a-f]{1,4}){1,6})|((:[0-9a-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9a-f]{1,4}){1,7})|((:[0-9a-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))$/i,
    regex,
    // uuid: http://tools.ietf.org/html/rfc4122
    uuid: /^(?:urn:uuid:)?[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}$/i,
    // JSON-pointer: https://tools.ietf.org/html/rfc6901
    // uri fragment: https://tools.ietf.org/html/rfc3986#appendix-A
    "json-pointer": /^(?:\/(?:[^~/]|~0|~1)*)*$/,
    "json-pointer-uri-fragment": /^#(?:\/(?:[a-z0-9_\-.!$&'()*+,;:=@]|%[0-9a-f]{2}|~0|~1)*)*$/i,
    // relative JSON-pointer: http://tools.ietf.org/html/draft-luff-relative-json-pointer-00
    "relative-json-pointer": /^(?:0|[1-9][0-9]*)(?:#|(?:\/(?:[^~/]|~0|~1)*)*)$/,
    // the following formats are used by the openapi specification: https://spec.openapis.org/oas/v3.0.0#data-types
    // byte: https://github.com/miguelmota/is-base64
    byte,
    // signed 32 bit integer
    int32: { type: "number", validate: validateInt32 },
    // signed 64 bit integer
    int64: { type: "number", validate: validateInt64 },
    // C-type float
    float: { type: "number", validate: validateNumber },
    // C-type double
    double: { type: "number", validate: validateNumber },
    // hint to the UI to hide input strings
    password: true,
    // unchecked string payload
    binary: true,
};
exports.fastFormats = {
    ...exports.fullFormats,
    date: fmtDef(/^\d\d\d\d-[0-1]\d-[0-3]\d$/, compareDate),
    time: fmtDef(/^(?:[0-2]\d:[0-5]\d:[0-5]\d|23:59:60)(?:\.\d+)?(?:z|[+-]\d\d(?::?\d\d)?)?$/i, compareTime),
    "date-time": fmtDef(/^\d\d\d\d-[0-1]\d-[0-3]\d[t\s](?:[0-2]\d:[0-5]\d:[0-5]\d|23:59:60)(?:\.\d+)?(?:z|[+-]\d\d(?::?\d\d)?)$/i, compareDateTime),
    // uri: https://github.com/mafintosh/is-my-json-valid/blob/master/formats.js
    uri: /^(?:[a-z][a-z0-9+\-.]*:)(?:\/?\/)?[^\s]*$/i,
    "uri-reference": /^(?:(?:[a-z][a-z0-9+\-.]*:)?\/?\/)?(?:[^\\\s#][^\s#]*)?(?:#[^\\\s]*)?$/i,
    // email (sources from jsen validator):
    // http://stackoverflow.com/questions/201323/using-a-regular-expression-to-validate-an-email-address#answer-8829363
    // http://www.w3.org/TR/html5/forms.html#valid-e-mail-address (search for 'wilful violation')
    email: /^[a-z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?(?:\.[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?)*$/i,
};
exports.formatNames = Object.keys(exports.fullFormats);
function isLeapYear(year) {
    // https://tools.ietf.org/html/rfc3339#appendix-C
    return year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0);
}
const DATE = /^(\d\d\d\d)-(\d\d)-(\d\d)$/;
const DAYS = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
function date(str) {
    // full-date from http://tools.ietf.org/html/rfc3339#section-5.6
    const matches = DATE.exec(str);
    if (!matches)
        return false;
    const year = +matches[1];
    const month = +matches[2];
    const day = +matches[3];
    return (month >= 1 &&
        month <= 12 &&
        day >= 1 &&
        day <= (month === 2 && isLeapYear(year) ? 29 : DAYS[month]));
}
function compareDate(d1, d2) {
    if (!(d1 && d2))
        return undefined;
    if (d1 > d2)
        return 1;
    if (d1 < d2)
        return -1;
    return 0;
}
const TIME = /^(\d\d):(\d\d):(\d\d)(\.\d+)?(z|[+-]\d\d(?::?\d\d)?)?$/i;
function time(str, withTimeZone) {
    const matches = TIME.exec(str);
    if (!matches)
        return false;
    const hour = +matches[1];
    const minute = +matches[2];
    const second = +matches[3];
    const timeZone = matches[5];
    return (((hour <= 23 && minute <= 59 && second <= 59) ||
        (hour === 23 && minute === 59 && second === 60)) &&
        (!withTimeZone || timeZone !== ""));
}
function compareTime(t1, t2) {
    if (!(t1 && t2))
        return undefined;
    const a1 = TIME.exec(t1);
    const a2 = TIME.exec(t2);
    if (!(a1 && a2))
        return undefined;
    t1 = a1[1] + a1[2] + a1[3] + (a1[4] || "");
    t2 = a2[1] + a2[2] + a2[3] + (a2[4] || "");
    if (t1 > t2)
        return 1;
    if (t1 < t2)
        return -1;
    return 0;
}
const DATE_TIME_SEPARATOR = /t|\s/i;
function date_time(str) {
    // http://tools.ietf.org/html/rfc3339#section-5.6
    const dateTime = str.split(DATE_TIME_SEPARATOR);
    return dateTime.length === 2 && date(dateTime[0]) && time(dateTime[1], true);
}
function compareDateTime(dt1, dt2) {
    if (!(dt1 && dt2))
        return undefined;
    const [d1, t1] = dt1.split(DATE_TIME_SEPARATOR);
    const [d2, t2] = dt2.split(DATE_TIME_SEPARATOR);
    const res = compareDate(d1, d2);
    if (res === undefined)
        return undefined;
    return res || compareTime(t1, t2);
}
const NOT_URI_FRAGMENT = /\/|:/;
const URI = /^(?:[a-z][a-z0-9+\-.]*:)(?:\/?\/(?:(?:[a-z0-9\-._~!$&'()*+,;=:]|%[0-9a-f]{2})*@)?(?:\[(?:(?:(?:(?:[0-9a-f]{1,4}:){6}|::(?:[0-9a-f]{1,4}:){5}|(?:[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){4}|(?:(?:[0-9a-f]{1,4}:){0,1}[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){3}|(?:(?:[0-9a-f]{1,4}:){0,2}[0-9a-f]{1,4})?::(?:[0-9a-f]{1,4}:){2}|(?:(?:[0-9a-f]{1,4}:){0,3}[0-9a-f]{1,4})?::[0-9a-f]{1,4}:|(?:(?:[0-9a-f]{1,4}:){0,4}[0-9a-f]{1,4})?::)(?:[0-9a-f]{1,4}:[0-9a-f]{1,4}|(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?))|(?:(?:[0-9a-f]{1,4}:){0,5}[0-9a-f]{1,4})?::[0-9a-f]{1,4}|(?:(?:[0-9a-f]{1,4}:){0,6}[0-9a-f]{1,4})?::)|[Vv][0-9a-f]+\.[a-z0-9\-._~!$&'()*+,;=:]+)\]|(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)|(?:[a-z0-9\-._~!$&'()*+,;=]|%[0-9a-f]{2})*)(?::\d*)?(?:\/(?:[a-z0-9\-._~!$&'()*+,;=:@]|%[0-9a-f]{2})*)*|\/(?:(?:[a-z0-9\-._~!$&'()*+,;=:@]|%[0-9a-f]{2})+(?:\/(?:[a-z0-9\-._~!$&'()*+,;=:@]|%[0-9a-f]{2})*)*)?|(?:[a-z0-9\-._~!$&'()*+,;=:@]|%[0-9a-f]{2})+(?:\/(?:[a-z0-9\-._~!$&'()*+,;=:@]|%[0-9a-f]{2})*)*)(?:\?(?:[a-z0-9\-._~!$&'()*+,;=:@/?]|%[0-9a-f]{2})*)?(?:#(?:[a-z0-9\-._~!$&'()*+,;=:@/?]|%[0-9a-f]{2})*)?$/i;
function uri(str) {
    // http://jmrware.com/articles/2009/uri_regexp/URI_regex.html + optional protocol + required "."
    return NOT_URI_FRAGMENT.test(str) && URI.test(str);
}
const BYTE = /^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$/gm;
function byte(str) {
    BYTE.lastIndex = 0;
    return BYTE.test(str);
}
const MIN_INT32 = -(2 ** 31);
const MAX_INT32 = 2 ** 31 - 1;
function validateInt32(value) {
    return Number.isInteger(value) && value <= MAX_INT32 && value >= MIN_INT32;
}
function validateInt64(value) {
    // JSON and javascript max Int is 2**53, so any int that passes isInteger is valid for Int64
    return Number.isInteger(value);
}
function validateNumber() {
    return true;
}
const Z_ANCHOR = /[^\\]\\Z/;
function regex(str) {
    if (Z_ANCHOR.test(str))
        return false;
    try {
        new RegExp(str);
        return true;
    }
    catch (e) {
        return false;
    }
}

},{}],2:[function(require,module,exports){
let validator = require("./validator.js");

// Start the Elm application.
var app = Elm.Main.init({
  node: document.getElementById("app"),
});

if (app.ports && app.ports.sendData) {
  app.ports.sendData.subscribe(function (data) {
    if (validator(data, { allErrors: true })) {
      app.ports.receiveResult.send({ valid: true });
    } else {
      app.ports.receiveResult.send({
        valid: false,
        errors: validator.errors,
      });
      console.log(validator.errors);
    }
  });
}

},{"./validator.js":3}],3:[function(require,module,exports){
"use strict";module.exports = validate20;module.exports.default = validate20;const schema22 = {"required":["name","events"],"additionalProperties":false,"type":"object","properties":{"name":{"type":"string","description":"The organization's name"},"address":{"type":"object","additionalProperties":false,"properties":{"postalCode":{"type":"string"},"streetAddress":{"type":"string"},"city":{"type":"string"}}},"events":{"type":"array","description":"List of current events offered by the organization","items":{"type":"object","required":["title","description","startDate"],"additionalProperties":false,"properties":{"title":{"type":"string","description":"The event title"},"subtitle":{"type":"string","description":"The event's optional subtitle"},"description":{"type":"string"},"startDate":{"type":"string","description":"The start date and time of the event (in ISO 8601 date format).","format":"date-time"},"endDate":{"type":"string","description":"The end date and time of the event (in ISO 8601 date format).","format":"date-time"},"duration":{"type":"integer","format":"int64","description":"The duration of the event in seconds.","minimum":-9223372036854776000,"maximum":9223372036854776000},"url":{"type":"string","description":"Link to further information about the event","format":"uri"},"collaborators":{"description":"List of people collaborating on the event","type":"array","items":{"type":"object","additionalProperties":false,"properties":{"name":{"type":"string"},"role":{"type":"string","description":"This person's role in the performance, e.g. \"Regie\" or \"Dramaturgie\". For performers, this should be the name of the role they are performing on stage."}}}},"performers":{"type":"array","items":{"type":"object","additionalProperties":false,"properties":{"name":{"type":"string"},"role":{"type":"string","description":"This person's role in the performance, e.g. \"Regie\" or \"Dramaturgie\". For performers, this should be the name of the role they are performing on stage."}}}},"location":{"description":"Location where this event is happening.","type":"object","additionalProperties":false,"properties":{"name":{"type":"string"},"postalCode":{"type":"string"},"streetAddress":{"type":"string"},"city":{"type":"string"}}},"offers":{"type":"array","items":{"type":"object","additionalProperties":false,"properties":{"url":{"type":"string","description":"Ticketing link of the event","format":"uri"}}}}}}}},"$schema":"http://json-schema.org/draft-07/schema#"};const func4 = Object.prototype.hasOwnProperty;const formats0 = require("ajv-formats/dist/formats").fullFormats["date-time"];const formats4 = require("ajv-formats/dist/formats").fullFormats.int64;const formats6 = require("ajv-formats/dist/formats").fullFormats.uri;function validate20(data, {instancePath="", parentData, parentDataProperty, rootData=data}={}){let vErrors = null;let errors = 0;if(data && typeof data == "object" && !Array.isArray(data)){if(data.name === undefined){const err0 = {instancePath,schemaPath:"#/required",keyword:"required",params:{missingProperty: "name"},message:"must have required property '"+"name"+"'"};if(vErrors === null){vErrors = [err0];}else {vErrors.push(err0);}errors++;}if(data.events === undefined){const err1 = {instancePath,schemaPath:"#/required",keyword:"required",params:{missingProperty: "events"},message:"must have required property '"+"events"+"'"};if(vErrors === null){vErrors = [err1];}else {vErrors.push(err1);}errors++;}for(const key0 in data){if(!(((key0 === "name") || (key0 === "address")) || (key0 === "events"))){const err2 = {instancePath,schemaPath:"#/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key0},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err2];}else {vErrors.push(err2);}errors++;}}if(data.name !== undefined){if(typeof data.name !== "string"){const err3 = {instancePath:instancePath+"/name",schemaPath:"#/properties/name/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err3];}else {vErrors.push(err3);}errors++;}}if(data.address !== undefined){let data1 = data.address;if(data1 && typeof data1 == "object" && !Array.isArray(data1)){for(const key1 in data1){if(!(((key1 === "postalCode") || (key1 === "streetAddress")) || (key1 === "city"))){const err4 = {instancePath:instancePath+"/address",schemaPath:"#/properties/address/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key1},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err4];}else {vErrors.push(err4);}errors++;}}if(data1.postalCode !== undefined){if(typeof data1.postalCode !== "string"){const err5 = {instancePath:instancePath+"/address/postalCode",schemaPath:"#/properties/address/properties/postalCode/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err5];}else {vErrors.push(err5);}errors++;}}if(data1.streetAddress !== undefined){if(typeof data1.streetAddress !== "string"){const err6 = {instancePath:instancePath+"/address/streetAddress",schemaPath:"#/properties/address/properties/streetAddress/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err6];}else {vErrors.push(err6);}errors++;}}if(data1.city !== undefined){if(typeof data1.city !== "string"){const err7 = {instancePath:instancePath+"/address/city",schemaPath:"#/properties/address/properties/city/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err7];}else {vErrors.push(err7);}errors++;}}}else {const err8 = {instancePath:instancePath+"/address",schemaPath:"#/properties/address/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err8];}else {vErrors.push(err8);}errors++;}}if(data.events !== undefined){let data5 = data.events;if(Array.isArray(data5)){const len0 = data5.length;for(let i0=0; i0<len0; i0++){let data6 = data5[i0];if(data6 && typeof data6 == "object" && !Array.isArray(data6)){if(data6.title === undefined){const err9 = {instancePath:instancePath+"/events/" + i0,schemaPath:"#/properties/events/items/required",keyword:"required",params:{missingProperty: "title"},message:"must have required property '"+"title"+"'"};if(vErrors === null){vErrors = [err9];}else {vErrors.push(err9);}errors++;}if(data6.description === undefined){const err10 = {instancePath:instancePath+"/events/" + i0,schemaPath:"#/properties/events/items/required",keyword:"required",params:{missingProperty: "description"},message:"must have required property '"+"description"+"'"};if(vErrors === null){vErrors = [err10];}else {vErrors.push(err10);}errors++;}if(data6.startDate === undefined){const err11 = {instancePath:instancePath+"/events/" + i0,schemaPath:"#/properties/events/items/required",keyword:"required",params:{missingProperty: "startDate"},message:"must have required property '"+"startDate"+"'"};if(vErrors === null){vErrors = [err11];}else {vErrors.push(err11);}errors++;}for(const key2 in data6){if(!(func4.call(schema22.properties.events.items.properties, key2))){const err12 = {instancePath:instancePath+"/events/" + i0,schemaPath:"#/properties/events/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key2},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err12];}else {vErrors.push(err12);}errors++;}}if(data6.title !== undefined){if(typeof data6.title !== "string"){const err13 = {instancePath:instancePath+"/events/" + i0+"/title",schemaPath:"#/properties/events/items/properties/title/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err13];}else {vErrors.push(err13);}errors++;}}if(data6.subtitle !== undefined){if(typeof data6.subtitle !== "string"){const err14 = {instancePath:instancePath+"/events/" + i0+"/subtitle",schemaPath:"#/properties/events/items/properties/subtitle/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err14];}else {vErrors.push(err14);}errors++;}}if(data6.description !== undefined){if(typeof data6.description !== "string"){const err15 = {instancePath:instancePath+"/events/" + i0+"/description",schemaPath:"#/properties/events/items/properties/description/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err15];}else {vErrors.push(err15);}errors++;}}if(data6.startDate !== undefined){let data10 = data6.startDate;if(typeof data10 === "string"){if(!(formats0.validate(data10))){const err16 = {instancePath:instancePath+"/events/" + i0+"/startDate",schemaPath:"#/properties/events/items/properties/startDate/format",keyword:"format",params:{format: "date-time"},message:"must match format \""+"date-time"+"\""};if(vErrors === null){vErrors = [err16];}else {vErrors.push(err16);}errors++;}}else {const err17 = {instancePath:instancePath+"/events/" + i0+"/startDate",schemaPath:"#/properties/events/items/properties/startDate/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err17];}else {vErrors.push(err17);}errors++;}}if(data6.endDate !== undefined){let data11 = data6.endDate;if(typeof data11 === "string"){if(!(formats0.validate(data11))){const err18 = {instancePath:instancePath+"/events/" + i0+"/endDate",schemaPath:"#/properties/events/items/properties/endDate/format",keyword:"format",params:{format: "date-time"},message:"must match format \""+"date-time"+"\""};if(vErrors === null){vErrors = [err18];}else {vErrors.push(err18);}errors++;}}else {const err19 = {instancePath:instancePath+"/events/" + i0+"/endDate",schemaPath:"#/properties/events/items/properties/endDate/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err19];}else {vErrors.push(err19);}errors++;}}if(data6.duration !== undefined){let data12 = data6.duration;if(!(((typeof data12 == "number") && (!(data12 % 1) && !isNaN(data12))) && (isFinite(data12)))){const err20 = {instancePath:instancePath+"/events/" + i0+"/duration",schemaPath:"#/properties/events/items/properties/duration/type",keyword:"type",params:{type: "integer"},message:"must be integer"};if(vErrors === null){vErrors = [err20];}else {vErrors.push(err20);}errors++;}if((typeof data12 == "number") && (isFinite(data12))){if(data12 > 9223372036854776000 || isNaN(data12)){const err21 = {instancePath:instancePath+"/events/" + i0+"/duration",schemaPath:"#/properties/events/items/properties/duration/maximum",keyword:"maximum",params:{comparison: "<=", limit: 9223372036854776000},message:"must be <= 9223372036854776000"};if(vErrors === null){vErrors = [err21];}else {vErrors.push(err21);}errors++;}if(data12 < -9223372036854776000 || isNaN(data12)){const err22 = {instancePath:instancePath+"/events/" + i0+"/duration",schemaPath:"#/properties/events/items/properties/duration/minimum",keyword:"minimum",params:{comparison: ">=", limit: -9223372036854776000},message:"must be >= -9223372036854776000"};if(vErrors === null){vErrors = [err22];}else {vErrors.push(err22);}errors++;}if(!(formats4.validate(data12))){const err23 = {instancePath:instancePath+"/events/" + i0+"/duration",schemaPath:"#/properties/events/items/properties/duration/format",keyword:"format",params:{format: "int64"},message:"must match format \""+"int64"+"\""};if(vErrors === null){vErrors = [err23];}else {vErrors.push(err23);}errors++;}}}if(data6.url !== undefined){let data13 = data6.url;if(typeof data13 === "string"){if(!(formats6(data13))){const err24 = {instancePath:instancePath+"/events/" + i0+"/url",schemaPath:"#/properties/events/items/properties/url/format",keyword:"format",params:{format: "uri"},message:"must match format \""+"uri"+"\""};if(vErrors === null){vErrors = [err24];}else {vErrors.push(err24);}errors++;}}else {const err25 = {instancePath:instancePath+"/events/" + i0+"/url",schemaPath:"#/properties/events/items/properties/url/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err25];}else {vErrors.push(err25);}errors++;}}if(data6.collaborators !== undefined){let data14 = data6.collaborators;if(Array.isArray(data14)){const len1 = data14.length;for(let i1=0; i1<len1; i1++){let data15 = data14[i1];if(data15 && typeof data15 == "object" && !Array.isArray(data15)){for(const key3 in data15){if(!((key3 === "name") || (key3 === "role"))){const err26 = {instancePath:instancePath+"/events/" + i0+"/collaborators/" + i1,schemaPath:"#/properties/events/items/properties/collaborators/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key3},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err26];}else {vErrors.push(err26);}errors++;}}if(data15.name !== undefined){if(typeof data15.name !== "string"){const err27 = {instancePath:instancePath+"/events/" + i0+"/collaborators/" + i1+"/name",schemaPath:"#/properties/events/items/properties/collaborators/items/properties/name/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err27];}else {vErrors.push(err27);}errors++;}}if(data15.role !== undefined){if(typeof data15.role !== "string"){const err28 = {instancePath:instancePath+"/events/" + i0+"/collaborators/" + i1+"/role",schemaPath:"#/properties/events/items/properties/collaborators/items/properties/role/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err28];}else {vErrors.push(err28);}errors++;}}}else {const err29 = {instancePath:instancePath+"/events/" + i0+"/collaborators/" + i1,schemaPath:"#/properties/events/items/properties/collaborators/items/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err29];}else {vErrors.push(err29);}errors++;}}}else {const err30 = {instancePath:instancePath+"/events/" + i0+"/collaborators",schemaPath:"#/properties/events/items/properties/collaborators/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err30];}else {vErrors.push(err30);}errors++;}}if(data6.performers !== undefined){let data18 = data6.performers;if(Array.isArray(data18)){const len2 = data18.length;for(let i2=0; i2<len2; i2++){let data19 = data18[i2];if(data19 && typeof data19 == "object" && !Array.isArray(data19)){for(const key4 in data19){if(!((key4 === "name") || (key4 === "role"))){const err31 = {instancePath:instancePath+"/events/" + i0+"/performers/" + i2,schemaPath:"#/properties/events/items/properties/performers/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key4},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err31];}else {vErrors.push(err31);}errors++;}}if(data19.name !== undefined){if(typeof data19.name !== "string"){const err32 = {instancePath:instancePath+"/events/" + i0+"/performers/" + i2+"/name",schemaPath:"#/properties/events/items/properties/performers/items/properties/name/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err32];}else {vErrors.push(err32);}errors++;}}if(data19.role !== undefined){if(typeof data19.role !== "string"){const err33 = {instancePath:instancePath+"/events/" + i0+"/performers/" + i2+"/role",schemaPath:"#/properties/events/items/properties/performers/items/properties/role/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err33];}else {vErrors.push(err33);}errors++;}}}else {const err34 = {instancePath:instancePath+"/events/" + i0+"/performers/" + i2,schemaPath:"#/properties/events/items/properties/performers/items/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err34];}else {vErrors.push(err34);}errors++;}}}else {const err35 = {instancePath:instancePath+"/events/" + i0+"/performers",schemaPath:"#/properties/events/items/properties/performers/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err35];}else {vErrors.push(err35);}errors++;}}if(data6.location !== undefined){let data22 = data6.location;if(data22 && typeof data22 == "object" && !Array.isArray(data22)){for(const key5 in data22){if(!((((key5 === "name") || (key5 === "postalCode")) || (key5 === "streetAddress")) || (key5 === "city"))){const err36 = {instancePath:instancePath+"/events/" + i0+"/location",schemaPath:"#/properties/events/items/properties/location/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key5},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err36];}else {vErrors.push(err36);}errors++;}}if(data22.name !== undefined){if(typeof data22.name !== "string"){const err37 = {instancePath:instancePath+"/events/" + i0+"/location/name",schemaPath:"#/properties/events/items/properties/location/properties/name/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err37];}else {vErrors.push(err37);}errors++;}}if(data22.postalCode !== undefined){if(typeof data22.postalCode !== "string"){const err38 = {instancePath:instancePath+"/events/" + i0+"/location/postalCode",schemaPath:"#/properties/events/items/properties/location/properties/postalCode/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err38];}else {vErrors.push(err38);}errors++;}}if(data22.streetAddress !== undefined){if(typeof data22.streetAddress !== "string"){const err39 = {instancePath:instancePath+"/events/" + i0+"/location/streetAddress",schemaPath:"#/properties/events/items/properties/location/properties/streetAddress/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err39];}else {vErrors.push(err39);}errors++;}}if(data22.city !== undefined){if(typeof data22.city !== "string"){const err40 = {instancePath:instancePath+"/events/" + i0+"/location/city",schemaPath:"#/properties/events/items/properties/location/properties/city/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err40];}else {vErrors.push(err40);}errors++;}}}else {const err41 = {instancePath:instancePath+"/events/" + i0+"/location",schemaPath:"#/properties/events/items/properties/location/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err41];}else {vErrors.push(err41);}errors++;}}if(data6.offers !== undefined){let data27 = data6.offers;if(Array.isArray(data27)){const len3 = data27.length;for(let i3=0; i3<len3; i3++){let data28 = data27[i3];if(data28 && typeof data28 == "object" && !Array.isArray(data28)){for(const key6 in data28){if(!(key6 === "url")){const err42 = {instancePath:instancePath+"/events/" + i0+"/offers/" + i3,schemaPath:"#/properties/events/items/properties/offers/items/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key6},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err42];}else {vErrors.push(err42);}errors++;}}if(data28.url !== undefined){let data29 = data28.url;if(typeof data29 === "string"){if(!(formats6(data29))){const err43 = {instancePath:instancePath+"/events/" + i0+"/offers/" + i3+"/url",schemaPath:"#/properties/events/items/properties/offers/items/properties/url/format",keyword:"format",params:{format: "uri"},message:"must match format \""+"uri"+"\""};if(vErrors === null){vErrors = [err43];}else {vErrors.push(err43);}errors++;}}else {const err44 = {instancePath:instancePath+"/events/" + i0+"/offers/" + i3+"/url",schemaPath:"#/properties/events/items/properties/offers/items/properties/url/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err44];}else {vErrors.push(err44);}errors++;}}}else {const err45 = {instancePath:instancePath+"/events/" + i0+"/offers/" + i3,schemaPath:"#/properties/events/items/properties/offers/items/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err45];}else {vErrors.push(err45);}errors++;}}}else {const err46 = {instancePath:instancePath+"/events/" + i0+"/offers",schemaPath:"#/properties/events/items/properties/offers/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err46];}else {vErrors.push(err46);}errors++;}}}else {const err47 = {instancePath:instancePath+"/events/" + i0,schemaPath:"#/properties/events/items/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err47];}else {vErrors.push(err47);}errors++;}}}else {const err48 = {instancePath:instancePath+"/events",schemaPath:"#/properties/events/type",keyword:"type",params:{type: "array"},message:"must be array"};if(vErrors === null){vErrors = [err48];}else {vErrors.push(err48);}errors++;}}}else {const err49 = {instancePath,schemaPath:"#/type",keyword:"type",params:{type: "object"},message:"must be object"};if(vErrors === null){vErrors = [err49];}else {vErrors.push(err49);}errors++;}validate20.errors = vErrors;return errors === 0;}
},{"ajv-formats/dist/formats":1}]},{},[2]);
