//
//  ScrollView.h
//  CyberwayIOS
//
//  Created by screate on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollDelegate <NSObject>
-(void) scrollTouchBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view;
-(void) scrollTouchEnd:(UIView *)view;
-(void) scrollTouchEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end
@interface ScrollView : UIScrollView<UIScrollViewDelegate> {
	id<ScrollDelegate> __unsafe_unretained scrollDelegate;
}
@property (assign) id<ScrollDelegate> scrollDelegate;
@end
