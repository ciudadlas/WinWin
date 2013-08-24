
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("paypalAuthorize", function(request, response) {
	var paypalModule = require("cloud/paypal.js");
	// var paypalSDK = require("cloud/paypal-rest-sdk/lib/paypal-rest-sdk.js");

	if (request.params.username != null && request.params.password != null) {
		response.success("Authorizing PayPal: " + paypalModule.doSomething());	

		var options = {
			host: "https://api.parse.com",
			port: 80,
			path: "1/functions/hello",
			method: "POST"
		};
	}
	else {
		response.error("Failed to authorize: Missing username and/or password");
	}
});