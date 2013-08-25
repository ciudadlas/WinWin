//
//  WinWinPayPalWebViewController.m
//  WinWin
//
//  Created by Serdar Karatekin on 8/24/13.
//  Copyright (c) 2013 Serdar Karatekin. All rights reserved.
//

#import "WinWinPayPalWebViewController.h"

@interface WinWinPayPalWebViewController ()

@end

@implementation WinWinPayPalWebViewController

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

#pragma mark - UIWebViewDelegate methods

/*
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *destinationURL = [request.URL absoluteString];
    if ([destinationURL rangeOfString:@""].location != NSNotFound) {
        [self dismiss];
    }
    return YES;
}
*/

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *destinationURL = [self.webView.request.URL absoluteString];
    if ([destinationURL rangeOfString:@"winwin.jit.su/doEC"].location != NSNotFound) {
        [self dismiss];
    }
}

- (void)dismiss {
    if ([self.delegate respondsToSelector:@selector(didAuthenticate)]) {
        [self.delegate didAuthenticate];
    }
}

@end
