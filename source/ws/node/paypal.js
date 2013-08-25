// Parse params
var APP_ID = "AQsFyNyhNcS88YHvdSM2xNudh8ZZTd2U2W8PPHvf";
var MASTER_KEY = "dCxgvw2as9frnEz4AUi6pnIgVtS5k2IiJURsZQlU";
var JS_KEY = "NC3JMJjrTdvfuHUup0QKTlobkXillVpQoUMzhnLA";

// requires
var paypal_sdk = require('paypal-rest-sdk');
var jQ = require('jquery');
var async = require('async');
var Parse = require('parse').Parse;
Parse.initialize(APP_ID, JS_KEY);

var debugPayPal = false;

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
	var method = "SETEXPRESSCHECKOUT";
	// var urlFail = "http%3a%2f%2flocalhost%3a4555%2fGetECDetails.aspx";
	var urlFail = "http://winwin.jit.su/doECFail"
	var urlSuccess = "http://winwin.jit.su/doEC";

	var payload = "USER=" + user + "&PWD=" + pwd + "&SIGNATURE=" + signature + "&VERSION=94.0&METHOD=" + method + "&PAYMENTREQUEST_0_AMT=" + amount + "&RETURNURL=" + urlSuccess + "&CANCELURL=" + urlFail + "&PAYMENTREQUEST_0_CURRENCYCODE=" + currency + "&PAYMENTREQUEST_0_PAYMENTACTION=Sale&L_BILLINGTYPE0=MerchantInitiatedBilling&L_PAYMENTTYPE0=Any&ALLOWNOTE=0";

	// console.log("Hitting " + url + " with payload: " + payload);

	var resp = "";
	var userId = "";

	jQ.ajax({
		type: "POST",
		url: url,
		data: payload,
		aysnc: false,
		success: function(response) {
			var token = response.substring(6, response.indexOf("&")).replace("%2d", "-");
			userId = req.param("userId");
			
			var jsonResponse = new Object();
			jsonResponse.token = token;
			jsonResponse.userId = userId;

			// console.log("Success: " + response + " - Token: " + token);
			// console.log("Request: " + userId);

			resp = JSON.stringify(jsonResponse);
			// console.log("Response: " + resp + " URL: " + url);
			savePayPalTransaction(method, payload, response);
	
			var UserPaypalInfo = Parse.Object.extend("UserPaypalInfo");
			var query = new Parse.Query(UserPaypalInfo);
			query.equalTo("user_id", userId);
			query.first({
				success: function(user) {
					if (user != undefined) {
						user.set("token", token);
						user.save(null, {
							success: function(user) {
								console.log("Updated user");
							},
							error: function(user, error) {

							}
						});
					}
					else {
						createUser(UserPaypalInfo, userId, token);
					}
					// console.log("User: " + user.get("username"));
				},
				error: function(error) {
					console.error(error.message);

					createUser(UserPaypalInfo, userId, token);
				}
			});

			callback(resp);
		}
	});

	return resp;
}

function createUser(UserPaypalInfo, userId, token, payerId) {
	var newUser = new UserPaypalInfo();
	newUser.set("user_id", userId);
	newUser.set("token", token);
	if (payerId != null && payerId != undefined) {
		newUser.set("payerId", payerId);
	}
	newUser.save(null, {
		success: function(newUser) {
			console.log("User created");
		},
		error: function(newUser, error) {
			console.error(error.message);
		}
	});
}

exports.makeUser = function() {
	var UserPaypalInfo = Parse.Object.extend("UserPaypalInfo");
	createUser(UserPaypalInfo, "newUserId", "newToken", "newPayerId");
}

