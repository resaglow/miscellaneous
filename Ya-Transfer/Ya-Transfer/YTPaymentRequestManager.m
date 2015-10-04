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

- (NSURLRequest *)requestPaymentRequestWithOperation:(YTOperation *)operation
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kRequstPaymentPath
                                                                              relativeToURL:[YTNetworkingHelper sharedInstance].baseApiApiUrl]];
    request.HTTPMethod = @"POST";
    [request addValue:kHeaderContentTypeUrlEncoded forHTTPHeaderField:kHeaderContentType];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token) {
        [request addValue:[@"Bearer " stringByAppendingString:token] forHTTPHeaderField:@"Authorization"];
    }
    
    NSString *codeProString = operation.prCodeEnabled ? kTrue : kFalse;
    
    NSString *amount = [NSString stringWithFormat:@"%.2f", operation.amount];
    NSString *recipientId = [NSString stringWithFormat:@"%lu", (unsigned long)operation.recipientId];
    
    NSMutableDictionary *paramDict =
    [NSMutableDictionary dictionaryWithDictionary:@{kPaymentPatternIdParamName: kPaymentPatternIdP2P,
                                                           kPaymentToParamName: recipientId,
                                                       kPaymentAmountParamName: amount,
                                                      kPaymentCommentParamName: operation.comment,
                                                      kPaymentMessageParamName: @"", // Not used here
                                                      kPaymentCodeproParamName: codeProString}];
    
    if (operation.prCodeEnabled) {
        [paramDict setObject:operation.prCodeExpirePeriod forKey:kPaymentExpirePeriodParamName];
    }
    
    NSString *bodyString = [[YTNetworkingHelper sharedInstance] urlEncodedStringWithParams:paramDict];
    
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyString length]] forHTTPHeaderField:kHeaderContentLength];
    
    return request;
}

- (NSURLRequest *)processPaymentRequestWithRequestId:(NSString *)requestId
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kProcessPaymentPath
                                                                              relativeToURL:[YTNetworkingHelper sharedInstance].baseApiApiUrl]];
    request.HTTPMethod = @"POST";
    [request addValue:kHeaderContentTypeUrlEncoded forHTTPHeaderField:kHeaderContentType];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token) {
        [request addValue:[@"Bearer " stringByAppendingString:token] forHTTPHeaderField:@"Authorization"];
    }
    
    NSMutableDictionary *paramDict =
    [NSMutableDictionary dictionaryWithDictionary:@{kPaymentRequestIdParamName: requestId}];
    
    NSString *bodyString = [[YTNetworkingHelper sharedInstance] urlEncodedStringWithParams:paramDict];
    
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyString length]] forHTTPHeaderField:kHeaderContentLength];
    
    return request;
}

@end
