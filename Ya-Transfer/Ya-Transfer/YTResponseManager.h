//
//  YTResponseManager.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 28/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YTResponseManagerDelegate <NSObject>

- (void)responseManagerDidHandleToken;

@end

@interface YTResponseManager : NSObject

@property (nonatomic, weak) id<YTResponseManagerDelegate> delegate;

- (void)handleTokenResponse:(NSData *)data;

@end