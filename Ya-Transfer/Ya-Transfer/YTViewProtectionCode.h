//
//  YTViewProtectionCode.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <UIKit/UIKit.h>

// MVC violation yet it seems redundant for this case to create an intermediate controller
@interface YTViewProtectionCode : UIView <UITextFieldDelegate>

@property (nonatomic) UILabel *promptLabel;
@property (nonatomic) UILabel *validityPeriodLabel;
@property (nonatomic) UIStepper *validityPeriodStepper;

@end
