//
//  LoginViewController.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 27/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTLoginViewController.h"
#import "YTTransferViewController.h"

static NSString * const kNavItemTitle = @"Login";

@interface YTLoginViewController () <UIWebViewDelegate, YTAuthResponseManagerDelegate>

@property (nonatomic) UINavigationBar *navBar;
@property (nonatomic) UIWebView *webView;
@property (nonatomic) YTAuthSession *authSession;

@end

@implementation YTLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.authSession = [[YTAuthSession alloc] init];
    self.authSession.responseManager.delegate = self;
    
    [self setupLayout];
    
    self.webView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadAuthorization];
}

- (void)viewDidDisappear:(BOOL)animated
{
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

- (void)setupLayout
{
    self.navigationItem.title = kNavItemTitle;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.webView];
}

- (void)loadAuthorization
{
    NSURLRequest *authRequest = [self.authSession.requestManager authorizationRequest];
    [self.webView loadRequest:authRequest];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL should = [self.authSession handleUrlLoad:request.URL];
    return should;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.navBar.topItem.title = @"Network error";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.title = kNavItemTitle;
}

#pragma YTAuthResponseManagerDelegate

- (void)authResponseManagerDidHandleToken
{
    dispatch_sync(dispatch_get_main_queue(), ^{
       [self performSegueWithIdentifier:@"LoginSuccess" sender:nil]; // No need to pass a sender
    });
}

@end