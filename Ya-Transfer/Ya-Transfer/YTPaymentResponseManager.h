//
//  YTPaymentResponseManager.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YTPaymentResponseManagerDelegate

- (void)paymentResponseManagerDidGetProtectionCode:(NSString *)protectionCode;
- (void)paymentResponseManagerDidProcessPaymentResult:(BOOL)success;

@end

@interface YTPaymentResponseManager : NSObject

@property (nonatomic, weak) id<YTPaymentResponseManagerDelegate> delegate;

- (void)handleRequestPaymentResponse:(NSData *)data completion:(void (^)(NSString *))handler;
- (void)handleProcessPaymentResponse:(NSData *)data completion:(void (^)(BOOL))handler;

@end