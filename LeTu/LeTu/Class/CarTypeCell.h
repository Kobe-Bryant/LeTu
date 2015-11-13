//
//  CarTypeCell.h
//  LeTu
//
//  Created by mafeng on 14-9-25.
//
//

#import <UIKit/UIKit.h>
@class CarButton;
@class BrandCar;


@protocol clickCarDelegate <NSObject>

- (void)clickCar:(BrandCar*)car;


@end

@interface CarTypeCell : UITableViewCell
@property(nonatomic,assign) id<clickCarDelegate> carDelegate;
@property(nonatomic,strong) UILabel* englishLabel;
@property(nonatomic,strong) UIImageView* lineheadImageView;
@property(nonatomic,strong) UIImageView* linebottomImageView;

@property(nonatomic,strong) UIButton* carImageButton;
@property(nonatomic,strong) CarButton* carButton;


//设置每一行的cell高度
+ (CGFloat)getCellHeight:(NSArray*)array;

- (void)setCellInfomation:(NSArray*)array title:(NSString*)title;



@end
