let validator = require("./validator.js");

// Start the Elm application.
var app = Elm.Validate.init({
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
