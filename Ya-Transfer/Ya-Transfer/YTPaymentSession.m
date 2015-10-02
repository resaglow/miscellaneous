//
//  YTPaymentSession.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTPaymentSession.h"

@implementation YTPaymentSession

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.requestManager = [[YTPaymentRequestManager alloc] init];
        self.responseManager = [[YTPaymentResponseManager alloc] init];
    }
    
    return self;
}


- (void)sendPaymentWithTransaction:(YTOperation *)transaction
{    
    NSURLRequest *requestPaymentRequest = [self.requestManager
                                           requestPaymentRequestWithTransaction:(YTOperation *)transaction];
                
    [self executeTaskWithRequest:requestPaymentRequest completion:^(NSData *data) {
        [self.responseManager handleRequestPaymentResponse:data completion:^(NSString *requestId) {
            NSURLRequest *processRequest;
            
            if (requestId) [self.requestManager processPaymentRequestWithRequestId:requestId];
            
            [self executeTaskWithRequest:processRequest completion:^(NSData *data) {
                [self.responseManager handleProcessPaymentResponse:data completion:nil];
            }];
        }];
    }];
}

@end
