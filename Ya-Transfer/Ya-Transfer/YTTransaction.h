//
//  YTTransaction.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 30/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTTransaction : NSObject

@property (nonatomic) NSString *recipientId; // May be not a number
@property (nonatomic) NSString *amount; // Not to have even more conversions
@property (nonatomic) NSString *comment;
@property (nonatomic) BOOL      prCodeEnabled;
@property (nonatomic) NSString *prCodeExpirePeriod;

- (instancetype)initWithRecipientId:(NSString *)recipientId
                             amount:(NSString *)amount
                            comment:(NSString *)comment
                      prCodeEnabled:(BOOL)prCodeEnabled
                 prCodeExpirePeriod:(NSString *)prCodeExpirePeriod;

@end
