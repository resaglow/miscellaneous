//
//  YTNetworkingHelper.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 27/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

// TODO MRC

#import "YTNetworkingHelper.h"

@implementation YTNetworkingHelper

- (NSURL *)baseAPIURL {
    return [NSURL URLWithString:kBaseApiUrlString];
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

+ (instancetype)sharedInstance
{
    static YTNetworkingHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
