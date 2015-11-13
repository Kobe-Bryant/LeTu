//
//  DetailCommentCell.h
//  LeTu
//
//  Created by DT on 14-5-15.
//
//

#import <UIKit/UIKit.h>
#import "BlogCommentModel.h"
#import "MapActivityMessageModel.h"
@class DetailCommentCell;

@protocol DetailCommentCellDelegate <NSObject>

/**
 *  头像点击事件
 *
 *  @param commentCell 当前cell
 *  @param userId      用户id
 */
- (void)commentCell:(DetailCommentCell*)commentCell clickFaceImage:(NSString*)userId;

@end
/**
 *  朋友圈详情评论
 */
@interface DetailCommentCell : UITableViewCell
@property(nonatomic,assign)id<DetailCommentCellDelegate> delegate;

//朋友圈评论Model
@property(nonatomic,strong)BlogCommentModel *model;

//活动评论Model
@property(nonatomic,strong)MapActivityMessageModel *messageModel;

@end