exports.doEC = function(callback, req) {
	var url = "https://api-3t.sandbox.paypal.com/nvp";
	var user = "karatekinserdar-facilitator_api1.gmail.com";
	var pwd = "1377356831";
	var signature = "AFcWxV21C7fd0v3bYYYRCpSSRl31AF.pqE60zi4L8.5DxdUYbLx.iE..";
	var amount = "1.00";
	var currency = "USD";
	var method = "DoExpressCheckoutPayment";
	var payerId = req.param("PayerID");
	var token = req.param("token").replace("%2d", "-");
	
	var payload = "USER=" + user + "&PWD=" + pwd + "&SIGNATURE=" + signature + "&VERSION=94.0&METHOD=" + method + "&TOKEN=" + token + "&PAYMENTREQUEST_0_PAYMENTACTION=Sale&PAYERID=" + payerId + "&PAYMENTREQUEST_0_AMT=" + amount + "&PAYMENTREQUEST_0_CURRENCYCODE=" + currency;

	console.log("looking for token: " + token);

	jQ.ajax({
		type: "POST",
		url: url,
		data: payload,
		aysnc: false,
		success: function(response) {
			var billerIndex = response.indexOf("AGREEMENTID=") + 12;
			var billerAgreementId = response.substring(billerIndex, response.indexOf("&", billerIndex + 1)).replace("%2d", "-");
			console.log("billerAgreementId: " + billerAgreementId);
			// var jsonResponse = new Object();
			// jsonResponse.token = token;
			// jsonResponse.userId = userId;

			// // console.log("Success: " + response + " - Token: " + token);
			// // console.log("Request: " + userId);

			// resp = JSON.stringify(jsonResponse);
			// // console.log("Response: " + resp + " URL: " + url);

			savePayPalTransaction(method, payload, response);

			var UserPaypalInfo = Parse.Object.extend("UserPaypalInfo");
			var query = new Parse.Query(UserPaypalInfo);
			query.equalTo("token", token);
			query.first({
				success: function(user) {
					if (user != undefined) {
						user.set("payerId", payerId);
						user.set("billerAgreementId", billerAgreementId);
						user.save(null, {
							success: function(user) {
								console.log("Updated user");
							},
							error: function(user, error) {
								console.error(error.message);
							}
						});
					}
					// console.log("User: " + user.get("username"));
				},
				error: function(error) {
					console.error(error.message);
					// createUser(UserPaypalInfo, "tempUser", "fakeToken", payerId);
				}
			});
		}
	});

	callback();
}

exports.doRT = function(callback, req) {
	var userId = req.param("userId");
	var url = "https://api-3t.sandbox.paypal.com/nvp";
	var pp_user = "karatekinserdar-facilitator_api1.gmail.com";
	var pwd = "1377356831";
	var signature = "AFcWxV21C7fd0v3bYYYRCpSSRl31AF.pqE60zi4L8.5DxdUYbLx.iE..";
	var amount = "1.00";
	var currency = "USD";
	var method = "DoReferenceTransaction";
	var UserPaypalInfo = Parse.Object.extend("UserPaypalInfo");
	var query = new Parse.Query(UserPaypalInfo);
	query.equalTo("user_id", userId);
	query.first({
		success: function(user) {
			var billerAgreementId = user.get("billerAgreementId");
			var payload = 
				"USER=" + pp_user + 
				"&PWD=" + pwd + 
				"&SIGNATURE=" + signature + 
				"&VERSION=94.0&METHOD=" + method + 
				"&REFERENCEID=" + billerAgreementId + 
				"&PAYMENTACTION=Sale&AMT=" + amount + 
				"&CURRENCYCODE=" + currency;

			console.log("Payload: " + payload);
			jQ.ajax({
			type: "POST",
			url: url,
			data: payload,
			aysnc: false,
			success: function(response) {
				savePayPalTransaction(method, payload, response);
		}
	});

		},
		error: function(user, error) {
			console.error("Error: " + JSON.stringify(error));
		}
	});

	callback();
}

