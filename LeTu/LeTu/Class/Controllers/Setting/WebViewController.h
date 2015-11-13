//
//  WebViewController.h
//  E-learning
//
//  Created by Mac Air on 13-9-10.
//
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController<UIWebViewDelegate>
{
    UIActivityIndicatorView *activityIndicatorView;
    UIWebView *webView;
    NSString *openURL;
}
- (id) initWithOpenURL:(NSString *) url;
//@property (strong, nonatomic) NSString *openURL;

@end
