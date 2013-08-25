//
//  WinWinDetailViewController.m
//  WinWin
//
//  Created by Justin Kent on 8/24/13.
//  Copyright (c) 2013 Serdar Karatekin. All rights reserved.
//

#import "WinWinDetailViewController.h"
#import "WinWinPayPalWebViewController.h"
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setWinWin:(PFObject *)winWin {
    self.title = [winWin objectForKey:@"name"];
}

- (IBAction)imInButtonTap:(id)sender
{
    
    NSURL *url = [NSURL URLWithString:@"http://httpbin.org/ip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"token: %@", [JSON valueForKeyPath:@"token"]);
        //NSString *token = @"EC%2d85P9146718870862H";
        
        NSString *token = [JSON valueForKeyPath:@"token"];
        
        WinWinPayPalWebViewController *webVC = [[WinWinPayPalWebViewController alloc] init];
        
        NSString *urlString = [NSString stringWithFormat:@"https://www.sandbox.paypal.com/webscr?cmd=_express-checkout&token=%@&useraction=commit", token];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
        
        [self presentViewController:webVC animated:YES completion:NULL];
        [webVC.webView loadRequest:requestURL];
        
    } failure:nil];
    
    [operation start];
}

@end