//
//  CircleImageView.h
//  WYGJ
//
//  Created by cyberwayios on 13-12-23.
//
//

#import "EGOImageView.h"

typedef void (^CallBack) (); //Block

@interface CircleImageView : EGOImageView
{
    NSURL *headImageURL;
    CallBack callBack;
}
- (id)initWithFrame:(CGRect)frame  block:(CallBack)block;

@end
