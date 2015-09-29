//
//  YTResponseManager.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 28/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTResponseManager.h"
#import "YTNetworkingHelper.h"

@implementation YTResponseManager

- (void)handleTokenResponse:(NSData *)data
{
    NSError *parsingError = nil;
    id responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
    if (parsingError) {
#ifdef DEBUG
        NSLog(@"GetToken parsing error: %@\n", parsingError);
#endif
    } else {
        if (responseDict[kAuthTokenParamName]) {
            NSString *authToken = responseDict[kAuthTokenParamName];
                
            // TODO Save to keychain && AES/3DES
            [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:@"token"];
            
            [self.delegate responseManagerDidHandleToken];
        } // Web interface seems to handle other cases, apparently no else needed
        
    }
}

@end
