//
//  FaceTextView.m
//  AHAOrdering
//
//  Created by cyberway on 14-3-10.
//
//

#import "FaceTextView.h"
#import "Utility.h"

@implementation FaceTextView

@synthesize delegate = _delegate;
@synthesize textView = _textView;
@synthesize font = _font;
@synthesize textColor = _textColor;
@synthesize text = _text;
@synthesize placeholder = _placeholder;

- (id)init
{
    if (self == [super init])
    {
//        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        [self initialize];
    }
    
    return self;
}

/** 初始化控件 */
- (void)initialize
{
    self.font = [UIFont systemFontOfSize:12];
    self.textColor = [Utility colorWithHexString:@"#999999"];
    
    
    
    
    _textView = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = _font;
    _textView.textColor = _textColor;
    _textView.returnKeyType=UIReturnKeySend;
    [self addSubview:_textView];
    
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width, 20)];
    placeholderLabel.backgroundColor = [UIColor clearColor];
    placeholderLabel.font = _font;
    placeholderLabel.textColor = _textColor;
    placeholderLabel.text = _placeholder;
    [self addSubview:placeholderLabel];
    if (_placeholder)
    {
        placeholderLabel.hidden = NO;
    }
}

- (BOOL)becomeFirstResponder
{
    [_textView becomeFirstResponder];
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [_textView resignFirstResponder];
    
    return [super resignFirstResponder];
}

/** 设置字体 */
- (void)setFont:(UIFont *)font
{
    _font = font;
    _textView.font = _font;
    placeholderLabel.font = _font;
}

/** 设置文字颜色 */
- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _textView.textColor = _textColor;
    placeholderLabel.textColor = _textColor;
}

/** 设置文字 */
- (void)setText:(NSString *)text
{
    _text = text;
    _textView.text = _text;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if (_placeholder && ![_placeholder isEqualToString:@""])
    {
        placeholderLabel.hidden = NO;
        placeholderLabel.text = _placeholder;
    }
    else
    {
        placeholderLabel.hidden = YES;
    }
}

- (void)setPlaceholderHidden:(BOOL)isHidden
{
    placeholderLabel.hidden = isHidden;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _text = textField.text;
    
    // 设置调用代理
    SEL selector = @selector(faceTextViewDidBeginEditing:);
    if (_delegate && [_delegate respondsToSelector:selector])
    {
        [_delegate faceTextViewDidBeginEditing:self];
    }
}

/**
 *  textView 代理
 */

- (BOOL)textViewShouldBeginEditing:(UITextField *)textView
{
    _text = textView.text;
    
    // 设置调用代理
    SEL selector = @selector(faceTextViewShouldBeginEditing:);
    if (_delegate && [_delegate respondsToSelector:selector])
    {
        return [_delegate faceTextViewShouldBeginEditing:self];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextField *)textView
{
    _text = textView.text;
    
    // 设置调用代理
    SEL selector = @selector(faceTextViewShouldEndEditing:);
    if (_delegate && [_delegate respondsToSelector:selector])
    {
        return [_delegate faceTextViewShouldEndEditing:self];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextField *)textView
{
    _text = textView.text;
    
    // 设置调用代理
    SEL selector = @selector(faceTextViewDidBeginEditing:);
    if (_delegate && [_delegate respondsToSelector:selector])
    {
        [_delegate faceTextViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextField *)textView
{
    _text = textView.text;
    
    // 设置调用代理
    SEL selector = @selector(faceTextViewDidEndEditing:);
    if (_delegate && [_delegate respondsToSelector:selector])
    {
        [_delegate faceTextViewDidEndEditing:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    _text = textView.text;
    
    // 设置调用代理
    SEL selector = @selector(faceTextView: shouldChangeTextInRange: replacementText:);
    if (_delegate && [_delegate respondsToSelector:selector])
    {
        return [_delegate faceTextView:self shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (void)textViewDidChange:(UITextField *)textView
{
    _text = textView.text;
    
    // 设置显隐
    if (textView.text.length == 0)
    {
        placeholderLabel.hidden = NO;
    }
    else
    {
        placeholderLabel.hidden = YES;
    }
    
    // 设置调用代理
    SEL selector = @selector(faceTextViewDidChange:);
    if (_delegate && [_delegate respondsToSelector:selector])
    {
        [_delegate faceTextViewDidChange:self];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(faceTextViewTextFieldShouldReturn:)])
        return [_delegate faceTextViewTextFieldShouldReturn:self];
    
    [textField resignFirstResponder];
    return YES;

}

- (void)textViewDidChangeSelection:(UITextField *)textView
{
    _text = textView.text;
    
    // 设置调用代理
    SEL selector = @selector(faceTextViewDidChangeSelection:);
    if (_delegate && [_delegate respondsToSelector:selector])
    {
        [_delegate faceTextViewDidChangeSelection:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0)
{
    _text = textView.text;
    
    // 设置调用代理
    SEL selector = @selector(faceTextView: shouldInteractWithURL: inRange:);
    if (_delegate && [_delegate respondsToSelector:selector])
    {
        return [_delegate faceTextView:self shouldInteractWithURL:URL inRange:characterRange];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0)
{
    _text = textView.text;
    
    // 设置调用代理
    SEL selector = @selector(faceTextView: shouldInteractWithTextAttachment: inRange:);
    if (_delegate && [_delegate respondsToSelector:selector])
    {
        return [_delegate faceTextView:self shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return YES;
}

@end
