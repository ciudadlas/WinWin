var paypal = require('./paypal');

exports.route = function(pathname) {
  console.log("About to route a request for " + pathname);

  if (pathname == '/paypalAuthentication') {
  	console.log("Paypal Authentication");
  	paypal.authenticate();
  }
}