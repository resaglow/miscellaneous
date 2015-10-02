//
//  YTHistoryResponseManager.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 01/10/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTHistoryResponseManager.h"
#import "YTNetworkingHelper.h"
#import "YTOperation.h"

@implementation YTHistoryResponseManager

- (void)handleHistoryFetch:(NSData *)data completion:(void (^)(NSArray *))handler
{
    if (!data) {
        if (handler) handler(nil);
        return;
    }
    
    NSError *parsingError = nil;
    id responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
    if (parsingError) {
#ifdef DEBUG
        NSLog(@"History parsing error: %@\n", parsingError);
#endif
        if (handler) handler(nil);
    } else {
        id curHistory = responseDict[kHistoryOperations];
        
        NSMutableArray *localOperations = [NSMutableArray arrayWithCapacity:0];
        for (NSArray *operation in curHistory) {
            YTOperation *curLocalOperation = [[YTOperation alloc] init];
            
            for (NSString *key in operation) {
                // Switch alternative
                if ([key isEqualToString:kPaymentOperationIdParamName]) {
                    curLocalOperation.operationId = key;
                } else if ([key isEqualToString:kPaymentCommentParamName]) {
                    curLocalOperation.comment = key;
                } else if ([key isEqualToString:kPaymentAmountParamName]) {
                    curLocalOperation.amount = key;
                }
            }
            
            [localOperations addObject:curLocalOperation];
        }
        
        if (handler) handler(localOperations);
    }
}

@end