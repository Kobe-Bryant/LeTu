//
//  MyselfDetailCell.h
//  LeTu
//
//  Created by DT on 14-5-20.
//
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface MyselfDetailCell : UITableViewCell

//@property(nonatomic,retain)EGOImageButton *headImgView ;
@property(nonatomic,retain)UIImageView *headImgView ;
@property(nonatomic,strong)UILabel *keyLabel;
@property(nonatomic,strong)UILabel *valueLabel;
@property(nonatomic,strong)UIImageView *lineImage;

@property(nonatomic,copy)NSString *key;
@property(nonatomic,copy)NSString *value;
@property(nonatomic,copy)NSString *faceUrl;
@property(nonatomic,assign)BOOL arrowHide;




@end