function savePayPalTransaction(method, payload, response) {
	if (debugPayPal) {
		var PaypalTransaction = Parse.Object.extend("PaypalTransaction");
		var paypalTransaction = new PaypalTransaction();
		paypalTransaction.set("method", method);
		paypalTransaction.set("payload", payload);
		paypalTransaction.set("response", response);
		paypalTransaction.save(null, {
			success: function(user) {
				console.log("PayPal Transaction saved.");
			},
			error: function(error) {
				console.error(error.message);
			}
		});
	}
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

exports.processWinWinAction = function(callback, req) {
	// req params
	var wwId = req.param("wwId");
	var hit = req.param("hit");

	// lookup params
	var hitEmail;
	var missEmail;
	var aEndorsers = new Array();

	// get hit/miss email of WW
	var WinWin = Parse.Object.extend("WinWin");
	var wwQuery = new Parse.Query(WinWin);
	var myWW;
	wwQuery.equalTo("objectId", wwId);
	wwQuery.first({
		success: function(winwin) {
			myWW = winwin;
			hitEmail = winwin.get("hit_email");
			missEmail = winwin.get("miss_email");
			console.log("WinWin Name: " + winwin.get("name"));
			console.log("Hit Email: " + hitEmail);
			console.log("Miss Email: " + missEmail);

			// get all endorsers of WW
			var Endorsement = Parse.Object.extend("Endorsement");
			var endQuery = new Parse.Query(Endorsement);
			endQuery.equalTo("winwin", myWW);
			console.log("Looking for endorsers of: " + wwId);
			endQuery.find({
				success: function(endorsers) {
					for (var i = 0; i < endorsers.length; i++) {
						var endorser = endorsers[i].get("endorser");
						aEndorsers.push(endorser);
						console.log("Endorser: " + endorser.id);
					}

					console.log("Number of endorsers: " + aEndorsers.length);

					for (var i = 0; i < aEndorsers.length; i++) {	
						var endorser = aEndorsers[i];
						if (hit) {
							// record transaction for winwin creator
							createTransaction(winwin, hitEmail, endorser, hit);
						}
						else {
							// record transaction for charity
							createTransaction(winwin, missEmail, endorser, hit);
						}	
					}
				},
				error: function(error) {
					console.log(error.message);
				}
			});
		},
		error: function(error) {
			console.log(error.message);
		}
	});



	callback();
}

function createTransaction(ww, email, endorser, hit) {
	var Transaction = Parse.Object.extend("Transaction");
	var transaction = new Transaction();

	console.log("Creating transaction for: ");
	console.log("WinWin: " + ww);
	console.log("Payment Email: " + email);
	console.log("Endorser: " + endorser.id);

	transaction.set("winwin", ww);
	transaction.set("recipient", email);
	transaction.set("endorser", endorser);
	transaction.set("amount", 1.00);
	transaction.set("hit", hit);

	transaction.save(null, {
		success: function(transaction) {
			console.log("Created transaction");
		},
		error: function(error) {
			console.error(error.message);
		}
	});

	var WinWinData = Parse.Object.extend("WinWinData");	
	var wwdQuery = new Parse.Query(WinWinData);
	wwdQuery.equalTo("winwin", ww);
	wwdQuery.first({
		success: function(winwinData) {
			if (winwinData != undefined) {
				var totalHits = (winwinData.get("hits") == undefined ? 0 : winwinData.get("hits"));
				var totalMisses = (winwinData.get("misses") == undefined ? 0 : winwinData.get("misses"));
				
				console.log("Total Hits: " + totalHits);
				console.log("Total Misses: " + totalMisses);

				if (hit == "true") {
					totalHits++;
				}
				else {
					totalMisses++;
				}

				winwinData.set("hits", totalHits);
				winwinData.set("misses", totalMisses);
				winwinData.set("winwin", ww);

				winwinData.save(null, {
					success: function(winwinData) {
						console.log("Updated WinWinData Object");
					},
					error: function(winwinData, error) {
						console.error("Error: " + JSON.stringify(error)); 
					}
				});
			}
			else {
				var winwinData = new WinWinData();

				winwinData.set("hits", (hit == "true" ? 1 : 0));
				winwinData.set("misses", (hit == "false" ? 0 : 1));
				winwinData.set("winwin", ww);

				winwinData.save(null, {
					success: function(winwinData) {
						console.log("Updated WinWinData Object");
					},
					error: function(winwinData, error) {
						console.error("Error: " + JSON.stringify(error)); 
					}
				});
			}
		},
		error: function(winwinData, error) {
			console.error("Error: " + JSON.stringify(error));
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