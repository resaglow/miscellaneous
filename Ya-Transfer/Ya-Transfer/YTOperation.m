//
//  YTOperation.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 30/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTOperation.h"

@implementation YTOperation

- (instancetype)initWithRecipientId:(NSString *)recipientId
                             amount:(double)amount
                            comment:(NSString *)comment
                      prCodeEnabled:(BOOL)prCodeEnabled
                 prCodeExpirePeriod:(NSString *)prCodeExpirePeriod
{
    self = [self init];
    
    if (self) {
        self.recipientId = recipientId;
        self.amount = amount;
        self.comment = comment;
        self.prCodeEnabled = prCodeEnabled;
        self.prCodeExpirePeriod = prCodeExpirePeriod;
    }
    
    return self;
}

@end