//
//  DTGridTableViewCell.h
//  gridView
//
//  Created by DT on 14-5-24.
//  Copyright (c) 2014年 DT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTGridTableViewCell;

@protocol DTGridTableViewCellDelegate <NSObject>

- (UIView*)viewAtIndex:(NSInteger)index size:(CGSize)size;

@end

@interface DTGridTableViewCell : UITableViewCell

@property (nonatomic,assign)id <DTGridTableViewCellDelegate> delegate;

@property (nonatomic,strong)NSIndexPath     *indexPath;
@property (nonatomic,strong)NSMutableArray  *gridViews;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
           delegate:(id <DTGridTableViewCellDelegate>)delegate
          rowNumber:(int)number rowHeight:(float)height indexPath:(NSIndexPath *)indexPath;
@end
