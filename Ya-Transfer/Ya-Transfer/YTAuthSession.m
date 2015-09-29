//
//  YTAuthSession.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 28/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTAuthSession.h"
#import "YTNetworkingHelper.h"

// App specific method name for debug
#ifdef DEBUG
#define kGetTokenMethodName @"GetToken"
#endif

@interface YTAuthSession ()

@property (nonatomic) NSURLSession *authUrlSession;

@end

@implementation YTAuthSession

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.requestsManager = [[YTAuthRequestsManager alloc] init];
        self.responseManager = [[YTResponseManager alloc] init];
        self.authUrlSession  = [NSURLSession sessionWithConfiguration:
                                [NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    return self;
}

#pragma mark - Get token task

- (void)executeGetTokenTaskWithRequest:(NSURLRequest *)tokenRequest completion:(void (^)(NSData *))handler
{
    [[self.authUrlSession dataTaskWithRequest:tokenRequest
                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               if (error) {
#ifdef DEBUG
                                   NSLog(@"%@ networking error, status code %ld\n", kGetTokenMethodName, (long)httpResponse.statusCode);
#endif
                                   handler(nil);
                               } else {
                                   if (httpResponse.statusCode != 200) {
#ifdef DEBUG
                                       NSLog(@"%@ request error, status code %ld\n", kGetTokenMethodName, (long)httpResponse.statusCode);
#endif
                                       handler(nil);
                                   } else {
                                       handler(data);
                                   }
                               }
                           }] resume];
}

#pragma mark - Token request helpers

- (BOOL)isUrl:(NSURL *)url1 equivalentToUrl:(NSURL *)url2
{
    if ([url1 isEqual:url2]) return YES;
    if ([[url1 scheme] caseInsensitiveCompare:[url2 scheme]] != NSOrderedSame) return NO;
    if ([[url1 host] caseInsensitiveCompare:[url2 host]] != NSOrderedSame) return NO;
    return YES;
}

// Returns a value meaning whether a calling controller should load a URL or not (redirect case)
- (BOOL)handleUrlLoad:(NSURL *)url
{
    if (![self isUrl:url.baseURL equivalentToUrl:[NSURL URLWithString:kAuthRedirectUri]]) {
        return YES;
    }
    
    // Auth code to receive auth token
    NSString *code = nil;
    
    NSArray *queryItems = [url.query componentsSeparatedByString:@"&"];
    for (NSString *item in queryItems) {
        NSArray *kv = [item componentsSeparatedByString:@"="];
        if (kv.count == 2 && [kv[0] isEqualToString:kAuthResponseType]) {
            code = kv[1];
        }
    }
    
    if (!code) {
        return YES;
    } else {
        NSURLRequest *tokenRequest = [self.requestsManager tokenRequestWithCode:code];
        [self executeGetTokenTaskWithRequest:tokenRequest completion:^(NSData *data) {
            [self.responseManager handleTokenResponse:data];
        }];
        
        return NO;
    }
}

@end
