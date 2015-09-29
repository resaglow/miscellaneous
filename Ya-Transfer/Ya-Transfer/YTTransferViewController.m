//
//  YTTransferViewController.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 28/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTTransferViewController.h"
#import "YTScrollView.h"
#import "YTUserInfo.h"

// TODO Clear out constants

@interface YTTransferViewController () <UITextViewDelegate>

@property (nonatomic) YTScrollView *scrollView;
@property (nonatomic) YTUserInfo *userInfo;

@end

@implementation YTTransferViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithWhite:.85f alpha:1.0f];
    [self setupViews];
    
    [self registerForKeyboardNotifications];
}

- (void)setupViews
{
    self.scrollView = [[YTScrollView alloc] initWithController:self];
    self.scrollView.moneyLeftLabel.text = self.userInfo.moneyLeft ?
    [@"Money left: " stringByAppendingString:self.userInfo.moneyLeft] :
    @"Can't fetch left money";
    
    [self.scrollView.protectionCodeSwitch addTarget:self
                                             action:@selector(handleProtectionCodeSwitchChange)
                                   forControlEvents:UIControlEventValueChanged];
    
    self.userInfo = [[YTUserInfo alloc] initWithCurrentUserInfo];
}


#pragma mark - Switch handler

- (void)handleProtectionCodeSwitchChange
{
    if (self.scrollView.protectionCodeSwitch.on) {
        self.scrollView.protectionCodeView.userInteractionEnabled = YES;
        self.scrollView.protectionCodeView.alpha = 1.0f;
    } else {
        self.scrollView.protectionCodeView.userInteractionEnabled = NO;
        self.scrollView.protectionCodeView.alpha = 0.3f;
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(64, 0.0, keyboardInfoFrame.size.height, 0.0);
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
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(64, 0.0, 0, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;

}

@end
