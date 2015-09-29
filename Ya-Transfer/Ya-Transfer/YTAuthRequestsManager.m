//
//  YTAuthRequestsManager.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 28/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTAuthRequestsManager.h"
#import "YTNetworkingHelper.h"

@implementation YTAuthRequestsManager

#pragma mark - Authorization request

- (NSURLRequest *)authorizationRequest
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kAuthorizePath
                                                                              relativeToURL:[YTNetworkingHelper sharedInstance].baseAPIURL]];
    request.HTTPMethod = @"POST";
    [request addValue:kHeaderContentTypeUrlEncoded forHTTPHeaderField:kHeaderContentType];
    
    NSString *bodyString = [self urlEncodedStringWithParams:@{kClientIdParamName: kClientId,
                                                              kAuthResponseTypeParamName: kAuthResponseType,
                                                              kAuthRedirectUriParamName: kAuthRedirectUri,
                                                              kAuthScopeParamName: @"account-info"}]; // TODO Get normal scope
    
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyString length]] forHTTPHeaderField:kHeaderContentLength];
    
    return request;
}

#pragma mark - Token request

- (NSURLRequest *)tokenRequestWithCode:(NSString *)code
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kTokenPath
                                                                              relativeToURL:[YTNetworkingHelper sharedInstance].baseAPIURL]];
    
    request.HTTPMethod = @"POST";
    [request addValue:kHeaderContentTypeUrlEncoded forHTTPHeaderField:kHeaderContentType];
    
    // ResponseType without param name because it's a param value currently used as a param name
    NSString *bodyString = [self urlEncodedStringWithParams:@{kAuthResponseType: code,
                                                              kClientIdParamName: kClientId,
                                                              kAuthGrantTypeParamName: kAuthGrantType,
                                                              kAuthRedirectUriParamName: kAuthRedirectUri}];
    
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyString length]] forHTTPHeaderField:kHeaderContentLength];
    
    return request;
}


#pragma mark - Helpers

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
