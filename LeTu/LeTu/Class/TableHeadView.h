//
//  TableHeadView.h
//  LeTu
//
//  Created by mafeng on 14-9-18.
//
//

#import <UIKit/UIKit.h>
@class UserDetailModel;

@protocol clickButtonDelegate <NSObject>

- (void)clickAvatorButton:(NSInteger)tag;

@end

@interface TableHeadView : UIView

@property(nonatomic,strong) UIButton* leftBackButton;
@property(nonatomic,strong) UIButton* rightEditButton;
@property(nonatomic,strong) UserDetailModel* model;

@property(nonatomic,assign) id<clickButtonDelegate>headDelegate;


@property(nonatomic,strong) UIButton* avatorButton;
@property(nonatomic,strong) UILabel* nickNameLabel;
@property(nonatomic,strong) UIImageView* genderImageView;
@property(nonatomic,strong) UILabel* ageLabel;
@property(nonatomic,strong) UILabel* typeLabel;

- (void)setBackGroundImage:(UIImage*)backImage;
- (void)setInfomation:(UserDetailModel*)model;


@end
