//
//  UIView+FirstResponder.m
//  WinWin
//
//  Created by Justin Kent on 8/24/13.
//  Copyright (c) 2013 Serdar Karatekin. All rights reserved.
//

#import "UIView+FirstResponder.h"

@implementation UIView (FirstResponder)

- (UIView *)findFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    } return nil;
}

@end
