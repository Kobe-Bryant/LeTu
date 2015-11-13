//
//  MyCarEditCell.m
//  LeTu
//
//  Created by DT on 14-7-7.
//
//

#import "MyCarEditCell.h"

@implementation MyCarEditCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, (self.frame.size.height-30)/2, 60, 30)];
        self.keyLabel.backgroundColor = [UIColor clearColor];
        self.keyLabel.textColor = [UIColor grayColor];
        self.keyLabel.font = [UIFont systemFontOfSize:15.0f];
        //        self.keyLabel.text = @"注册日期";
        [self addSubview:self.keyLabel];
        
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(201, 7, 34, 30)];
        self.valueLabel.backgroundColor = [UIColor clearColor];
        self.valueLabel.textColor = [UIColor blackColor];
        self.valueLabel.font = [UIFont systemFontOfSize:15.0f];
        self.valueLabel.textAlignment = UITextAlignmentCenter;
        //        self.valueLabel.text = @"我们要一起很开心的一起去旅游呀。。。";
        [self addSubview:self.valueLabel];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(80, 7, 200, 30)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor blackColor];
        self.label.textAlignment = UITextAlignmentRight;
        self.label.font = [UIFont systemFontOfSize:15.0f];
        self.label.text = @"座";
        [self addSubview:self.label];
        
        self.lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height-1, 300, 1)];
        self.lineImage.image = [UIImage imageNamed:@"posting_line"];
        self.lineImage.alpha = 0.8;
        [self addSubview:self.lineImage];
        
        self.arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(300, (self.frame.size.height-13)/2, 9, 13)];
        self.arrowImage.image = [UIImage imageNamed:@"me_headphoto_copy_icon"];
        self.arrowImage.hidden = YES;
        [self addSubview:self.arrowImage];
        
        self.minusButton = [[UIButton alloc] initWithFrame:CGRectMake(176, 9.5, 25, 25)];
        [self.minusButton setImage:[UIImage imageNamed:@"plus_normal"] forState:UIControlStateNormal];
        [self.minusButton setImage:[UIImage imageNamed:@"plus_press"] forState:UIControlStateHighlighted];
        [self.minusButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        self.minusButton.tag = 1;
        [self addSubview:self.minusButton];
        
        self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(235, 9.5, 25, 25)];
        [self.addButton setImage:[UIImage imageNamed:@"add_normal"] forState:UIControlStateNormal];
        [self.addButton setImage:[UIImage imageNamed:@"add_press"] forState:UIControlStateHighlighted];
        [self.addButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        self.addButton.tag = 2;
        [self addSubview:self.addButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(void)clickButton:(UIButton*)button
{
    if (button.tag==1) {//减
        int value = [self.valueLabel.text intValue];
        if (value!=0) {
            value -= 1;
        }
        if (self.callBack) {
            self.callBack(value);
        }
        self.valueLabel.text = [NSString stringWithFormat:@"%i",value];
    }else if (button.tag==2){//加
        int value = [self.valueLabel.text intValue]+1;
        if (self.callBack) {
            self.callBack(value);
        }
        self.valueLabel.text = [NSString stringWithFormat:@"%i",value];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
}
@end
