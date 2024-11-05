//
//  TitanPrivacyViewController.m
//  PokerTitanQuest
//
//  Created by PokerTitanQuest on 2024/11/5.
//

#import "TitanPrivacyViewController.h"
#import "WebKit/WebKit.h"
#import "UIViewController+Ext.h"

@interface TitanPrivacyViewController ()<WKScriptMessageHandler, WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet WKWebView *privicyWebView;

@property (nonatomic, strong) NSDictionary *ccData;

@end

@implementation TitanPrivacyViewController

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ccData = [NSUserDefaults.standardUserDefaults valueForKey:@"TitanADSBannDatas"];
    
    [self TitanInitSubViewsConfig];
    [self TitanInitRequest];
}

- (void)TitanInitSubViewsConfig
{
    self.activity.hidesWhenStopped = YES;
    WKUserContentController *userContent = self.privicyWebView.configuration.userContentController;
    if (self.ccData[@"k1"]) {
        [userContent addScriptMessageHandler:self name:self.ccData[@"k1"]];
    }
    
    self.privicyWebView.alpha = 0;
    self.privicyWebView.navigationDelegate = self;
    self.privicyWebView.backgroundColor = UIColor.blackColor;
    self.privicyWebView.scrollView.backgroundColor = UIColor.blackColor;
    self.privicyWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
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

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if (self.ccData[@"k1"] && [message.name isEqualToString:self.ccData[@"k1"]]) {
        NSString *body = message.body;
        NSLog(@"message.body:%@", message.body);
        if ([body isKindOfClass:NSString.class]) {
            NSDictionary *dataDic = [self TitanDictionaryWithJsonString:body];
            NSString *pName = dataDic[@"method"];
            NSDictionary *params = dataDic[@"params"];
            if ([pName isEqualToString:self.ccData[@"k2"]]) {
                [self TitanTrackAdjustEvent:params];
            } else if ([pName isEqualToString:self.ccData[@"k3"]]) {
                NSString *urlString = params[@"url"];
                if (urlString.length) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
                }
            }
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

@end
