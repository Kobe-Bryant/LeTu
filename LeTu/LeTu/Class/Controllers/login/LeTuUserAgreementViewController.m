//
//  LeTuUserAgreementViewController.m
//  LeTu
//
//  Created by Jason on 2014/7/25.
//
//

#import "LeTuUserAgreementViewController.h"

//#define LeTuUserAgreementPath @"http://apps.wealift.com:81/yhxy.html"
#define LeTuUserAgreementPath @"http://apps.wealift.com:8082/upload/hyxy.html"

@interface LeTuUserAgreementViewController () {
    UIWebView *_contentWebView;
}

@end

@implementation LeTuUserAgreementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"用户协议" andShowButton:YES];
    
    CGRect frame = self.view.frame;
    frame.origin.y += 44;
    frame.size.height -= 64;
    
    _contentWebView = [[UIWebView alloc] initWithFrame:frame];
    [self.view addSubview:_contentWebView];
    
    NSURLRequest *userAgreementRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:LeTuUserAgreementPath]];
    [_contentWebView loadRequest:userAgreementRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
