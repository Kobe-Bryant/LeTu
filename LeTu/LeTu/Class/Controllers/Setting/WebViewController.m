//
//  WebViewController.m
//  E-learning
//
//  Created by Mac Air on 13-9-10.
//
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id) initWithOpenURL:(NSString *) url
{
    openURL = url;
    self = [super init];
    if (self) {
        
        NSLog(@"%@", openURL);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitleImage:nil andShowButton:YES];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height - 90)];
    webView.delegate = self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:openURL]];
    NSLog(@"%@", openURL);
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
    activityIndicatorView = [ [ UIActivityIndicatorView  alloc ]
                             initWithFrame:CGRectMake(150.0,210.0,30.0,30.0)];
    
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:activityIndicatorView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WebViewDelegate
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicatorView startAnimating];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicatorView stopAnimating];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicatorView stopAnimating];
    [[[[iToast makeText:@"打开网页失败"] setGravity:iToastGravityCenter] setDuration:iToastDurationShort] show];
}


@end
