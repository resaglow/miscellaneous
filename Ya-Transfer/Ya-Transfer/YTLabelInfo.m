//
//  YTLabelInfo.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTLabelInfo.h"

@implementation YTLabelInfo

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.textColor = [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:[UIFont systemFontSize] - 1.5];
    }
    
    return self;
}

@end
