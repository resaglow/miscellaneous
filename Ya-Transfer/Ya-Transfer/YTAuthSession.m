//
//  YTAuthSession.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 28/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTAuthSession.h"
#import "YTNetworkingHelper.h"

@implementation YTAuthSession

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.requestManager = [[YTAuthRequestManager alloc] init];
        self.responseManager = [[YTAuthResponseManager alloc] init];
    }
    
    return self;
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
    NSURL *baseUrl = [[NSURL URLWithString:@"/" relativeToURL:url] absoluteURL];
    if (![self isUrl:baseUrl equivalentToUrl:[NSURL URLWithString:kAuthRedirectUri]]) {
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
        NSURLRequest *tokenRequest = [self.requestManager tokenRequestWithCode:code];
        [self executeTaskWithRequest:tokenRequest completion:^(NSData *data) {
            [self.responseManager handleTokenResponse:data];
        }];
        
        return NO;
    }
}

@end
