//
//  YTTextView.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTTextView.h"

@implementation YTTextView 

- (instancetype)initWithActiveView:(UITextView *)activeTextView
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.editable = YES;
        self.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 10);
}

@end
