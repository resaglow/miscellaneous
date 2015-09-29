//
//  YTScrollView.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTScrollView.h"

@interface YTScrollView ()

@property (nonatomic) UIViewController *vc;

@end

@implementation YTScrollView

- (instancetype)initWithController:(UIViewController *)viewController
{
    self = [super init];
    
    if (self) {
        self.vc = viewController;
        [self setupLayout];
    }
    
    return self;
}

- (void)setupLayout
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    //    self.backgroundColor = [UIColor greenColor];
    [self.vc.view addSubview:self];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    //    self.contentView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.contentView];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(self, _contentView);
    
    [self.vc.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[self]-(0)-|"
                                                                         options:0 metrics:nil
                                                                           views:viewsDictionary]];
    [self.vc.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[self]-(0)-|"
                                                                         options:0 metrics:nil
                                                                           views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_contentView]-(0)-|"
                                                                 options:0 metrics:nil
                                                                   views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_contentView]-(0)-|"
                                                                 options:0 metrics:nil
                                                                   views:viewsDictionary]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1 constant:0]];
    
    [self addContentSubViews];
}

- (void)addContentSubViews
{
    self.moneyLeftLabel = [[YTLabelInfo alloc] init];
    self.moneyLeftLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.moneyLeftLabel];
    
    self.recipientLabel = [[YTLabelHeader alloc] init];
    self.recipientLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.recipientLabel.text = @"Recipient";
    [self.contentView addSubview:self.recipientLabel];
    
    self.recipientTextField = [[YTTextField alloc] init];
    self.recipientTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.recipientTextField.placeholder = @"username/account";
    [self.contentView addSubview:self.recipientTextField];
    
    self.toPayLabel = [[YTLabelHeader alloc] init];
    self.toPayLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.toPayLabel.text = @"To pay";
    [self.contentView addSubview:self.toPayLabel];
    
    self.toPayTextField = [[YTTextFieldCurrency alloc] init];
    self.toPayTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.toPayTextField];
    
    self.commissionLabel = [[YTLabelInfo alloc] init];
    self.commissionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.commissionLabel.text = @"Current commission is 0.05%";
    [self.contentView addSubview:self.commissionLabel];
    
    self.toBePaidLabel = [[YTLabelHeader alloc] init];
    self.toBePaidLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.toBePaidLabel.text = @"To be paid";
    [self.contentView addSubview:self.toBePaidLabel];
    
    self.protectionCodeSwitch = [[UISwitch alloc] init];
    self.protectionCodeSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    self.protectionCodeSwitch.onTintColor = [UIColor orangeColor];
    [self.contentView addSubview:self.protectionCodeSwitch];
    
    self.toBePaidTextField = [[YTTextFieldCurrency alloc] init];
    self.toBePaidTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.toBePaidTextField.enabled = NO;
    [self.contentView addSubview:self.toBePaidTextField];
    
    self.protectionCodeLabel = [[YTLabelHeader alloc] init];
    self.protectionCodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.protectionCodeLabel.text = @"Protection code";
    [self.contentView addSubview:self.protectionCodeLabel];
    
    self.protectionCodeView = [[YTViewProtectionCode alloc] init];
    self.protectionCodeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.protectionCodeView];
    
    self.commentTextView = [[YTTextView alloc] init];
    self.commentTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.commentTextView];
    
    NSDictionary *viewsDictionary =
    NSDictionaryOfVariableBindings(_moneyLeftLabel,
                                   _recipientLabel,
                                   _recipientTextField,
                                   _toPayLabel,
                                   _toPayTextField,
                                   _commissionLabel,
                                   _toBePaidLabel,
                                   _toBePaidTextField,
                                   _protectionCodeLabel,
                                   _protectionCodeView,
                                   _protectionCodeSwitch,
                                   _commentTextView
                                   );
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_moneyLeftLabel]-|"
                                                                             options:0 metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_recipientLabel]-|"
                                                                             options:0 metrics:nil
                                                                               views:viewsDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_recipientTextField]-0-|"
                                                                             options:0 metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_toPayLabel]-|"
                                                                             options:0 metrics:nil
                                                                               views:viewsDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_toPayTextField]-0-|"
                                                                             options:0 metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_commissionLabel]-|"
                                                                             options:0 metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.commissionLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.toBePaidLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1 constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_toBePaidLabel]"
                                                                             options:0 metrics:nil
                                                                               views:viewsDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_toBePaidTextField]-0-|"
                                                                             options:0 metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_protectionCodeLabel]-|"
                                                                             options:0 metrics:nil
                                                                               views:viewsDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_protectionCodeView]-|"
                                                                             options:0 metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_protectionCodeSwitch]-|"
                                                                             options:0 metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_commentTextView]-(0)-|"
                                                                             options:0 metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.protectionCodeSwitch
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.protectionCodeLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1 constant:0]];
    
    [self.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:
      @"V:|"
      "-[_moneyLeftLabel]"
      "-[_recipientLabel]-(4)-[_recipientTextField]"
      "-[_toPayLabel]-(4)-[_toPayTextField]"
      "-[_toBePaidLabel]-(4)-[_toBePaidTextField]"
      "-(12)-[_protectionCodeLabel]-(12)-[_protectionCodeView]"
      "-[_commentTextView(100)]"
      "-(>=8@10)-|"
                                             options:0 metrics:nil
                                               views:viewsDictionary]];
}

@end
