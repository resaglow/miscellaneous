//
//  YTAuthRequestsManager.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 28/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTAuthRequestsManager : NSObject

- (NSURLRequest *)authorizationRequest;
- (NSURLRequest *)tokenRequestWithCode:(NSString *)code;

@end
