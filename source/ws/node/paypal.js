var paypal_sdk = require('paypal-rest-sdk');
var jQ = require('jquery');
var async = require('async');

function configure() {
	paypal_sdk.configure({
		'host': 'api.sandbox.paypal.com',
		'client_id': 'AdG-QhBPi2ubzrlvAcnlM6EpcTofR2WhSaIWLZS00vIh-qAbOqusFzgTlb3H',
		'client_secret': ''
	});
}

exports.getToken = function(callback) {
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

	jQ.ajax({
		type: "POST",
		url: url,
		data: payload,
		aysnc: false,
		success: function(response) {
			var token = response.substring(6, response.indexOf("&"));
			
			var jsonResponse = new Object();
			jsonResponse.token = token;

			console.log("Success: " + response + " - Token: " + token);

			resp = JSON.stringify(jsonResponse);
			console.log("Response: " + resp + " URL: " + url);

			callback(resp);
		}
	});
	
	return resp;
}

exports.doEC = function() {
	var url = "https://api-3t.sandbox.paypal.com/nvp";
	var user = "karatekinserdar-facilitator_api1.gmail.com";
	var pwd = "1377356831";
	var signature = "AFcWxV21C7fd0v3bYYYRCpSSRl31AF.pqE60zi4L8.5DxdUYbLx.iE..";
	var amount = "1.00";
	var currency = "USD";
	
	var payload = "USER=" + user + "&PWD=" + pwd + "&SIGNATURE=" + signature + "&VERSION=94.0&METHOD=DoExpressCheckoutPayment&TOKEN=" + token + "&PAYMENTREQUEST_0_PAYMENTACTION=Sale&PAYERID=HXE69D5N7AQBU&PAYMENTREQUEST_0_AMT=" + amount + "&PAYMENTREQUEST_0_CURRENCYCODE=" + currency;
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