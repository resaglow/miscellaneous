//
//  YTPaymentRequestManager.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTPaymentRequestManager : NSObject

- (NSURLRequest *)requestPaymentRequestWithRecipientId:(NSInteger)recipientId
                                                amount:(double)amount
                                               comment:(NSString *)comment
                                               codepro:(BOOL)codepro
                                          expirePeriod:(NSInteger)expirePeriod;

- (NSURLRequest *)processPaymentRequestWithRequestId:(NSInteger)requestId;

@end
