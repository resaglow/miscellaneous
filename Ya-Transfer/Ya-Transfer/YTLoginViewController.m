//
//  LoginViewController.m
//  Ya-Transfer
//
//  Created by Artem Lobanov on 27/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#import "YTLoginViewController.h"
#import "YTTransferViewController.h"

static NSString * const kLoginTitle = @"Login";
static NSInteger const kBarHeight = 64; // 20 for top bar + 44 for navbar

@interface YTLoginViewController () <UIWebViewDelegate, YTAuthResponseManagerDelegate>

@property (nonatomic) UINavigationBar *navBar;
@property (nonatomic) UIWebView *webView;
@property (nonatomic) YTAuthSession *authSession;

@end

@implementation YTLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.authSession = [[YTAuthSession alloc] init];
    self.authSession.responseManager.delegate = self;
    
    [self setupLayout];
    
    self.webView.delegate = self;
    
    [self loadAuthorization];
}

- (void)setupLayout
{
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kBarHeight)];
    navbar.backgroundColor = [UIColor brownColor];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = kLoginTitle;
    navItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                  target:self action:@selector(loadAuthorization)];
    navItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    navbar.items = @[navItem];
    
    [self.view addSubview:navbar];
    self.navBar = navbar;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kBarHeight, self.view.frame.size.width, self.view.frame.size.height - kBarHeight)];
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
    return [self.authSession handleUrlLoad:request.URL];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.navBar.topItem.title = @"Network error";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.title = kLoginTitle;
}

#pragma YTAuthResponseManagerDelegate

- (void)authResponseManagerDidHandleToken
{
    [self performSegueWithIdentifier:@"LoginSuccess" sender:nil]; // No need to pass a sender
}

@end