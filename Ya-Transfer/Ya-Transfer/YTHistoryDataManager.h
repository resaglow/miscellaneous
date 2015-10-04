//
//  YTHistoryDataManager.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTHistoryDataManager : NSObject

- (void)updateHistory:(NSArray *)operations;
- (NSArray *)getHistory;

+ (instancetype)sharedInstance;

@end
