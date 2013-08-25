//
//  WinWinLoginViewController.m
//  WinWin
//
//  Created by Serdar Karatekin on 8/24/13.
//  Copyright (c) 2013 Serdar Karatekin. All rights reserved.
//

#import "WinWinLoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WinWinLoginViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation WinWinLoginViewController

@synthesize fieldsBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
      
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"signup-bg.png"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"winwin-logo.png"]]];
    
    // Set buttons appearance
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"Exit.png"] forState:UIControlStateNormal];
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"ExitDown.png"] forState:UIControlStateHighlighted];
    
    [self.logInView.facebookButton setImage:nil forState:UIControlStateNormal];
    [self.logInView.facebookButton setImage:nil forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"facebook-logo.png"] forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"facebook-logo.png"] forState:UIControlStateNormal];
    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateHighlighted];
    
    [self.logInView.twitterButton setImage:nil forState:UIControlStateNormal];
    [self.logInView.twitterButton setImage:nil forState:UIControlStateHighlighted];
    [self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter-logo.png"] forState:UIControlStateNormal];
    [self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter-logo.png"] forState:UIControlStateHighlighted];
    [self.logInView.twitterButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.twitterButton setTitle:@"" forState:UIControlStateHighlighted];
    
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signup.png"] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signup.png"] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Add login field background
    fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-bg.png"]];
    [self.logInView addSubview:self.fieldsBackground];
    [self.logInView sendSubviewToBack:self.fieldsBackground];
    
    
    /*
    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
     */
    
    
    [self.logInView.usernameField setTextColor:[UIColor whiteColor]];
    [self.logInView.passwordField setTextColor:[UIColor whiteColor]];
    
    [self.logInView.signUpLabel setTextColor:[UIColor whiteColor]];
    [self.logInView.externalLogInLabel setTextColor:[UIColor whiteColor]];

    
    [self.logInView.signUpLabel setFont:[UIFont systemFontOfSize:14]];
    [self.logInView.externalLogInLabel setFont:[UIFont systemFontOfSize:14]];


    
        
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    
//    [self.logInView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
    
    CGRect loginFrame = self.logInView.logo.frame;
    loginFrame.origin.y = 22.0f;
    [self.logInView.logo setFrame:loginFrame];
    
    CGRect externalLabelFrame = self.logInView.externalLogInLabel.frame;
    externalLabelFrame.origin.y = externalLabelFrame.origin.y - 50.0f;
    [self.logInView.externalLogInLabel setFrame:externalLabelFrame];

    [self.logInView.facebookButton setFrame:CGRectMake(35.0f+45.0f, 330.0f, 66.0f, 66.0f)];
    [self.logInView.twitterButton setFrame:CGRectMake(35.0f+135.0f, 330.0f, 67.0f, 66.0f)];
    
    
//    [self.logInView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    [self.logInView.usernameField setFrame:CGRectMake(35.0f, 153.0f, 250.0f, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(35.0f, 203.0f, 250.0f, 50.0f)];
    [self.fieldsBackground setFrame:CGRectMake(35.0f, 155.0f, 250.0f, 100.0f)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
