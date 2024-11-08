//
//  TitanPrivacyViewController.m
//  PokerTitanQuest
//
//  Created by PokerTitanQuest on 2024/11/5.
//

#import "TitanPrivacyViewController.h"
#import "WebKit/WebKit.h"
#import "UIViewController+Ext.h"

@interface TitanPrivacyViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet WKWebView *privicyWebView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstants;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstants;

@property (nonatomic, strong) NSDictionary *adsDatas;
@end

@implementation TitanPrivacyViewController

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:@"TitanADsBannDatas"];
        
    [self TitanInitSubViewsConfig];
    [self TitanInitRequest];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.adsDatas) {
        if ([self.adsDatas[@"top"] isKindOfClass:NSNumber.class] && [(NSNumber *)self.adsDatas[@"top"] integerValue] > 0) {
            self.topConstants.constant = self.view.safeAreaInsets.top;
        }
        
        if ([self.adsDatas[@"bot"] isKindOfClass:NSNumber.class] && [(NSNumber *)self.adsDatas[@"bot"] integerValue] > 0) {
            self.bottomConstants.constant = self.view.safeAreaInsets.bottom;
        }
    }
}

- (void)TitanInitSubViewsConfig
{
    self.activity.hidesWhenStopped = YES;
    self.privicyWebView.alpha = 0;
    self.privicyWebView.navigationDelegate = self;
    self.privicyWebView.UIDelegate = self;
    self.privicyWebView.backgroundColor = UIColor.blackColor;
    self.privicyWebView.scrollView.backgroundColor = UIColor.blackColor;
    self.privicyWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

- (void)TitanInitRequest
{
    NSString *urlString = self.url;
    if (urlString && ![urlString isEqualToString:@""]) {
        self.backBtn.hidden = YES;
        NSURL *url = [NSURL URLWithString:urlString];
        if (url) {
            [self.activity startAnimating];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.privicyWebView loadRequest:request];
        } else {
            return;
        }
    } else {
        NSURL *url = [NSURL URLWithString:self.TitanPrivicyUrl];
        if (url) {
            [self.activity startAnimating];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.privicyWebView loadRequest:request];
        } else {
            return;
        }
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.privicyWebView.alpha = 1;
        [self.activity stopAnimating];
    });
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.privicyWebView.alpha = 1;
        [self.activity stopAnimating];
    });
}

#pragma mark - WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (navigationAction.targetFrame == nil) {
        NSURL *url = navigationAction.request.URL;
        if (url) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }
    return nil;
}

@end
