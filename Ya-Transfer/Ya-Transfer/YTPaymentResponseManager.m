//
//  YTPaymentResponseManager.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTPaymentResponseManager.h"
#import "YTNetworkingHelper.h"
//#import "YTPay

@implementation YTPaymentResponseManager

// NSString block parameters for now to simplify

- (void)handleRequestPaymentResponse:(NSData *)data completion:(void (^)(NSString *))handler
{
    NSError *parsingError = nil;
    id responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
    if (parsingError) {
#ifdef DEBUG
        NSLog(@"RequestPayment parsing error: %@\n", parsingError);
#endif
    } else {
        id protectionCode = responseDict[kPaymentProtectionCodeParamName];
        if (protectionCode) {
            [self.delegate processProtectionCode:protectionCode];
        }
        
        id requestId = responseDict[kPaymentRequestIdParamName];
        if (!requestId) {
#ifdef DEBUG
            NSLog(@"RequestPayment error: request ID missing");
#endif
        }
        
        handler(requestId);
    }
}

- (void)handleProcessPaymentResponse:(NSData *)data completion:(void (^)(BOOL))handler
{
    NSError *parsingError = nil;
    id responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
    if (parsingError) {
#ifdef DEBUG
        NSLog(@"ProcessPayment parsing error: %@\n", parsingError);
#endif
    } else {
        id status = responseDict[kPaymentStatusParamName];
        id error = responseDict[kError];
        if (error) {
#ifdef DEBUG
            NSLog(@"ProcessPayment error: %@\n", error);
#endif
        }

        handler([status isEqualToString:kPaymentStatusSuccess]);
    }
}

@end
