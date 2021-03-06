//
//  YTTextFieldCurrency.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTTextField.h"

@interface YTTextFieldCurrency : YTTextField

@property (nonatomic) YTTextField *dependingTextField;

- (instancetype)initWithDependingTextField:(YTTextField *)dependingTextField;

@end
