//
//  RiceTextView.h
//  riceText
//
//  Created by zc on 12-11-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RiceTextViewDelegate <NSObject>

- (void)riceTextView:(NSString *)keyWord;

@end

@interface RiceTextView : UIView <UIWebViewDelegate>
{
    UIWebView *mWebView;
    NSString *mBackgroundColor;
}

@property (nonatomic, assign) id<RiceTextViewDelegate> delegate;
@property (nonatomic, assign) NSString *text;
@property (nonatomic, assign) NSString *textColor;
@property (nonatomic, assign) UIFont *font;
@property (nonatomic, assign) NSString *normalColor;
@property (nonatomic, assign) NSString *highlightColor;

- (void)setText:(NSString *)text;

@end
