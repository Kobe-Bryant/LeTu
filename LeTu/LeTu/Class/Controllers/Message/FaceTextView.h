//
//  FaceTextView.h
//  AHAOrdering
//
//  Created by cyberway on 14-3-10.
//
//

#import <UIKit/UIKit.h>

@class FaceTextView;

@protocol FaceTextViewDelegate <NSObject, UIScrollViewDelegate>

@optional

- (BOOL)faceTextViewShouldBeginEditing:(FaceTextView *)faceTextView;
- (BOOL)faceTextViewShouldEndEditing:(FaceTextView *)faceTextView;

- (void)faceTextViewDidBeginEditing:(FaceTextView *)faceTextView;
- (void)faceTextViewDidEndEditing:(FaceTextView *)faceTextView;

- (BOOL)faceTextView:(FaceTextView *)faceTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)faceTextViewDidChange:(FaceTextView *)faceTextView;

- (void)faceTextViewDidChangeSelection:(FaceTextView *)faceTextView;

- (BOOL)faceTextView:(FaceTextView *)faceTextView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0);
- (BOOL)faceTextView:(FaceTextView *)faceTextView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0);

/** 当returnkey按下的时候 */
- (BOOL)faceTextViewTextFieldShouldReturn:(FaceTextView *)faceTextView;

@end

@interface FaceTextView : UIView <UITextViewDelegate,UITextFieldDelegate>
{
    id<FaceTextViewDelegate> _delegate;
    
//    UITextView *_textView;
    UITextField *_textView;
//    UIFont *_font;
//    UIColor *_textColor;
//    NSString *_text;
    
    UILabel *placeholderLabel;
}

@property (nonatomic, strong) id<FaceTextViewDelegate> delegate;
@property (nonatomic, strong, readonly) UITextField *textView;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *placeholder;

- (void)setPlaceholderHidden:(BOOL)isHidden;

@end
