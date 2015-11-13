//
//  MyselfBlacklistCell.m
//  LeTu
//
//  Created by DT on 14-6-9.
//
//

#import "MyselfBlacklistCell.h"
#import "EGOImageView.h"

@interface MyselfBlacklistCell()
{
    CGPoint gestureStartPoint;
}
@property(nonatomic,strong)UIImageView *faceImage;
@property(nonatomic,strong)UILabel *userNameLabel;
@property(nonatomic,strong)UILabel *userIdLabel;
@property(nonatomic,strong)UILabel *lineLabel;
@end
@implementation MyselfBlacklistCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.faceImage = [[UIImageView alloc] initWithFrame:CGRectMake(11, 7, 60, 60)];
        self.faceImage.backgroundColor = [UIColor clearColor];
        self.faceImage.clipsToBounds = YES;
        self.faceImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.faceImage];
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 15, 150, 25)];
        self.userNameLabel.backgroundColor = [UIColor clearColor];
        self.userNameLabel.font = [UIFont systemFontOfSize:18.0f];
        self.userNameLabel.text = @"管理员";
        [self addSubview:self.userNameLabel];
        
        self.userIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 45, 150, 20)];
        self.userIdLabel.backgroundColor = [UIColor clearColor];
        self.userIdLabel.font = [UIFont systemFontOfSize:13.0f];
        self.userIdLabel.textColor = [UIColor grayColor];
        self.userIdLabel.text = @"乐途号: 1224566";
        [self addSubview:self.userIdLabel];
        
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 81, 74)];
        [self.deleteButton setImage:[UIImage imageNamed:@"my_heimingdan_btn_jiechu_normal"] forState:UIControlStateNormal];
        [self.deleteButton setImage:[UIImage imageNamed:@"my_heimingdan_btn_jiechu_press"] forState:UIControlStateHighlighted];
        [self.deleteButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteButton];
        
        self.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 73, 320, 0.5)];
        self.lineLabel.backgroundColor = RGBCOLOR(231, 231, 231);
        [self addSubview:self.lineLabel];
        
        UISwipeGestureRecognizer *swipeGes = nil;
        swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCell:)];
        swipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeGes];
        
        swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCell:)];
        swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeGes];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(void)setModel:(UserModel *)model
{
//    self.faceImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, model.userPhoto]];
    [self.faceImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, model.userPhoto]] placeholderImage:PLACEHOLDER];
    self.userNameLabel.text = model.userName;
    self.userIdLabel.text = [NSString stringWithFormat:@"乐途号: %@",model.loginName];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.deleteButton.frame = CGRectMake(320, 0, 81, 74);
}
- (void)swipeCell:(UISwipeGestureRecognizer *)ges
{
    if (ges.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.deleteButton.center.x > 320) {
            [UIView animateWithDuration:0.2 animations:^{
                self.deleteButton.center = CGPointMake(self.deleteButton.center.x-81, self.deleteButton.center.y);
            } completion:^(BOOL finished) {
                
            }];
        }
    }else if (ges.direction == UISwipeGestureRecognizerDirectionRight){
        if (self.deleteButton.center.x < 320) {
            [UIView animateWithDuration:0.2 animations:^{
                self.deleteButton.center = CGPointMake(self.deleteButton.center.x+81, self.deleteButton.center.y);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}
-(void)clickButton:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(blacklistCell:tag:)]) {
        [self.delegate blacklistCell:self tag:self.tag];
    }
}
@end
