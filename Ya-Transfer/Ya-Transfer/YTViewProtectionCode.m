//
//  YTViewProtectionCode.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTViewProtectionCode.h"
#import "YTTextField.h"

static NSString * const kPrompt = @"Validity period (days):";

@implementation YTViewProtectionCode

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.promptLabel = [[UILabel alloc] init];
        self.promptLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.promptLabel.text = kPrompt;
        self.promptLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize] - 1];
        [self addSubview:self.promptLabel];
        
        self.validityPeriodLabel = [[UILabel alloc] init];
        self.validityPeriodLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.validityPeriodLabel.text = @"1";
        self.validityPeriodLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        [self addSubview:self.validityPeriodLabel];
        
        self.validityPeriodStepper = [[UIStepper alloc] init];
        self.validityPeriodStepper.translatesAutoresizingMaskIntoConstraints = NO;
        self.validityPeriodStepper.tintColor = [UIColor blackColor];
        self.validityPeriodStepper.minimumValue = 1;
        self.validityPeriodStepper.maximumValue = 365;
        [self addSubview:self.validityPeriodStepper];
        
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_promptLabel, _validityPeriodLabel, _validityPeriodStepper);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_promptLabel]-|"
                                                                     options:0 metrics:nil
                                                                       views:viewsDictionary]];
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"H:|[_promptLabel]-(20@900)-[_validityPeriodLabel(50@700)]-(>=20@900)-[_validityPeriodStepper]"
                              options:0 metrics:nil
                              views:viewsDictionary]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_validityPeriodStepper]-(8@1000)-|"
                                                                     options:0 metrics:nil
                                                                       views:viewsDictionary]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.promptLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.validityPeriodLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.validityPeriodLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.validityPeriodStepper
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1 constant:0]];
        
        // Init some controls (seems fairy reasonable to put them into the view)
        [self.validityPeriodStepper addTarget:self action:@selector(handleStepperValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    
    return self;
}

- (void)handleStepperValueChanged
{
    self.validityPeriodLabel.text = [NSString stringWithFormat:@"%.lf", self.validityPeriodStepper.value];
}

@end

