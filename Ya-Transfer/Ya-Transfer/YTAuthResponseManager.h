//
//  YTAuthResponseManager.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 28/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YTAuthResponseManagerDelegate

- (void)authResponseManagerDidHandleToken;

@end

@interface YTAuthResponseManager : NSObject

@property (nonatomic, weak) id<YTAuthResponseManagerDelegate> delegate;

- (void)handleTokenResponse:(NSData *)data;

@end