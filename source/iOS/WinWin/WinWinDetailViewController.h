//
//  WinWinDetailViewController.h
//  WinWin
//
//  Created by Justin Kent on 8/24/13.
//  Copyright (c) 2013 Serdar Karatekin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface WinWinDetailViewController : UIViewController

@property (strong, nonatomic) PFObject *winWin;

- (IBAction)imInButtonTap:(id)sender;

@end
