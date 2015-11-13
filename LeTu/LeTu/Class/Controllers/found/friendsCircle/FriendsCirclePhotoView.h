//
//  FriendsCirclePhotoView.h
//  LeTu
//
//  Created by DT on 14-5-27.
//
//

#import <UIKit/UIKit.h>

/**
 *  朋友圈照片墙
 */
@interface FriendsCirclePhotoView : UIView
{
    NSInteger _height;
    CGFloat _width;
}

@property(nonatomic,strong)NSMutableArray *imageViewArray;
@property(nonatomic,strong)NSArray *photoArray;
@property(nonatomic,assign,readonly)NSInteger height;

- (id)initWithFrame:(CGRect)frame width:(CGFloat)width;

@end
