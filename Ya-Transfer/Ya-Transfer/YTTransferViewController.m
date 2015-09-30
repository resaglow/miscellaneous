//
//  YTTransferViewController.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 28/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTTransferViewController.h"
#import "YTScrollViewWrapper.h"
#import "YTUserInfo.h"

// TODO: Clear out constants

@interface YTTransferViewController ()

@property (nonatomic) YTScrollViewWrapper *scrollViewWrapper;
@property (nonatomic) YTUserInfo *userInfo;

@end

@implementation YTTransferViewController

- (void)viewDidLoad
{
    self.userInfo = [[YTUserInfo alloc] initWithCurrentUserInfo];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.85f alpha:1.0f];
    [self setupScrollView];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                     style:UIBarButtonItemStylePlain target:self action:@selector(handleSend)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}

- (void)setupScrollView
{
    self.scrollViewWrapper = [[YTScrollViewWrapper alloc] initWithController:self];
    self.scrollViewWrapper.scrollView.moneyLeftLabel.text = self.userInfo.moneyLeft ?
    [@"Money left: " stringByAppendingString:self.userInfo.moneyLeft] :
    @"Can't fetch left money";
}

#pragma mark - Send button handler

- (void)handleSend
{
    // Execute payment with completion of segue to success
}

@end
