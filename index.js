var express = require('express');
var app = express();

app.use("/dist", express.static(__dirname + "/dist"));
app.use("/app", express.static(__dirname + "/app"));
app.use("/lib", express.static(__dirname + "/lib"));

app.get('/', function (req, res) {
   res.sendFile(__dirname + '/app/index.html');
});

var server = app.listen(3000, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log("Server started at http://%s:%s", host, port);
});