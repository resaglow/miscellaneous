//
//  YTScrollViewWrapper.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTScrollViewWrapper.h"

@implementation YTScrollViewWrapper

- (instancetype)initWithController:(UIViewController *)viewController
{
    self = [self init];
    
    if (self) {
        self.scrollView = [[YTScrollView alloc] initWithController:viewController];
        [self.scrollView.protectionCodeSwitch addTarget:self
                                                 action:@selector(handleProtectionCodeSwitchChange)
                                       forControlEvents:UIControlEventValueChanged];
        [self handleProtectionCodeSwitchChange];
        [self registerForKeyboardNotifications];
    }
    
    return self;
}

#pragma mark - Switch handler

- (void)handleProtectionCodeSwitchChange
{
    if (self.scrollView.protectionCodeSwitch.on) {
        self.scrollView.protectionCodeView.userInteractionEnabled = YES;
        self.scrollView.protectionCodeView.alpha = 1.0f;
        self.scrollView.protectionCodeView.validityPeriodStepper.enabled = YES;
    } else {
        self.scrollView.protectionCodeView.userInteractionEnabled = NO;
        self.scrollView.protectionCodeView.alpha = 0.3f;
        self.scrollView.protectionCodeView.validityPeriodStepper.enabled = NO;
    }
}

#pragma mark - Keyboard helpers

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardInfoFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, keyboardInfoFrame.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // Make sure the scrollview content size width and height are greater than 0
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
    
    if ([self.scrollView.commentTextView isFirstResponder]) {
        [self.scrollView scrollRectToVisible:self.scrollView.commentTextView.superview.frame animated:YES];
    }
    
}

// Called when the UIKeyboardWillHideNotification is received
- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, 0, 0.0);
                         self.scrollView.contentInset = contentInsets;
                         self.scrollView.scrollIndicatorInsets = contentInsets;
                     }
                     completion:NULL];
}

@end
