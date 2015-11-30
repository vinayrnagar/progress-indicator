var express = require('express');
var app = express();
var glob = require('glob');
var path = require('path');

app.use("/app", express.static(__dirname + "/../../app"));
app.use("/lib", express.static(__dirname + "/../../lib"));
app.use("/dist", express.static(path.resolve(__dirname + "/../../dist")));

// WIP: Look for a better way later
glob('../components/**/test/playground/index.html', undefined, function(error, files) {
  if (error) {
    console.log(error);
    return;
  }

  files.forEach(function(file) {
    var component = file.split('/');
    app.get('/' + component[2], function (req, res) {
       res.sendFile(path.resolve(__dirname + '/' + file));
    });
  });
});

var server = app.listen(5566, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log("Playground started at http://%s:%s", host, port);
});
