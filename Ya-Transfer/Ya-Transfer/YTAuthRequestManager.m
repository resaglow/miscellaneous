//
//  YTAuthRequestManager.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 28/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTAuthRequestManager.h"
#import "YTNetworkingHelper.h"

@implementation YTAuthRequestManager

#pragma mark - Authorization request

- (NSURLRequest *)authorizationRequest
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kAuthorizePath
                                                                              relativeToURL:[YTNetworkingHelper sharedInstance].baseApiUrl]];
    request.HTTPMethod = @"POST";
    [request addValue:kHeaderContentTypeUrlEncoded forHTTPHeaderField:kHeaderContentType];
    
    NSString *bodyString = [[YTNetworkingHelper sharedInstance] urlEncodedStringWithParams:@{kClientIdParamName: kClientId,
                                                                kAuthResponseTypeParamName: kAuthResponseType,
                                                                 kAuthRedirectUriParamName: kAuthRedirectUri,
                                                                       kAuthScopeParamName: [YTNetworkingHelper sharedInstance].authRightsArray}];
    
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyString length]] forHTTPHeaderField:kHeaderContentLength];
    
    return request;
}

#pragma mark - Token request

- (NSURLRequest *)tokenRequestWithCode:(NSString *)code
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kTokenPath
                                                                              relativeToURL:[YTNetworkingHelper sharedInstance].baseApiUrl]];
    
    request.HTTPMethod = @"POST";
    [request addValue:kHeaderContentTypeUrlEncoded forHTTPHeaderField:kHeaderContentType];
    
    // ResponseType without param name because it's a param value currently used as a param name
    NSString *bodyString = [[YTNetworkingHelper sharedInstance] urlEncodedStringWithParams:@{kAuthResponseType: code,
                                                                                            kClientIdParamName: kClientId,
                                                                                       kAuthGrantTypeParamName: kAuthGrantType,
                                                                                     kAuthRedirectUriParamName: kAuthRedirectUri}];
    
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyString length]] forHTTPHeaderField:kHeaderContentLength];
    
    return request;
}

@end
