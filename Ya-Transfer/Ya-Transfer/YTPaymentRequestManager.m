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

- (NSURLRequest *)requestPaymentRequestWithTransaction:(YTOperation *)transaction
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kRequstPaymentPath
                                                                              relativeToURL:[YTNetworkingHelper sharedInstance].baseApiUrl]];
    request.HTTPMethod = @"POST";
    [request addValue:kHeaderContentTypeUrlEncoded forHTTPHeaderField:kHeaderContentType];
    
    NSString *codeProString = transaction.prCodeEnabled ? kTrue : kFalse;
    
    NSMutableDictionary *paramDict =
    [NSMutableDictionary dictionaryWithDictionary:@{kPaymentPatternIdParamName: kPaymentPatternIdP2P,
                                                           kPaymentToParamName: transaction.recipientId,
                                                       kPaymentAmountParamName: transaction.amount,
                                                      kPaymentCommentParamName: transaction.comment,
                                                      kPaymentMessageParamName: @"", // Not used here
                                                      kPaymentCodeproParamName: codeProString}];
    
    if (transaction.prCodeEnabled) {
        [paramDict setObject:transaction.prCodeExpirePeriod forKey:kPaymentExpirePeriodParamName];
    }
    
    NSString *bodyString = [[YTNetworkingHelper sharedInstance] urlEncodedStringWithParams:paramDict];
    
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyString length]] forHTTPHeaderField:kHeaderContentLength];
    
    return request;
}

- (NSURLRequest *)processPaymentRequestWithRequestId:(NSString *)requestId
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kProcessPaymentPath
                                                                              relativeToURL:[YTNetworkingHelper sharedInstance].baseApiUrl]];
    request.HTTPMethod = @"POST";
    [request addValue:kHeaderContentTypeUrlEncoded forHTTPHeaderField:kHeaderContentType];
    
    NSMutableDictionary *paramDict =
    [NSMutableDictionary dictionaryWithDictionary:@{kPaymentRequestIdParamName: requestId}];
    
    NSString *bodyString = [[YTNetworkingHelper sharedInstance] urlEncodedStringWithParams:paramDict];
    
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyString length]] forHTTPHeaderField:kHeaderContentLength];
    
    return request;
}

@end
