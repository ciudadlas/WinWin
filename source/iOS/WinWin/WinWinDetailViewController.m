//
//  WinWinDetailViewController.m
//  WinWin
//
//  Created by Justin Kent on 8/24/13.
//  Copyright (c) 2013 Serdar Karatekin. All rights reserved.
//

#import "WinWinDetailViewController.h"
#import "AFJSONRequestOperation.h"

@interface WinWinDetailViewController ()

@end

@implementation WinWinDetailViewController

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
    
    self.descriptionCopy.editable = NO;
    self.descriptionCopy.backgroundColor = [UIColor clearColor];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"winwin-detail-bg.png"]];
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    self.backersCount.textColor = [UIColor colorWithRed:0.91 green:0.32 blue:0.20 alpha:1];
    self.hitDollars.textColor = [UIColor colorWithRed:0.91 green:0.32 blue:0.20 alpha:1];
    self.missDollars.textColor = [UIColor colorWithRed:0.91 green:0.32 blue:0.20 alpha:1];
    self.backersCountLabel.textColor = [UIColor colorWithRed:0.91 green:0.32 blue:0.20 alpha:1];
    self.hitDollarsLabel.textColor = [UIColor colorWithRed:0.91 green:0.32 blue:0.20 alpha:1];
    self.missDollarsLabel.textColor = [UIColor colorWithRed:0.91 green:0.32 blue:0.20 alpha:1];
    
    self.descriptionCopy.text = [self.winWin objectForKey:@"description"];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Figure out if the user has already endorsed this WinWin, if so disable the Endorse button
    PFQuery *query = [PFQuery queryWithClassName:@"Endorsement"];
    [query whereKey:@"endorser" equalTo:[PFUser currentUser]];
    [query whereKey:@"winwin" equalTo:self.winWin];
    
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        // count tells you how many objects matched the query
        NSLog(@"Existing user endorsment count: %i", count);
        if (count > 0)
        {
            self.endorseButton.selected = YES;
        }
        else
        {
            self.endorseButton.selected = NO;
        }
    }];
    
    // Figure out how many total people have endorsed this WinWin
    PFQuery *query2 = [PFQuery queryWithClassName:@"Endorsement"];
    [query2 whereKey:@"winwin" equalTo:self.winWin];
    
    [query2 countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        // count tells you how many objects matched the query
        NSLog(@"Existing total endorsment count: %i", count);
        if (count > 0)
        {
            self.backersCount.text = [NSString stringWithFormat:@"%i", count];
        }
    }];
    
    // Figure out how many hit $
    
    // Figure out how many miss $


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setWinWin:(PFObject *)winWin {
    _winWin = winWin;
    self.title = [winWin objectForKey:@"name"];
}

- (IBAction)imInButtonTap:(id)sender
{
    if ([sender isSelected])
    {
        // Delete object
        [sender setSelected:NO];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Endorsement"];
        [query whereKey:@"endorser" equalTo:[PFUser currentUser]];
        [query whereKey:@"winwin" equalTo:self.winWin];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
            } else {
                // The find succeeded.
                NSLog(@"Successfully retrieved the object.");
                [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded && !error) {
                        NSLog(@"Endorsement deleted from parse");
                    } else {
                        NSLog(@"error: %@", error); 
                    }
                }];
            }
        }];
        
    }
    else
    {
        // Create Endorsement object
        PFObject *newEndorsement = [PFObject objectWithClassName:@"Endorsement"];
        
        // Set properties
        [newEndorsement setObject:[PFUser currentUser] forKey:@"endorser"];
        [newEndorsement setObject:self.winWin forKey:@"winwin"];
        
        // Save the new Endorsement object
        [newEndorsement saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Dismiss the NewPostViewController and show the BlogTableViewController
                NSLog(@"Created new Endorsement object");
                [sender setSelected:YES];
            }
        }];
        
        NSString *userId = [[PFUser currentUser] objectId];
        NSString *urlString = [NSString stringWithFormat:@"http://winwin.jit.su/getToken?userId=%@", userId];
        NSLog(@"Url string: %@", urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        __weak WinWinDetailViewController *weakSelf = self;
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            NSLog(@"token: %@", [JSON valueForKeyPath:@"token"]);

            //NSString *token = @"EC%2d85P9146718870862H";
            
            NSString *token = [JSON valueForKeyPath:@"token"];
            
            WinWinPayPalWebViewController *webVC = [[WinWinPayPalWebViewController alloc] init];
            webVC.delegate = self;
            
            NSString *urlString = [NSString stringWithFormat:@"https://www.sandbox.paypal.com/webscr?cmd=_express-checkout&token=%@&useraction=commit", token];
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
            
            [weakSelf presentViewController:webVC animated:YES completion:NULL];
            [webVC.webView loadRequest:requestURL];
            
        } failure:nil];
        
        [operation start];
    }
}

#pragma mark - WinWinPayPalWebViewControllerDelegate methods

- (void)didAuthenticate {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismissed PayPal auth web view");
    }];
}

@end
