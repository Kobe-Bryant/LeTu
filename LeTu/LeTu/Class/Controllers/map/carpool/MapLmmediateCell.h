//
//  MapLmmediateCell.h
//  LeTu
//
//  Created by DT on 14-6-11.
//
//

#import <UIKit/UIKit.h>

@interface MapLmmediateCell : UITableViewCell

@property(nonatomic,strong)UILabel *keyLabel;
@property(nonatomic,strong)UILabel *valueLabel;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,assign)BOOL showTextField;
@property(nonatomic,strong)UIImageView *arrowImage;
@end
