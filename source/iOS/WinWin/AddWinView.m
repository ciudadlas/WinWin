//
//  AddWinView.m
//  WinWin
//
//  Created by Justin Kent on 8/24/13.
//  Copyright (c) 2013 Serdar Karatekin. All rights reserved.
//

#import "AddWinView.h"

@interface AddWinView ()

@property (strong) PFObject *winWin;

- (IBAction)tappedAdd:(id)sender;
- (IBAction)tappedDone:(id)sender;

@end

@implementation AddWinView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"AddWinView" owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)tappedAdd:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tappedAddWin)]) {
        [self.delegate tappedAddWin];
    }
}

- (IBAction)tappedDone:(id)sender {
    if ([self.delegate respondsToSelector:@selector(completedAddWin:)]) {
        [self.delegate completedAddWin:nil];
    }
}

@end
