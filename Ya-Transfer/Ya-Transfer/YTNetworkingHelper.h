//
//  YTNetworkingHelper.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 27/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <UIKit/UIKit.h>

// Networkig helper methods & constants (seems not so bad in one class)

extern NSString * const kTrue;
extern NSString * const kFalse;
extern NSString * const kError; // generic error constant

extern NSString * const kBaseUrlString;
extern NSString * const kBaseApiUrlString;

extern NSString * const kAuthorizePath;
extern NSString * const kTokenPath;
extern NSString * const kRequstPaymentPath;
extern NSString * const kProcessPaymentPath;
extern NSString * const kHistoryPath;

extern NSString * const kClientIdParamName;
extern NSString * const kClientId;

// Authorization constants
extern NSString * const kAuthResponseTypeParamName;
extern NSString * const kAuthResponseType;
extern NSString * const kAuthRedirectUriParamName;
extern NSString * const kAuthRedirectUri; // dummy website to redirect to
extern NSString * const kAuthScopeParamName;
extern NSString * const kAuthGrantTypeParamName;
extern NSString * const kAuthGrantType;
extern NSString * const kAuthTokenParamName;

// Payment constants
extern NSString * const kPaymentOperationIdParamName;
extern NSString * const kPaymentPatternIdParamName;
extern NSString * const kPaymentPatternIdP2P;
extern NSString * const kPaymentToParamName;
extern NSString * const kPaymentAmountParamName;
extern NSString * const kPaymentCommentParamName;
extern NSString * const kPaymentMessageParamName;
extern NSString * const kPaymentCodeproParamName;
extern NSString * const kPaymentExpirePeriodParamName;
extern NSString * const kPaymentRequestIdParamName;
extern NSString * const kPaymentProtectionCodeParamName;
extern NSString * const kPaymentStatusParamName;
extern NSString * const kPaymentStatusSuccess;
extern NSString * const kPaymentDateTimeParamName;
extern NSString * const kOperationTypeParamName;
extern NSString * const kPaymentPaymentParamName;

// History constants
extern NSString * const kHistoryStartRecordParamName;
extern NSString * const kHistoryRecordsParamName;
extern NSString * const kHistoryOperations;

extern NSString * const kHeaderContentType;
extern NSString * const kHeaderContentTypeUrlEncoded;
extern NSString * const kHeaderContentLength;

extern NSInteger const kRequestErrorCode;

// This one seems worth making a singleton
// TODO: No it doesn't. Remove singleton

@interface YTNetworkingHelper : UIViewController

@property (readonly, nonatomic) NSURL *baseApiUrl;
@property (readonly, nonatomic) NSArray *authRightsArray;

- (NSString *)urlEncodedStringWithParams:(NSDictionary *)params;
- (NSString *)percentEscapeUrl:(NSString *)string;

// Not strictly for a method yet still reasonably clear
- (NSError *)requestErrorForMethod:(NSString *)methodName statusCode:(NSUInteger)statusCode;

+ (instancetype)sharedInstance;

@end
