//
//  MapLocationBottomView.h
//  LeTu
//
//  Created by DT on 14-7-2.
//
//

#import <UIKit/UIKit.h>

@interface MapLocationBottomView : UIView

//1:起点 2:终点
@property(nonatomic,assign)int status;

@property(nonatomic,strong)UIImageView *bgImageView;

@property(nonatomic,strong)UIImageView *startImageView;
@property(nonatomic,strong)UILabel *startAddress;
@property(nonatomic,strong)UIButton *startButton;
@property(nonatomic,assign)float starLatitude;
@property(nonatomic,assign)float starLongitude;

@property(nonatomic,strong)UIImageView *endImageView;
@property(nonatomic,strong)UILabel *endAddress;
@property(nonatomic,strong)UIButton *endButton;
@property(nonatomic,assign)float endLatitude;
@property(nonatomic,assign)float endLongitude;

@property(nonatomic,strong)UIButton *ensureButton;

/**
 *  回调函数
 *  type 类型 1:起点搜索 2:终点搜索 888:设置起点
 */
@property(strong , nonatomic) void (^callBack) (int type);

@end
