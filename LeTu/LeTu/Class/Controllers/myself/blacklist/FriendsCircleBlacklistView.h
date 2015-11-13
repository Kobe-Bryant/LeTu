//
//  FriendsCircleBlacklistView.h
//  LeTu
//
//  Created by DT on 14-6-16.
//
//

#import <UIKit/UIKit.h>

@class FriendsCircleBlacklistView;
@protocol FriendsCircleBlacklistViewDelegate <NSObject>
//点击删除按钮事件
- (void)blacklistViewClickDelete:(FriendsCircleBlacklistView*)blacklistView;
@end

@interface FriendsCircleBlacklistView : UIView
@property(nonatomic,weak)id<FriendsCircleBlacklistViewDelegate> delegate;

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIButton *deleteButton;
@property(nonatomic,strong)UILabel *nameLabel;

@end
