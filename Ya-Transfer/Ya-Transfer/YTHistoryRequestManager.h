//
//  YTHistoryRequestManager.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 01/10/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTHistoryRequestManager : NSObject

- (NSURLRequest *)historyRequestWithType:(NSString *)type
                             startRecord:(NSString *)startRecord
                            recordsCount:(NSString *)recordsCount;

@end