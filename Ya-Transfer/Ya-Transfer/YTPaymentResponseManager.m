//
//  YTPaymentResponseManager.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTPaymentResponseManager.h"
#import "YTNetworkingHelper.h"

@implementation YTPaymentResponseManager

- (void)handleRequestPaymentResponse:(NSData *)data completion:(void (^)(NSString *))handler
{
    if (!data) {
        if (handler) handler(nil);
        return;
    }
    
    NSError *parsingError = nil;
    id responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
    if (parsingError) {
#ifdef DEBUG
        NSLog(@"RequestPayment parsing error: %@\n", parsingError);
#endif
        if (handler) handler(nil);
    } else {
        id protectionCode = responseDict[kPaymentProtectionCodeParamName];
        if (protectionCode) {
            [self.delegate paymentResponseManagerDidGetProtectionCode:protectionCode];
        }
        
        id requestId = responseDict[kPaymentRequestIdParamName];
        if (!requestId) {
#ifdef DEBUG
            NSLog(@"RequestPayment error: request ID missing");
#endif
        }
        
        if (handler) handler(requestId);
    }
}

- (void)handleProcessPaymentResponse:(NSData *)data completion:(void (^)(BOOL))handler
{
    if (!data) {
        [self.delegate paymentResponseManagerDidProcessPaymentResult:NO]; // sending to the controller
        if (handler) handler(NO);
        return;
    }
    
    NSError *parsingError = nil;
    id responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
    if (parsingError) {
#ifdef DEBUG
        NSLog(@"ProcessPayment parsing error: %@\n", parsingError);
#endif
        if (handler) handler(nil);
    } else {
        id status = responseDict[kPaymentStatusParamName];
        id error = responseDict[kError];
        if (error) {
#ifdef DEBUG
            NSLog(@"ProcessPayment error: %@\n", error);
#endif
        }
        
        BOOL success = [status isEqualToString:kPaymentStatusSuccess];
        
        [self.delegate paymentResponseManagerDidProcessPaymentResult:success]; // sending to the controller
        
        if (handler) handler(success); // sending to the session to continue networking (if needed)
    }
}

@end
