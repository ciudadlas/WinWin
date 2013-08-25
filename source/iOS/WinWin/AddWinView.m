//
//  AddWinView.m
//  WinWin
//
//  Created by Justin Kent on 8/24/13.
//  Copyright (c) 2013 Serdar Karatekin. All rights reserved.
//

#import "AddWinView.h"
#import "UIView+FirstResponder.h"

typedef enum {
	AddWinButtonText = 0,
	AddWinButtonTime = 1,
	AddWinButtonMoney = 2,
    AddWinButtonShare = 3
} AddWinButtons;

typedef enum {
	AddWinTextFieldName = 100,
	AddWinTextFieldWhat = 110,
	AddWinTextFieldWhy = 120,
	AddWinTextFieldWhen = 130,
	AddWinTextFieldAmount = 140,
	AddWinTextFieldToYes = 150,
    AddWinTextFieldToNo = 160
} AddWinTextFields;

@interface AddWinView ()

@property (strong) PFObject *winWin;
@property (assign) BOOL complete;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *textButton;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIButton *moneyButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)tappedAdd:(id)sender;
- (IBAction)tappedAddWinButton:(id)sender;
- (IBAction)tappedSimulatePush:(id)sender;

@end

@implementation AddWinView

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [[NSBundle mainBundle] loadNibNamed:@"AddWinView" owner:self options:nil];
//        [self addSubview:self.view];
//        self.scrollView.contentSize = CGSizeMake(1280,220);
//    }
//    return self;
//}

- (void)awakeFromNib {
    self.scrollView.contentSize = CGSizeMake(1280,220);
    
    self.buttons = @[self.textButton, self.timeButton, self.moneyButton, self.shareButton];
    [self disableButton:self.textButton];
    
    self.scrollView.delegate = self;
    self.segmentedControl.frame = CGRectMake(139, 10, 161, 40);
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
    if (self.complete == NO) {
        [self open];
    }
    else {
        [self close];
    }
}

- (void)open {
    if ([self.delegate respondsToSelector:@selector(tappedAddWin)]) {
        [self.delegate tappedAddWin];
    }
#pragma warn - just for debugging
    self.complete = YES;
}

- (void)close {
    // Create object
    PFObject *winWin = [PFObject objectWithClassName:@"WinWin"];
    
    // Set properties
    [winWin setObject:[PFUser currentUser] forKey:@"creator"];
    [winWin setObject:@"Workout once a week" forKey:@"name"];
    [winWin setObject:@"I'm trying to stay in shape. This means a lot to me. Team up with my challenge. Every time I work out, you help pay for my workout class. If I miss my class, the money will benefit the Alzheimer's Foundation of America." forKey:@"description"];
    [winWin setObject:@"hitemail@gmail.com" forKey:@"hit_email"];
    [winWin setObject:@"missemail@gmail.com" forKey:@"miss_email"];
    [winWin setObject:@"M" forKey:@"confirmation_day"]; // M, T, W, Tr, F, Sa, Su
    [winWin setObject:@"4:15" forKey:@"confirmation_time"]; // Time
    [winWin setObject:[NSNumber numberWithInt:0] forKey:@"frequency"]; //0,1,2
    
    if ([self.delegate respondsToSelector:@selector(completedAddWin:)]) {
        [self.delegate completedAddWin:winWin];
    }
    [self resetState];
}

- (void)resetState {
    self.complete = NO;
}

- (IBAction)tappedAddWinButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self disableButton:button];
    CGFloat xOffset = button.tag * self.scrollView.frame.size.width;
    CGRect offsetFrame = CGRectMake(xOffset, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView scrollRectToVisible:offsetFrame animated:YES];
}

- (IBAction)tappedSimulatePush:(id)sender {
    if ([self.delegate respondsToSelector:@selector(simulatePush)]) {
        [self.delegate simulatePush];
    }
}

- (void)disableButton:(UIButton *)button {
    for (UIButton *aButton in self.buttons) {
        BOOL disableButton = aButton == button;
        aButton.enabled = !disableButton;
    }
    [[self findFirstResponder] resignFirstResponder];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self disableAppropriateButton];
}

- (void)disableAppropriateButton {
    int page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    UIButton *button = [self buttonForTag:page];
    [self disableButton:button];
}

- (UIButton *)buttonForTag:(int)tag {
    UIButton *button = nil;
    for (UIButton *aButton in self.buttons) {
        if (aButton.tag == tag) {
            button = aButton;
        }
    }
    return button;
}

@end
