//
//  YTPaymentRequestManager.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTOperation.h"

@interface YTPaymentRequestManager : NSObject

- (NSURLRequest *)requestPaymentRequestWithTransaction:(YTOperation *)transaction;
- (NSURLRequest *)processPaymentRequestWithRequestId:(NSString *)requestId;

@end