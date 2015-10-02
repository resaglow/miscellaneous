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

- (void)executeTaskWithRequest:(NSURLRequest *)request completion:(void (^)(NSData *))handler
{
    if (!request) {
#ifdef DEBUG
        NSLog(@"Networking error, invalid request\n");
        if (handler) handler(nil);
#endif
    }
    [[self.urlSession dataTaskWithRequest:request
                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                if (error) {
#ifdef DEBUG
                                    NSLog(@"Networking error, status code %ld\n", (long)httpResponse.statusCode);
#endif
                                    if (handler) handler(nil);
                                } else {
                                    if (httpResponse.statusCode != 200) {
#ifdef DEBUG
                                        NSLog(@"Request error, status code %ld\n", (long)httpResponse.statusCode);
#endif
                                        if (handler) handler(nil);
                                    } else {
                                        if (handler) handler(data);
                                    }
                                }
                            }] resume];
}

@end
