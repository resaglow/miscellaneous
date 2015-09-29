//
//  YTScrollView.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTTextFieldCurrency.h"
#import "YTLabelHeader.h"
#import "YTLabelInfo.h"
#import "YTViewProtectionCode.h"
#import "YTTextView.h"

@interface YTScrollView : UIScrollView

- (instancetype)initWithController:(UIViewController *)viewController;

@property (nonatomic) YTLabelInfo *moneyLeftLabel;

@property (nonatomic) UIView *contentView;

@property (nonatomic) YTLabelHeader *recipientLabel;
@property (nonatomic) YTTextField *recipientTextField;

@property (nonatomic) YTLabelHeader *toPayLabel;
@property (nonatomic) YTTextFieldCurrency *toPayTextField;

@property (nonatomic) YTLabelInfo *commissionLabel;

@property (nonatomic) YTLabelHeader *toBePaidLabel;
@property (nonatomic) YTTextFieldCurrency *toBePaidTextField;

@property (nonatomic) UISwitch *protectionCodeSwitch;
@property (nonatomic) YTLabelHeader *protectionCodeLabel;
@property (nonatomic) YTViewProtectionCode *protectionCodeView;

@property (nonatomic) UIView *boxView;
@property (nonatomic) UILabel *bottomLabel;

@property (nonatomic) YTTextView *commentTextView;

@end
