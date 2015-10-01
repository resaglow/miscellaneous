//
//  YTPaymentSession.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTPaymentRequestManager.h"
#import "YTPaymentResponseManager.h"
#import "YTSession.h"
#import "YTTransaction.h"

@interface YTPaymentSession : YTSession

@property (nonatomic) YTPaymentRequestManager *requestManager;
@property (nonatomic) YTPaymentResponseManager *responseManager;

- (void)sendPaymentWithTransaction:(YTTransaction *)transaction;

@end