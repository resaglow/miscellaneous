//
//  YTHistoryResponseManager.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 01/10/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YTHistoryResponseManagerDelegate

// TODO

@end

@interface YTHistoryResponseManager : NSObject

@property (nonatomic) id<YTHistoryResponseManagerDelegate> delegate;

- (void)handleHistoryFetch:(NSData *)data completion:(void (^)(NSArray *))handler;

@end