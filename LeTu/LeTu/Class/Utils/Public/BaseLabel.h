//
//  BaseLabel.h
//  CBD
//
//  Created by screate on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseLabel;
@protocol BaseLabelDelegate <NSObject>
@required
- (void)baseLabel:(BaseLabel *)baseLabel touchesWtihTag:(NSInteger)tag;
@end

@interface BaseLabel : UILabel
{
     id <BaseLabelDelegate> __unsafe_unretained delegate;
}
@property (nonatomic, assign) id <BaseLabelDelegate> delegate;
- (id)initWithFrame:(CGRect)frame;

@end
