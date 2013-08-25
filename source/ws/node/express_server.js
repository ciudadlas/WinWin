var paypal = require('./paypal');
var express = require('express');

app = express();

app.use(express.logger());

app.get('/', function(req, res){
    res.send('Hello World');
});

app.get('/capturePayment', function(req, res) {
	paypal.capturePayment();
});

app.get('/createAuth', function(req, res) {
	var response = paypal.createPayment();
	res.send('Response: ' + response);
});

app.get('/authenticate', function(req, res) {
	paypal.authenticate();
});

app.get('/getToken', function(req, res) {
	var response = paypal.getToken(function(resp) {
		res.writeHead(200, {"Content-Type": "application/json"});
		res.write(resp);
		res.end();
	});
	// res.send('Response: ' + response);
});

app.get('/doEC', function(req, res) {
	var myObj = new Object();
	myObj.data = "Hello There!";
	res.send(myObj);
});

app.listen(8124);
// console.log('Express server started on port %s', app.address().port);