//
//  YTTransferViewController.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 28/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTTransferViewController.h"
#import "YTScrollViewWrapper.h"
#import "YTPaymentSession.h"
#import "YTOperation.h"
#import "YTHistoryDataManager.h"

static NSString * const kNavItemTitle = @"Transfer";

// TODO: Clear out constants

@interface YTTransferViewController () <YTPaymentResponseManagerDelegate>

@property (nonatomic) YTScrollViewWrapper *scrollViewWrapper;
@property (nonatomic) YTPaymentSession *paymentSession;
@property (nonatomic) YTHistoryDataManager *historyDataManager;
@property (nonatomic) NSString *protectionCode;

@end

@implementation YTTransferViewController

- (void)viewDidLoad
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = kNavItemTitle;
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.85f alpha:1.0f];
    [self setupScrollView];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                     style:UIBarButtonItemStylePlain target:self action:@selector(handleSend)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.leftBarButtonItem.title = @"More";
    self.navigationItem.leftBarButtonItem.target = self;
    self.navigationItem.leftBarButtonItem.action = @selector(handleMoreTap);
    
    self.paymentSession = [[YTPaymentSession alloc] init];
    self.paymentSession.responseManager.delegate = self;
    
    self.historyDataManager = [YTHistoryDataManager sharedInstance];
}

- (void)setupScrollView
{
    self.scrollViewWrapper = [[YTScrollViewWrapper alloc] initWithController:self];
}

- (void)handleMoreTap
{
    [self performSegueWithIdentifier:@"More" sender:nil];
}

#pragma mark - Send button handler

- (void)handleSend
{
    YTScrollView *scrollView = self.scrollViewWrapper.scrollView;
    
    NSString *recipientId = scrollView.recipientTextField.text;
    NSInteger amount = [scrollView.toPayTextField.text integerValue];
    BOOL prCodeEnabled = scrollView.protectionCodeSwitch.on;
    NSString *prCodeExpirePeriod = scrollView.protectionCodeView.validityPeriodLabel.text;
    NSString *comment = scrollView.commentTextView.text;
    
    // TODO Client side validation
    
    YTOperation *newOperation = [[YTOperation alloc] initWithRecipientId:recipientId
                                                                  amount:amount
                                                                 comment:comment
                                                           prCodeEnabled:prCodeEnabled
                                                      prCodeExpirePeriod:prCodeExpirePeriod];
    
    [self.historyDataManager updateHistory:@[newOperation]];
    
    [self.paymentSession sendPaymentWithTransaction:newOperation];
}


- (void)paymentResponseManagerDidGetProtectionCode:(NSString *)protectionCode
{
    self.protectionCode = protectionCode;
}

- (void)paymentResponseManagerDidProcessPaymentResult:(BOOL)success
{
    if (success) {
        [self performSegueWithIdentifier:@"LoginSuccess" sender:nil]; // No need to pass a sender
    } else {
        NSLog(@"Payment error\n");
    }
}

@end
