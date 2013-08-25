var APP_ID = "AQsFyNyhNcS88YHvdSM2xNudh8ZZTd2U2W8PPHvf";
var MASTER_KEY = "dCxgvw2as9frnEz4AUi6pnIgVtS5k2IiJURsZQlU";
var JS_KEY = "NC3JMJjrTdvfuHUup0QKTlobkXillVpQoUMzhnLA";

var paypal_sdk = require('paypal-rest-sdk');
var jQ = require('jquery');
var async = require('async');
var Parse = require('parse').Parse;
Parse.initialize(APP_ID, JS_KEY);

function configure() {
	paypal_sdk.configure({
		'host': 'api.sandbox.paypal.com',
		'client_id': 'AdG-QhBPi2ubzrlvAcnlM6EpcTofR2WhSaIWLZS00vIh-qAbOqusFzgTlb3H',
		'client_secret': ''
	});
}

exports.getToken = function(callback, req) {
	var url = "https://api-3t.sandbox.paypal.com/nvp";
	var user = "karatekinserdar-facilitator_api1.gmail.com";
	var pwd = "1377356831";
	var signature = "AFcWxV21C7fd0v3bYYYRCpSSRl31AF.pqE60zi4L8.5DxdUYbLx.iE..";
	var amount = "1.00";
	var currency = "USD";
	// var urlFail = "http%3a%2f%2flocalhost%3a4555%2fGetECDetails.aspx";
	var urlFail = "http://winwin.jit.su/doECFail"
	var urlSuccess = "http://winwin.jit.su/doEC";

	var payload = "USER=" + user + "&PWD=" + pwd + "&SIGNATURE=" + signature + "&VERSION=94.0&METHOD=SETEXPRESSCHECKOUT&PAYMENTREQUEST_0_AMT=" + amount + "&RETURNURL=" + urlSuccess + "&CANCELURL=" + urlFail + "&PAYMENTREQUEST_0_CURRENCYCODE=" + currency + "&PAYMENTREQUEST_0_PAYMENTACTION=Sale&L_BILLINGTYPE0=MerchantInitiatedBilling&L_PAYMENTTYPE0=Any&ALLOWNOTE=0";

	// console.log("Hitting " + url + " with payload: " + payload);

	var resp = "";
	var userId = "";

	jQ.ajax({
		type: "POST",
		url: url,
		data: payload,
		aysnc: false,
		success: function(response) {
			var token = response.substring(6, response.indexOf("&"));
			userId = req.param("userId");
			
			var jsonResponse = new Object();
			jsonResponse.token = token;
			jsonResponse.userId = userId;

			console.log("Success: " + response + " - Token: " + token);
			console.log("Request: " + userId);

			resp = JSON.stringify(jsonResponse);
			console.log("Response: " + resp + " URL: " + url);
	
			var UserPaypalInfo = Parse.Object.extend("UserPaypalInfo");
			var query = new Parse.Query(UserPaypalInfo);
			query.get(userId, {
				success: function(user) {
					console.log("User: " + user.get("username"));
					user.set("additional", "testdata");
					user.save(null, {
						success: function(user) {
							console.log("Updated user");
						},
						error: function(user, error) {

						}
					});
				},
				error: function(user, error) {
					console.error(error.message);

					var newUser = new UserPaypalInfo();
					newUser.set("user_id", userId);
					newUser.set("token", token);
					newUser.save(null, {
						success: function(newUser) {
							console.log("User created");
						},
						error: function(newUser, error) {
							console.error(error.message);
						}
					});
				}
			})
			// query.equalTo("objectId", userId);
			// query.first({
			// 	success: function(user) {
			// 		user.set('token', token);
			// 		user.save();
			// 		console.log(user.get("username"));
			// 		// for (var i = 0; i < users.length; i++) {
			// 		// 	console.log(users[i].get("username"));
			// 		// }
			// 	},
			// 	error: function(error) {
			// 		console.error("Error: " + error.message);
			// 	}
			// })

			callback(resp);
		}
	});

	return resp;
}

exports.doEC = function(callback, req) {
	var url = "https://api-3t.sandbox.paypal.com/nvp";
	var user = "karatekinserdar-facilitator_api1.gmail.com";
	var pwd = "1377356831";
	var signature = "AFcWxV21C7fd0v3bYYYRCpSSRl31AF.pqE60zi4L8.5DxdUYbLx.iE..";
	var amount = "1.00";
	var currency = "USD";
	var payerId = req.param("PayerID");
	var token = req.param("token");
	
	var payload = "USER=" + user + "&PWD=" + pwd + "&SIGNATURE=" + signature + "&VERSION=94.0&METHOD=DoExpressCheckoutPayment&TOKEN=" + token + "&PAYMENTREQUEST_0_PAYMENTACTION=Sale&PAYERID=" + payerId + "&PAYMENTREQUEST_0_AMT=" + amount + "&PAYMENTREQUEST_0_CURRENCYCODE=" + currency;
}

exports.authenticate = function() {
	console.log("Attempting to authenticate");
	
	configure();

	paypal_sdk.generate_token(function(error, token) {
		if(error) {
			console.error(error);
		}
		else {
			console.log("token: " + token);
		}
	})
}

exports.createPayment = function() {
	var payment_details = {
		"intent": "authorize",
		"payer": {
		"payment_method": "credit_card",
		"funding_instruments": [{
		  "credit_card": {
		    "type": "visa",
		    "number": "4417119669820331",
		    "expire_month": "11",
		    "expire_year": "2018",
		    "cvv2": "874",
		    "first_name": "Joe",
		    "last_name": "Shopper",
		    "billing_address": {
		      "line1": "52 N Main ST",
		      "city": "Johnstown",
		      "state": "OH",
		      "postal_code": "43210",
		      "country_code": "US" }}}]},
		"transactions": [{
		"amount": {
		  "total": "30.00",
		  "currency": "USD",
		  "details": {
		    "subtotal": "30.00",
		    "tax": "0.00",
		    "shipping": "0.00"}},
		"description": "This is the payment transaction description." }]
	};

	configure();

	paypal_sdk.payment.create(payment_details, function(error, payment) {
		if(error) {
			console.error(error);
		}
		else {
			console.log("Authorization ID: " + payment.transactions[0].related_resources[0].authorization.id);
			return payment.transactions[0].related_resources[0].authorization.id;
		}
	});
}

exports.capturePayment = function() {
	var capture_details = {
		"amount": {
		"currency": "USD",
		"total": "5.00" },
		"is_final_capture": false
	};

	configure();

	paypal_sdk.authorization.capture("54F8277293897050K", capture_details, function(error, capture){
		if(error){
			console.error(error);
		}
		else {
			console.log(capture);
		}
	});
}