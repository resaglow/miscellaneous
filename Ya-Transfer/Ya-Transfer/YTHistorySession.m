//
//  YTHistorySession.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 01/10/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTHistorySession.h"
#import "YTNetworkingHelper.h"

static NSString * const kRecordsCountString = @"100";

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
    NSArray *history = @[];
    NSURLRequest *request = [self.requestManager historyRequestWithType:kPaymentPaymentParamName
                                                            startRecord:0
                                                           recordsCount:kRecordsCountString];
    // TODO MAIN STUCK
}

- (void)fetchLastTransactions:(NSInteger)transactionsCount
{
    // TODO
}

@end