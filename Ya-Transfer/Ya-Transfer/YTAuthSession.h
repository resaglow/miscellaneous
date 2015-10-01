//
//  YTAuthSession.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 28/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTAuthRequestManager.h"
#import "YTAuthResponseManager.h"
#import "YTSession.h"

@interface YTAuthSession : YTSession

@property (nonatomic) YTAuthRequestManager *requestManager;
@property (nonatomic) YTAuthResponseManager *responseManager;

// This sends token request when correct redirect URL is passed
- (BOOL)handleUrlLoad:(NSURL *)url;

@end
