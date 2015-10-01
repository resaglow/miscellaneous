//
//  YTHistoryDataManager.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTHistoryDataManager.h"
#import "YTHistorySession.h"

@interface YTHistoryDataManager () <YTHistoryResponseManagerDelegate>

@property (nonatomic) YTHistorySession *historySession;

@end

@implementation YTHistoryDataManager

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.historySession = [[YTHistorySession alloc] init];
        self.historySession.responseManager.delegate = self;
    }
    
    return self;
}

//- (NSArray *)updateHistory
//{
////    [YTHistorySession fetchHistory];
//}
//
//- (NSArray *)getHistory
//{
//    
//}

@end