var paypal = require('./paypal');
var express = require('express');
// var loggly = require('loggly');
// var config = {
// 	subdomain: "winwin",
// 	auth: {
// 		username: "aikenben",
// 		password: "TOB3sukml3zyi3"
// 	}
// };

// var client = loggly.createClient(config);

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
	}, req);
	// res.send('Response: ' + response);
});

app.get('/doEC', function(req, res) {
	// console.log("doEC called from PayPal");
	paypal.doEC(
		function() {
			res.send("doEC");
		},
		req);
	// var myObj = new Object();
	// myObj.token = req.param('token');
	// myObj.PayerID = req.param('PayerID');
	// console.log("Request: " + req.param('token') + " " + req.param('PayerID'));
	// res.send(myObj);

});

app.get('/processWWAction', function(req, res) {
	var response = paypal.processWinWinAction(
		function() {
			res.writeHead(200, {"Content-Type": "application/json"});
			res.write("OK");
			res.end();
		},
		req
	)
});

app.get('/doRT', function(req, res) {
	paypal.doRT(function() {
			res.send("Done");
		},
		req);
});

app.listen(8124);
// console.log('Express server started on port %s', app.address().port);