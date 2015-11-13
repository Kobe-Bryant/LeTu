//
//  MapCarShareDetailViewController.h
//  LeTu
//
//  Created by DT on 14-5-16.
//
//

#import "BaseViewController.h"
#import "MapCarSharingModel.h"

/**
 *  拼车详情页
 */
@interface MapCarShareDetailViewController : BaseViewController

- (id)initWithModel:(MapCarSharingModel*)model;

/**
 *  状态 1:表示拼车详情 2:我收藏的
 */
@property(nonatomic,assign)int status;
@end
