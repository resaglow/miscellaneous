//
//  YTPaymentRequestManager.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTPaymentRequestManager.h"
#import "YTNetworkingHelper.h"

@implementation YTPaymentRequestManager

- (NSURLRequest *)requestPaymentRequestWithRecipientId:(NSInteger)recipientId
                                                amount:(double)amount
                                               comment:(NSString *)comment
                                               codepro:(BOOL)codepro
                                          expirePeriod:(NSInteger)expirePeriod
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kAuthorizePath
                                                                              relativeToURL:[YTNetworkingHelper sharedInstance].baseApiUrl]];
    request.HTTPMethod = @"POST";
    [request addValue:kHeaderContentTypeUrlEncoded forHTTPHeaderField:kHeaderContentType];
    
    NSString *recipientIdString = [@(recipientId) stringValue];
    NSString *amountString = [@(amount) stringValue];
    NSString *codeProString = codepro ? kTrue : kFalse;
    NSString *expirePeriodString = [@(expirePeriod) stringValue];
    
    NSMutableDictionary *paramDict =
    [NSMutableDictionary dictionaryWithDictionary:@{kPaymentPatternIdParamName: kPaymentPatternId,
                                                           kPaymentToParamName: recipientIdString,
                                                       kPaymentAmountParamName: amountString,
                                                      kPaymentCommentParamName: comment,
                                                      kPaymentMessageParamName: @"", // Not used here
                                                      kPaymentCodeproParamName: codeProString}];
    
    if (codepro) {
        [paramDict setObject:expirePeriodString forKey:kPaymentExpirePeriodParamName];
    }
    
    NSString *bodyString = [[YTNetworkingHelper sharedInstance] urlEncodedStringWithParams:paramDict];
    
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyString length]] forHTTPHeaderField:kHeaderContentLength];
    
    return request;
}

- (NSURLRequest *)processPaymentRequestWithRequestId:(NSInteger)requestId
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kAuthorizePath
                                                                              relativeToURL:[YTNetworkingHelper sharedInstance].baseApiUrl]];
    request.HTTPMethod = @"POST";
    [request addValue:kHeaderContentTypeUrlEncoded forHTTPHeaderField:kHeaderContentType];
    
    NSString *requestIdString = [@(requestId) stringValue];
    
    NSMutableDictionary *paramDict =
    [NSMutableDictionary dictionaryWithDictionary:@{kPaymentRequestIdParamName: requestIdString}];
    
    NSString *bodyString = [[YTNetworkingHelper sharedInstance] urlEncodedStringWithParams:paramDict];
    
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyString length]] forHTTPHeaderField:kHeaderContentLength];
    
    return request;
}

@end
