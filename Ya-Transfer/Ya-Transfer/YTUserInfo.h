//
//  YTUserInfo.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTUserInfo : NSObject

@property (nonatomic) NSString *moneyLeft;

- (instancetype)initWithCurrentUserInfo;

@end
