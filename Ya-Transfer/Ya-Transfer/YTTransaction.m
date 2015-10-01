//
//  Transaction.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 30/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTTransaction.h"

@implementation YTTransaction

- (instancetype)initWithRecipientId:(NSString *)recipientId
                             amount:(NSString *)amount
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