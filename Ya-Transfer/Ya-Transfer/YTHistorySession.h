//
//  YTHistorySession.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 01/10/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTHistoryRequestManager.h"
#import "YTHistoryResponseManager.h"
#import "YTSession.h"

@interface YTHistorySession : YTSession

@property (nonatomic) YTHistoryRequestManager *requestManager;
@property (nonatomic) YTHistoryResponseManager *responseManager;

@end