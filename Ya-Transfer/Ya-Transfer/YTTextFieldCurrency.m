//
//  YTTextFieldCurrency.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTTextFieldCurrency.h"

NSString * const kRubles         = @"rub";
NSString * const kRublesToAppend = @" rub";
NSString * const kPlaceholder    = @"0 rub";

// MVC violation yet it seems redundant for this case to create an intermediate controller
@interface YTTextFieldCurrency () <UITextFieldDelegate>

@property (nonatomic) NSNumberFormatter *numberFormatter;

@end

@implementation YTTextFieldCurrency

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        self.numberFormatter.decimalSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
        self.numberFormatter.decimalSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
        
        self.delegate = self;
        
        self.placeholder = kPlaceholder;
    }
    
    return self;
}

#pragma mark - Currency delegate method
// Somewhat ugly but somewhat working currency formatting handlers

// In this case it seems better not to split this function up into several another functions
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    static NSString *numbers = @"0123456789";
    static NSString *numbersPeriod = @"01234567890.";
    static NSString *numbersComma = @"0123456789,";
    
    static UITextPosition *position;
    NSInteger curDecimalPosition = textField.text.length - kRublesToAppend.length;
    
    NSInteger integerPartLength = 0;
    
    // Parsing number
    NSString *unformattedNumberString = nil;
    if ([textField.text isEqualToString:@""]) {
        unformattedNumberString = @"";
    } else {
        NSArray *strComponents = [[textField.text substringToIndex:curDecimalPosition]
                                  componentsSeparatedByString:self.numberFormatter.decimalSeparator];
        
        unformattedNumberString = [NSString stringWithFormat:@"%ld",
                                   (long)[[self.numberFormatter numberFromString:strComponents[0]] integerValue]];
        integerPartLength = [unformattedNumberString length];
        
        if ([strComponents count] > 1) {
            unformattedNumberString = [[unformattedNumberString stringByAppendingString:self.numberFormatter.decimalSeparator]
                                       stringByAppendingString:strComponents[1]];
        }
    }
    
    // Erasing
    if (string.length == 0) {
        if (textField.text.length == kRublesToAppend.length + 1) { // A space and a digit
            textField.text = @"";
        } else {
            unformattedNumberString = [unformattedNumberString substringToIndex:[unformattedNumberString length] - 1];
            textField.text = [self formatCurrency:unformattedNumberString];
        }
        
        position = [textField positionFromPosition:[textField beginningOfDocument]
                                            offset:[textField.text isEqualToString:@""] ? 0 : textField.text.length - kRublesToAppend.length];
        textField.selectedTextRange = [textField textRangeFromPosition:position toPosition:position];
        
        return NO;
    }
    
    NSString *symbol = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
    
    // Can't start with a separator
    if (range.location == 0 && [string isEqualToString:symbol]) {
        return NO;
    }
    
    NSCharacterSet *characterSet;
    NSRange separatorRange = [textField.text rangeOfString:symbol];
    if (separatorRange.location == NSNotFound) {
        if (integerPartLength >= 9 && ![string isEqualToString:symbol]) {
            return NO;
        }
        
        if ([symbol isEqualToString:@"."]) {
            characterSet = [NSCharacterSet characterSetWithCharactersInString:numbersPeriod].invertedSet;
        } else {
            characterSet = [NSCharacterSet characterSetWithCharactersInString:numbersComma].invertedSet;
        }
    } else {
        if (curDecimalPosition - separatorRange.location > 2) { // <= 2 digits after separator
            return NO;
        }
        
        characterSet = [NSCharacterSet characterSetWithCharactersInString:numbers].invertedSet;
    }
    
    if ([string stringByTrimmingCharactersInSet:characterSet].length > 0) {
        if ([textField.text isEqualToString:@""]) {
            textField.text = [string stringByAppendingString:kRublesToAppend];
        } else {
            unformattedNumberString = [unformattedNumberString stringByAppendingString:string];
            textField.text = [self formatCurrency:unformattedNumberString];
        }
    } else {
        return NO;
    }
    
    position = [textField positionFromPosition:[textField beginningOfDocument] offset:textField.text.length - kRublesToAppend.length];
    textField.selectedTextRange = [textField textRangeFromPosition:position toPosition:position];
    
    return NO;
}

#pragma mark - Helpers

- (NSString *)formatCurrency:(NSString *)unformattedNumberString {
    NSString *numberString = [self.numberFormatter stringFromNumber: [self.numberFormatter numberFromString:unformattedNumberString]];
    
    if ([[unformattedNumberString substringFromIndex:[unformattedNumberString length] - 1] isEqualToString:self.numberFormatter.decimalSeparator]) {
        return [[numberString stringByAppendingString:self.numberFormatter.decimalSeparator] stringByAppendingString:kRublesToAppend];
    } else {
        return [numberString stringByAppendingString:kRublesToAppend];
    }
}

@end
