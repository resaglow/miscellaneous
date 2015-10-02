//
//  YTOperation.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 30/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTOperation.h"

@implementation YTOperation

- (instancetype)initWithOperationId:(NSString *)operationId
                        recipientId:(NSString *)recipientId
                             amount:(NSString *)amount
                            comment:(NSString *)comment
                      prCodeEnabled:(BOOL)prCodeEnabled
                 prCodeExpirePeriod:(NSString *)prCodeExpirePeriod
                          direction:(NSString *)direction
                           dateTime:(NSString *)dateTime;
{
    self = [self init];
    
    if (self) {
        self.operationId = operationId;
        self.recipientId = recipientId;
        self.amount = amount;
        self.comment = comment;
        self.prCodeEnabled = prCodeEnabled;
        self.prCodeExpirePeriod = prCodeExpirePeriod;
        self.direction = direction;
        self.dateTime = dateTime;
    }
    
    return self;
}

@end