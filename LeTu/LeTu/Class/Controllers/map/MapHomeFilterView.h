//
//  MapHomeFilterView.h
//  LeTu
//
//  Created by DT on 14-5-21.
//
//

#import <UIKit/UIKit.h>

typedef void (^CallBack) (int oneRow,int twoRow,int threeRow,int fourRow); //Block
/**
 *  地图筛选View
 */
@interface MapHomeFilterView : UIView
{
    CallBack callBack;
}
//@property(nonatomic,strong) void (^callBack) (int oneRow,int twoRow,int threeRow,int FourRow); //Block

-(id)initWithFrame:(CGRect)frame block:(CallBack)block;

@end
