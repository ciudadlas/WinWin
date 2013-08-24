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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([PFUser currentUser])
    {
        NSLog(@"User logged in");
    }
    else
    {
        WinWinLoginViewController *login = [[WinWinLoginViewController alloc] init];
        
        //login.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton;
        
        login.delegate = self;
        login.signUpController.delegate = self;
        
        [self presentViewController:login animated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
