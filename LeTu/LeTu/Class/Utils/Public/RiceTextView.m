//
//  RiceTextView.m
//  riceText
//
//  Created by zc on 12-11-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RiceTextView.h"

@interface RiceTextView (private)

- (void)initViews;

- (void)initData;

@end

@implementation RiceTextView

@synthesize delegate;

@synthesize text;
@synthesize textColor;
@synthesize font;
@synthesize normalColor;
@synthesize highlightColor;

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (mWebView == nil)
    {
        [self initViews];
    }
    
    super.backgroundColor = backgroundColor;
    if (backgroundColor == [UIColor clearColor]) 
    {
        mWebView.backgroundColor = backgroundColor;
        [mWebView setOpaque:NO];
        mBackgroundColor = @"transparent";
    }
    else
    {
        mBackgroundColor = @"";
    }
    
    [self initData];
}

- (void)initViews
{
    textColor = @"#000000";
//    familyName = [UIFont systemFontOfSize:12].familyName;
//    fontSize = 12.0f;
    font = [UIFont systemFontOfSize:12];
    normalColor = @"0066a0";
    
    mWebView = [[UIWebView alloc] init];
    mWebView.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    mWebView.delegate = self;
    mWebView.scrollView.scrollEnabled = NO;
    [self addSubview:mWebView];
}

- (void)initData
{
    NSMutableString *html = [NSMutableString stringWithCapacity:10];
    [html appendString:@"<html><head><meta http-equiv='content-type' content='text/html; charset=UTF-8' /><style>"];
    [html appendFormat:@"body{margin:0; background-color:'%@';}", mBackgroundColor];
    [html appendFormat:@"div{font-size:%fpx;font-family:%@;}", font.pointSize, font.familyName];
    [html appendFormat:@"span{font-size:%fpx;font-family:%@;}", font.pointSize, font.familyName];
    [html appendFormat:@"#myId{word-break:break-all;width:%fpx}", self.frame.size.width];
    [html appendString:@"</style><script type='text/javascript'>"];
    [html appendString:@"function myClick(a){document.location = 'testapp:'+a.innerHTML;}"];
    [html appendFormat:@"</script></head><body><div id='myId'><font color='%@'>", textColor];
    [html appendString:[self wordWithString:text]];
    [html appendString:@"</font></div></html></body>"];
    [mWebView loadHTMLString:html baseURL:nil];
}

/**
 * to html
 */
- (NSString *)wordWithString:(NSString *)string
{
    NSMutableString *htmlStr = [NSMutableString stringWithCapacity:10];
    NSMutableArray *indexArr = [NSMutableArray arrayWithCapacity:1];
    unichar word;
    for (int i = 0; i < string.length; i++)
    {
        word = [string characterAtIndex:i];
        if (word == '#')
        {
            [indexArr addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    if (indexArr.count % 2 == 1)
    {
        [indexArr removeObjectAtIndex:indexArr.count - 1];
    }
    
    int lastIndex = 0, currIndex = 0;
    NSRange range;
    BOOL isBegin = NO;
    for (NSNumber *num in indexArr)
    {
        currIndex = [num intValue];
        if (currIndex - lastIndex > 1 && isBegin)
        {
            range = NSMakeRange(lastIndex, currIndex - lastIndex + 1);
            if (lastIndex != 0)
            {
                [htmlStr appendFormat:@" "];
            }
            [htmlStr appendFormat:@"<font color='%@'><span onclick='myClick(this)'>%@</span></font> ",normalColor, [string substringWithRange:range]];
            //[stringArr addObject:[string substringWithRange:range]];
            isBegin = NO;
            lastIndex = currIndex + 1;
        }
        else
        {
            range = NSMakeRange(lastIndex, currIndex - lastIndex);
            NSString *str = [string substringWithRange:range];
            if (! [str isEqualToString:@""])
            {
                [htmlStr appendString:str];
                //[stringArr addObject:str];
            }
            isBegin = YES;
            lastIndex = currIndex;
        }
    }
    
    [htmlStr appendString:[string substringFromIndex:lastIndex]];
    //[stringArr addObject:[string substringFromIndex:lastIndex]];
    
    return htmlStr;
}

- (void)setFont:(UIFont *)ft
{
    if (mWebView == nil)
    {
        [self initViews];
    }
    
    font = ft;
    
    [self initData];
}

- (void)setTextColor:(NSString *)textColorStr
{
    if (mWebView == nil)
    {
        [self initViews];
    }
    
    textColor = textColorStr;
    
    [self initData];
}

- (void)setText:(NSString *)textStr
{
    if (mWebView == nil)
    {
        [self initViews];
    }
    
    text = textStr;
    
    [self initData];
}

- (void)normalColor:(NSString *)normalColorStr
{
    if (mWebView == nil)
    {
        [self initViews];
    }
    
    normalColor = normalColorStr;
    
    [self initData];
}

- (void)highlightColor:(NSString *)highlightColorStr
{
    if (mWebView == nil)
    {
        [self initViews];
    }
    
    highlightColor = highlightColor;
    
    [self initData];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [request.URL absoluteString];
    //NSLog(@"requestString:%@", requestString);
    NSString *component = [requestString substringToIndex:8];
    if (component != nil && [component isEqualToString:@"testapp:"])
    {
        [delegate riceTextView:[[requestString substringFromIndex:8]
                                stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *getHeightJS = @"document.getElementById('myId').offsetHeight";
    NSString *height = [webView stringByEvaluatingJavaScriptFromString:getHeightJS];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            self.frame.size.width, [height intValue]);
    webView.frame = CGRectMake(0, 0, self.frame.size.width, [height intValue]);
}



@end
