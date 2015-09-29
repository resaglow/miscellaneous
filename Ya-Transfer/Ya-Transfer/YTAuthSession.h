//
//  YTAuthSession.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 28/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTAuthRequestsManager.h"
#import "YTResponseManager.h"

@interface YTAuthSession : NSObject

@property (nonatomic) YTAuthRequestsManager *requestsManager;
@property (nonatomic) YTResponseManager *responseManager;

// This sends token request when correct redirect URL is passed
- (BOOL)handleUrlLoad:(NSURL *)url;

@end
