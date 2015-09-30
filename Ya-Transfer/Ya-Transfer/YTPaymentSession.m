//
//  YTPaymentSession.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTPaymentSession.h"
#import "YTPaymentRequestManager.h"
#import "YTPaymentResponseManager.h"

@interface YTPaymentSession ()

@property (nonatomic) NSURLSession *paymentUrlSession;

@end

@implementation YTPaymentSession

- (void)handleSendPaymentWithRecipientId:(NSString *)recipientId
                                  amount:(NSString *)amount
                                 comment:(NSString *)comment
                           prCodeEnabled:(BOOL)prCodeEnabled
                      prCodeExpirePeriod:(NSString *)prCodeExpirePeriod
{
    // TODO Execute request && handleResp && execute process && handleResp && return control
    
}

@end
