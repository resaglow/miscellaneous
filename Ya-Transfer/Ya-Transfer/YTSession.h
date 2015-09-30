//
//  YTSession.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 30/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTSession : NSObject

@property (nonatomic) NSURLSession *urlSession;

- (void)executeTaskWithRequest:(NSURLRequest *)tokenRequest completion:(void (^)(NSData *))handler;

@end
