//
//  WinWinPayPalWebViewController.h
//  WinWin
//
//  Created by Serdar Karatekin on 8/24/13.
//  Copyright (c) 2013 Serdar Karatekin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WinWinPayPalWebViewControllerDelegate;

@interface WinWinPayPalWebViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) id <WinWinPayPalWebViewControllerDelegate> delegate;

@end


@protocol WinWinPayPalWebViewControllerDelegate <NSObject>

- (void)didAuthenticate;

@end
