//
//  YTNetworkingHelper.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 27/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <UIKit/UIKit.h>

// Networkig helper methods & constants (seems not so bad in one class)

// TODO Make constants

#define kBaseApiUrlString @"https://m.money.yandex.ru"
#define kAuthorizePath @"/oauth/authorize"
#define kTokenPath @"/oauth/token"

#define kClientIdParamName @"client_id"
#define kClientId @"25BC5D333B0358082B7F41BA6CA958A8BA6A263BBECCC698B6080A7779041F91"

#define kHeaderContentType @"Content-Type"
#define kHeaderContentTypeUrlEncoded @"application/x-www-form-urlencoded"
#define kHeaderContentLength @"Content-Length"

#define kAuthResponseTypeParamName @"response_type"
#define kAuthResponseType @"code"
#define kAuthRedirectUriParamName @"redirect_uri"
// Dummy website to redirect to
#define kAuthRedirectUri @"http://pay.ru"
#define kAuthScopeParamName @"scope"
#define kAuthGrantTypeParamName @"grant_type"
#define kAuthGrantType @"authorization_code"
#define kAuthTokenParamName @"access_token"

#define kRequestErrorCode 1000

// This one seems worth making a singleton

@interface YTNetworkingHelper : UIViewController

@property (readonly, nonatomic) NSURL *baseAPIURL;

// Not strictly for a method yet still reasonably clear
- (NSError *)requestErrorForMethod:(NSString *)methodName statusCode:(NSUInteger)statusCode;

+ (instancetype)sharedInstance;

@end
