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

static NSString * const kNavItemTitle = @"Transfer";

// TODO: Clear out constants

@interface YTTransferViewController () <YTPaymentResponseManagerDelegate>

@property (nonatomic) YTScrollViewWrapper *scrollViewWrapper;
@property (nonatomic) YTPaymentSession *paymentSession;
@property (nonatomic) NSString *protectionCode;

@end

@implementation YTTransferViewController

- (void)viewDidLoad
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = kNavItemTitle;
    
    self.view.backgroundColor = [UIColor colorWithWhite:.85f alpha:1.0f];
    [self setupScrollView];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                     style:UIBarButtonItemStylePlain target:self action:@selector(handleSend)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];

    // TODO DEBUG
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                             target:self action:@selector(debugSuccessSegue)];
    
    self.paymentSession = [[YTPaymentSession alloc] init];
    self.paymentSession.responseManager.delegate = self;
}

- (void)setupScrollView
{
    self.scrollViewWrapper = [[YTScrollViewWrapper alloc] initWithController:self];
}

// TODO DEBUG
- (void)debugSuccessSegue
{
    [self performSegueWithIdentifier:@"TransferSuccess" sender:nil];
}

#pragma mark - Send button handler

- (void)handleSend
{
    YTScrollView *scrollView = self.scrollViewWrapper.scrollView;
    
    NSUInteger recipientId = [scrollView.recipientTextField.text integerValue];
    NSInteger amount = [scrollView.toPayTextField.text integerValue];
    BOOL prCodeEnabled = scrollView.protectionCodeSwitch.on;
    NSString *prCodeExpirePeriod = scrollView.protectionCodeView.validityPeriodLabel.text;
    NSString *comment = scrollView.commentTextView.text;
    
    // TODO Client side validation
    
    YTOperation *newTransaction = [[YTOperation alloc] initWithRecipientId:recipientId
                                                                    amount:amount
                                                                   comment:comment
                                                             prCodeEnabled:prCodeEnabled
                                                        prCodeExpirePeriod:prCodeExpirePeriod];
    
    [self.paymentSession sendPaymentWithTransaction:newTransaction];
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
        NSLog(@"NOOOOOOOOO\n"); // TODO
    }
}

@end
