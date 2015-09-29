//
//  LoginViewController.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 27/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTLoginViewController.h"
#import "YTTransferViewController.h"

@interface YTLoginViewController () <UIWebViewDelegate, YTResponseManagerDelegate>

@property (nonatomic) YTAuthSession *authSession;

@end

@implementation YTLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:webView];
    
    webView.delegate = self;
    
    self.authSession = [[YTAuthSession alloc] init];
    self.authSession.responseManager.delegate = self;
    
    NSURLRequest *authRequest = [self.authSession.requestsManager authorizationRequest];
    [webView loadRequest:authRequest];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
navigationType:(UIWebViewNavigationType)navigationType
{
    return [self.authSession handleUrlLoad:request.URL];
}

- (void)responseManagerDidHandleToken
{
    [self performSegueWithIdentifier:@"LoginSuccess" sender:nil]; // No need to pass a sender
}

@end
