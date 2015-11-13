//
//  DTGridTableViewCell.m
//  gridView
//
//  Created by DT on 14-5-24.
//  Copyright (c) 2014年 DT. All rights reserved.
//

#import "DTGridTableViewCell.h"
#import "DTGridTableViewConstants.h"

@interface DTGridTableViewCell()
{
    int _number;
    int _height;
}
@end

@implementation DTGridTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
           delegate:(id<DTGridTableViewCellDelegate>)delegate
          rowNumber:(int)number rowHeight:(float)height indexPath:(NSIndexPath *)indexPath
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _number = number;
        _height = height;
        self.indexPath = indexPath;
        self.delegate  = delegate;
        self.gridViews = [[NSMutableArray alloc]init];
        
        // 布局gridview
        [self addGridViews];
        
    }
    return self;
}

- (void)addGridViews{
    
    float width     = self.bounds.size.width  - 2*kPaddingX;
    float height    = _height - kSpaceY;
    float fitWidth  = (width - kSpaceX*(_number-1))/_number;
    float fitHeight = height;
    
    @autoreleasepool {
        
        for(int i=0;i<_number;i++){
            UIView *grid =(UIView *)[self viewWithTag:i+kGridBtnTag];
            if(grid == nil){
                // 计算坐标
//                CGRect frame = CGRectMake(kPaddingX+(i%(int)_number)*(fitWidth+kSpaceX),kSpaceY, fitWidth, fitHeight);
                CGRect frame = CGRectMake(kPaddingX+(i%(int)_number)*(fitWidth+kSpaceX),kSpaceY, fitWidth, fitHeight);
                if ([self.delegate respondsToSelector:@selector(viewAtIndex:size:)]) {
                    grid = [self.delegate viewAtIndex:self.indexPath.row*_number+i size:CGSizeMake(fitWidth, fitHeight)];
                    grid.frame = frame;
                }else{
                    grid =[[UIView alloc]initWithFrame:frame];
                }
                [grid setTag:i+kGridBtnTag];
                
                [self addSubview:grid];
                [_gridViews addObject:grid];
            }
        }
    }
}
@end
