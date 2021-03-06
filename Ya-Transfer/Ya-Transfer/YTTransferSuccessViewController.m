//
//  YTTranferSuccessViewController.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTTransferSuccessViewController.h"

// TODO: Move out layout setup

static NSString * const kNavItemTitle = @"Success!";

@interface YTTransferSuccessViewController ()

@property (nonatomic) UILabel *successLabel;
@property (nonatomic) UIButton *okButton;
@property (nonatomic) UILabel *protectionCodePromptLabel;
@property (nonatomic) UILabel *protectionCodeLabel;
@property (nonatomic) UILabel *furtherPromptLabel;

@end

@implementation YTTransferSuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = kNavItemTitle;
    
    self.okButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [self.okButton setImage:[[UIImage imageNamed:@"Ok"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.okButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.okButton addTarget:self action:@selector(handleOk) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.okButton];
    
    NSDictionary *uiElements =
    NSDictionaryOfVariableBindings(_okButton//,
//                                   _protectionCodePromptLabel,
//                                   _protectionCodeLabel,
//                                   _furtherPromptLabel
                                   );
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.okButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.okButton
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.okButton
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeWidth
                                                         multiplier:0 constant:self.view.frame.size.width / 2]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.okButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0 constant:self.view.frame.size.width / 2]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_okButton]"
                                                                      options:0 metrics:nil
                                                                        views:uiElements]];
}


- (void)handleOk
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
