//
//  NSString+CorrectedHeightForTextView.m
//  PGCBD
//
//  Created by IOS on 13-6-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "NSString+CorrectedHeightForTextView.h"

@implementation NSString (CorrectedHeightForTextView)


/*
 修复- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(UILineBreakMode)lineBreakMode ——修复带来的高度不正确
 */

+ (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{  
    
    float fPadding = 16.0; // 8.0px x 2  
    
    CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding, CGFLOAT_MAX);  
    
    CGSize size = [strText sizeWithFont: textView.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];  
    
    float fHeight = size.height + 16.0;  
    
    return fHeight;  
}  
@end
