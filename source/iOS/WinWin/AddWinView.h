//
//  AddWinView.h
//  WinWin
//
//  Created by Justin Kent on 8/24/13.
//  Copyright (c) 2013 Serdar Karatekin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol AddWinViewDelegate;

@interface AddWinView : UIView <UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet UIView *view;
@property (weak, nonatomic) id <AddWinViewDelegate> delegate;


@end

@protocol AddWinViewDelegate <NSObject>
- (void)tappedAddWin;
- (void)completedAddWin:(PFObject *)winWin;
@end
