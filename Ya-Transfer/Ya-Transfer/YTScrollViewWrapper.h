//
//  YTScrollViewWrapper.h
//  Ya-Transfer
//
//  Created by Artem Lobanov on 29/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTScrollView.h"

@interface YTScrollViewWrapper : NSObject

@property (nonatomic) YTScrollView *scrollView;

- (instancetype)initWithController:(UIViewController *)viewController;

@end
