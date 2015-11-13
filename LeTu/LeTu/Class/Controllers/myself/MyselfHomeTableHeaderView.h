//
//  MyselfHomeTableHeaderView.h
//  LeTu
//
//  Created by DT on 14-5-18.
//
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@class MyselfHomeTableHeaderView;

@protocol MyselfHomeTableHeaderViewDelegate <NSObject>
//点击屏幕事件
- (void)tableHeaderView:(MyselfHomeTableHeaderView*)tableHeaderView didClickToView:(NSInteger)tag;
@end

@interface MyselfHomeTableHeaderView : UIView

@property (nonatomic, retain) id<MyselfHomeTableHeaderViewDelegate> delegate;

@property(nonatomic,strong)UserModel *userModel;
@end
