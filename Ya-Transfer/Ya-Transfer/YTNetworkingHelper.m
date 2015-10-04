//
//  YTNetworkingHelper.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 27/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

// TODO MRC

#import "YTNetworkingHelper.h"

NSString * const kTrue = @"true";
NSString * const kFalse = @"false";
NSString * const kError = @"error"; // generic error constant

NSString * const kBaseUrlString = @"https://m.money.yandex.ru";
NSString * const kBaseApiUrlString = @"https://money.yandex.ru/api";

NSString * const kAuthorizePath = @"/oauth/authorize";
NSString * const kTokenPath = @"/oauth/token";
NSString * const kRequstPaymentPath = @"/request-payment";
NSString * const kProcessPaymentPath = @"/process-payment";
NSString * const kHistoryPath = @"/operation-history";

NSString * const kClientIdParamName = @"client_id";
NSString * const kClientId = @"25BC5D333B0358082B7F41BA6CA958A8BA6A263BBECCC698B6080A7779041F91";

// Authorization constants
NSString * const kAuthResponseTypeParamName = @"response_type";
NSString * const kAuthResponseType = @"code";
NSString * const kAuthRedirectUriParamName = @"redirect_uri";
NSString * const kAuthRedirectUri = @"http://pay.ru"; // dummy website to redirect to & intercept
NSString * const kAuthScopeParamName = @"scope";
NSString * const kAuthGrantTypeParamName = @"grant_type";
NSString * const kAuthGrantType = @"authorization_code";
NSString * const kAuthTokenParamName = @"access_token";

// Payment constants
NSString * const kPaymentOperationIdParamName = @"operation_id";
NSString * const kPaymentPatternIdParamName = @"pattern_id";
NSString * const kPaymentPatternIdP2P = @"p2p";
NSString * const kPaymentToParamName = @"to";
NSString * const kPaymentAmountParamName = @"amount";
NSString * const kPaymentCommentParamName = @"comment";
NSString * const kPaymentMessageParamName = @"message";
NSString * const kPaymentCodeproParamName = @"codepro";
NSString * const kPaymentExpirePeriodParamName = @"expire_period";
NSString * const kPaymentRequestIdParamName = @"request_id";
NSString * const kPaymentProtectionCodeParamName = @"protection_code";
NSString * const kPaymentStatusParamName = @"status";
NSString * const kPaymentStatusSuccess = @"success";
NSString * const kPaymentDateTimeParamName = @"datetime";
NSString * const kHistoryOperations = @"operations";
NSString * const kPaymentPaymentParamName = @"payment";

// History constants
NSString * const kOperationTypeParamName = @"type";
NSString * const kHistoryStartRecordParamName = @"start_record";
NSString * const kHistoryRecordsParamName = @"records";

NSString * const kHeaderContentType = @"Content-Type";
NSString * const kHeaderContentTypeUrlEncoded = @"application/x-www-form-urlencoded";
NSString * const kHeaderContentLength = @"Content-Length";

NSInteger const kRequestErrorCode = 1000;

@implementation YTNetworkingHelper

+ (instancetype)sharedInstance
{
    static YTNetworkingHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Networking helpers

- (NSURL *)baseApiUrl {
    return [NSURL URLWithString:kBaseUrlString];
}

- (NSURL *)baseApiApiUrl {
    return [NSURL URLWithString:kBaseApiUrlString];
}

- (NSArray *)authRightsArray {
    return @[@"account-info", @"operation-history", @"operation-details", @"payment-p2p"];
}

- (NSError *)requestErrorForMethod:(NSString *)methodName statusCode:(NSUInteger)statusCode
{
    NSString *reqErrorDesc = [NSString stringWithFormat:
                              @"%@ request error, status code %ld", methodName, (long)statusCode];
    
    NSMutableDictionary* reqErrorDetails = [NSMutableDictionary dictionary];
    
    [reqErrorDetails setValue:reqErrorDesc forKey:NSLocalizedDescriptionKey];
    NSError *reqError = [NSError errorWithDomain:
                         [[NSBundle mainBundle] bundleIdentifier] code:kRequestErrorCode userInfo:reqErrorDetails];
    
    return reqError;
}

- (NSString *)percentEscapeUrl:(NSString *)string
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef)@";/?:@&=+$,",
                                                                                 kCFStringEncodingUTF8));
}

- (NSString *)urlEncodedStringWithParams:(NSDictionary *)params
{
    NSMutableString *urlEncodedStr = [NSMutableString stringWithCapacity:0];
    for (NSString *key in params.allKeys) {
        
        NSString *paramKey = [self percentEscapeUrl:key];
        NSString *paramValue = [self percentEscapeUrl:params[key]];
        
        [urlEncodedStr appendString:[NSString stringWithFormat:@"%@=%@&", paramKey, paramValue]];
    }
    
    return urlEncodedStr;
}

@end
