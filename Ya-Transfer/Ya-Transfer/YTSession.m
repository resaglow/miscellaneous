//
//  YTSession.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 30/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTSession.h"
#import "YTNetworkingHelper.h"

@implementation YTSession

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.urlSession  = [NSURLSession sessionWithConfiguration:
                            [NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    return self;
}

- (void)executeTaskWithRequest:(NSURLRequest *)tokenRequest completion:(void (^)(NSData *))handler
{
    [[self.urlSession dataTaskWithRequest:tokenRequest
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

@end
