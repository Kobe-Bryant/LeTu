//
//  NSString+CorrectedHeightForTextView.h
//  PGCBD
//
//  Created by IOS on 13-6-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CorrectedHeightForTextView)

/*
UITextView在上下左右分别有一个8px的padding，当使用[NSString sizeWithFont:constrainedToSize:lineBreakMode:]时，需要将UITextView.contentSize.width减去16像素（左右的padding 2 x 8px）。同时返回的高度中再加上16像素（上下的padding），这样得到的才是UITextView真正适应内容的高度。
 */

+ (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText;

@end
