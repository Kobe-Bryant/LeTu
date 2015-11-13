//
//  modifyPersonCell.h
//  LeTu
//
//  Created by mafeng on 14-9-18.
//
//

#import <UIKit/UIKit.h>
#import "UserModel.h"


@interface modifyPersonCell : UITableViewCell

@property(nonatomic,strong) UIImageView* avatorImageView;
@property(nonatomic,strong) UILabel* detailLabel;
@property(nonatomic,strong) UIImageView* arrorImageView;

- (void)setcellInfomation:(UserModel*)model;





@end
