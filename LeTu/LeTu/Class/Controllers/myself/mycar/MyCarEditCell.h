//
//  MyCarEditCell.h
//  LeTu
//
//  Created by DT on 14-7-7.
//
//

#import <UIKit/UIKit.h>

@interface MyCarEditCell : UITableViewCell

@property(nonatomic,strong)UIButton *minusButton;
@property(nonatomic,strong)UIButton *addButton;

@property(nonatomic,strong)UIImageView *lineImage;
@property(nonatomic,strong)UIImageView *arrowImage;

@property(nonatomic,strong)UILabel *keyLabel;
@property(nonatomic,strong)UILabel *valueLabel;
@property(nonatomic,strong)UILabel *label;

/**
 *  回调函数
 *  value 数据
 */
@property(strong , nonatomic) void (^callBack) (int value);
@end
