//
//  YTHistoryRequestManager.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 01/10/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTHistoryRequestManager.h"
#import "YTNetworkingHelper.h"

@implementation YTHistoryRequestManager

- (NSURLRequest *)historyRequestWithType:(NSString *)type
                             startRecord:(NSString *)startRecord
                            recordsCount:(NSString *)recordsCount
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kHistoryPath
                                                                              relativeToURL:[YTNetworkingHelper sharedInstance].baseApiUrl]];
    
    request.HTTPMethod = @"POST";
    [request addValue:kHeaderContentTypeUrlEncoded forHTTPHeaderField:kHeaderContentType];
    
    NSString *bodyString = [[YTNetworkingHelper sharedInstance] urlEncodedStringWithParams:@{kOperationTypeParamName: type,
                                                                                             kHistoryStartRecordParamName: startRecord,
                                                                                             kHistoryRecordsParamName: recordsCount}];
    
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyString length]] forHTTPHeaderField:kHeaderContentLength];
    
    return request;    
}

@end