//
//  CarInfomationCell.h
//  LeTu
//
//  Created by mafeng on 14-9-26.
//
//

#import <UIKit/UIKit.h>

@interface CarInfomationCell : UITableViewCell
@property(nonatomic,strong) UILabel* titlelabel;
@property(nonatomic,strong) UIImageView* carImageView;
@property(nonatomic,strong) UILabel* carNameLabel;
@property(nonatomic,strong) UIImageView* arrowImageView;

- (void)setcellInfomation:(NSString*)carnameWidth carlogo:(NSString*)carlogo;



@end
