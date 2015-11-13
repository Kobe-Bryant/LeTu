//
//  MapLmmediateCell.m
//  LeTu
//
//  Created by DT on 14-6-11.
//
//

#import "MapLmmediateCell.h"

@implementation MapLmmediateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.frame.size.height-30)/2, 60, 30)];
        self.keyLabel.backgroundColor = [UIColor clearColor];
        self.keyLabel.textColor = RGBCOLOR(50, 161, 245);
        self.keyLabel.font = [UIFont systemFontOfSize:14.0f];
        //        self.keyLabel.text = @"注册日期";
        [self addSubview:self.keyLabel];
        
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 7, 200, 30)];
        self.valueLabel.backgroundColor = [UIColor clearColor];
        self.valueLabel.textColor = [UIColor blackColor];
        self.valueLabel.font = [UIFont systemFontOfSize:14.0f];
        //        self.valueLabel.text = @"我们要一起很开心的一起去旅游呀。。。";
        [self addSubview:self.valueLabel];
        
        self.arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(300, (self.frame.size.height-13)/2, 9, 13)];
        self.arrowImage.image = [UIImage imageNamed:@"me_headphoto_copy_icon"];
        [self addSubview:self.arrowImage];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(void)setShowTextField:(BOOL)showTextField
{
    if (showTextField) {
        if (!self.textField) {
            
            self.textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 7, 240, 30)];
            self.textField.backgroundColor = [UIColor clearColor];
            self.textField.clearButtonMode = UITextFieldViewModeNever;
            self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.textField.font = [UIFont systemFontOfSize:14.0f];
            self.textField.placeholder = @"请输入金额";
            self.textField.text = @"";
            [self addSubview:self.textField];
        }
        self.textField.hidden = NO;
    }else {
        self.textField.hidden = YES;
    }
}
@end
