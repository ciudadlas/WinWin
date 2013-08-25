//
//  WinWinDetailViewController.h
//  WinWin
//
//  Created by Justin Kent on 8/24/13.
//  Copyright (c) 2013 Serdar Karatekin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "WinWinPayPalWebViewController.h"


@interface WinWinDetailViewController : UIViewController <WinWinPayPalWebViewControllerDelegate>

@property (strong, nonatomic) PFObject *winWin;

@property (weak, nonatomic) IBOutlet UIButton *endorseButton;

@property (weak, nonatomic) IBOutlet UILabel *backersCount;
@property (weak, nonatomic) IBOutlet UILabel *hitDollars;
@property (weak, nonatomic) IBOutlet UILabel *missDollars;

@property (weak, nonatomic) IBOutlet UILabel *backersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *hitDollarsLabel;
@property (weak, nonatomic) IBOutlet UILabel *missDollarsLabel;

@property (weak, nonatomic) IBOutlet UITextView *descriptionCopy;

- (IBAction)imInButtonTap:(id)sender;

@end
