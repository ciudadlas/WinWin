//
//  WinWinHomeViewController.m
//  WinWin
//
//  Created by Serdar Karatekin on 8/24/13.
//  Copyright (c) 2013 Serdar Karatekin. All rights reserved.
//

#import "WinWinHomeViewController.h"
#import "WinWinLoginViewController.h"
#import "WinWinSignUpViewController.h"

@interface WinWinHomeViewController ()

@end

@implementation WinWinHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([PFUser currentUser]) {
        // If the user is logged in, show their name in the welcome label.
        
        if ([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]) {
            // If user is linked to Twitter, we'll use their Twitter screen name
            self.welcomeLabel.text =[NSString stringWithFormat:NSLocalizedString(@"Welcome @%@!", nil), [PFTwitterUtils twitter].screenName];
            
        } else if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            // If user is linked to Facebook, we'll use the Facebook Graph API to fetch their full name. But first, show a generic Welcome label.
            self.welcomeLabel.text =[NSString stringWithFormat:NSLocalizedString(@"Welcome!", nil)];
            
            // Create Facebook Request for user's details
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                // This is an asynchronous method. When Facebook responds, if there are no errors, we'll update the Welcome label.
                if (!error) {
                    NSString *displayName = result[@"name"];
                    if (displayName) {
                        self.welcomeLabel.text =[NSString stringWithFormat:NSLocalizedString(@"Welcome %@!", nil), displayName];
                    }
                }
            }];
            
        } else {
            // If user is linked to neither, let's use their username for the Welcome label.
            self.welcomeLabel.text =[NSString stringWithFormat:NSLocalizedString(@"Welcome %@!", nil), [PFUser currentUser].username];
            
        }
        
    } else {
        self.welcomeLabel.text = NSLocalizedString(@"Not logged in", nil);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([PFUser currentUser])
    {
        NSLog(@"User has logged in");
    }
    else
    {
        // Customize the Log In View Controller
        WinWinLoginViewController *logInViewController = [[WinWinLoginViewController alloc] init];
        logInViewController.delegate = self;
        logInViewController.facebookPermissions = @[@"friends_about_me", @"user_about_me"];
        logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsTwitter | PFLogInFieldsFacebook | PFLogInFieldsSignUpButton | PFLogInFieldsDismissButton;
        
        // Customize the Sign Up View Controller
        WinWinSignUpViewController *signUpViewController = [[WinWinSignUpViewController alloc] init];
        signUpViewController.delegate = self;
        signUpViewController.fields = PFSignUpFieldsDefault | PFSignUpFieldsAdditional;
        logInViewController.signUpController = signUpViewController;
        
        // Present Log In View Controller
        [self presentViewController:logInViewController animated:YES completion:NULL];

    }    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }
    
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    [self verifyCompletedPayment:completedPayment];
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helpers

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    // Send the entire confirmation dictionary
    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
                                                           options:0
                                                             error:nil];
    
    // Send confirmation to your server; your server should verify the proof of payment
    // and give the user their goods or services. If the server is not reachable, save
    // the confirmation and try again later.
}

#pragma mark - ()

- (IBAction)logOutButtonTapAction:(id)sender {
    NSLog(@"Logging user out");
    [PFUser logOut];
    //[self.navigationController popViewControllerAnimated:YES];
    [self viewDidAppear:YES];
}

- (IBAction)paypalButtonTapAction:(id)sender {
    
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithString:@"39.95"];
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Awesome saws";
    
    // Check whether payment is processable.
    if (!payment.processable) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
    }
    else
    {
        // Start out working with the test environment! When you are ready, remove this line to switch to live.
        [PayPalPaymentViewController setEnvironment:PayPalEnvironmentNoNetwork];
        
        // Provide a payerId that uniquely identifies a user within the scope of your system,
        // such as an email address or user ID.
        NSString *aPayerId = @"someuser@somedomain.com";
        
        // Create a PayPalPaymentViewController with the credentials and payerId, the PayPalPayment
        // from the previous step, and a PayPalPaymentDelegate to handle the results.
        PayPalPaymentViewController *paymentViewController;
        paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:@"AdG-QhBPi2ubzrlvAcnlM6EpcTofR2WhSaIWLZS00vIh-qAbOqusFzgTlb3H"
                                                                        receiverEmail:@"karatekinserdar@gmail.com"
                                                                              payerId:aPayerId
                                                                              payment:payment
                                                                             delegate:self];
        
        // Present the PayPalPaymentViewController.
        [self presentViewController:paymentViewController animated:YES completion:nil];        
    }
}

- (IBAction)tapAdd:(id)sender {
    [UIView animateWithDuration:.5
                     animations:^{
                         self.addWinsViewHeightConstraint.constant = self.view.bounds.size.height;
                         [self.view layoutSubviews];
                     }];

}


@end
