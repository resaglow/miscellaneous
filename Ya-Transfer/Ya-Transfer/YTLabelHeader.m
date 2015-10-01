//
//  YTLabelHeader.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTLabelHeader.h"

@implementation YTLabelHeader

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.textColor = [UIColor orangeColor];
        self.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    
    return self;
}

@end
