//
//  YTHistorySession.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 01/10/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTHistorySession.h"

@implementation YTHistorySession

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.requestManager = [[YTHistoryRequestManager alloc] init];
        self.responseManager = [[YTHistoryResponseManager alloc] init];
    }
    
    return self;
}

- (void)fetchAllHistory
{
    
}

- (void)fetchLastTransactions:(NSInteger)transactionsCount
{
    // TODO
}

@end