//
//  FriendsCircleMECell.h
//  LeTu
//
//  Created by DT on 14-5-8.
//
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"
#import "MiniBlogModel.h"

@interface FriendsCircleMECell : UITableViewCell

@property(nonatomic,assign)BOOL isFinal;
//@property(nonatomic,retain) ClassModel *classModel;

@property(nonatomic,strong)MiniBlogModel *model;

@end
