//
//  MapCarpoolApplicationCell.m
//  LeTu
//
//  Created by DT on 14-7-3.
//
//

#import "MapCarpoolApplicationCell.h"

@interface MapCarpoolApplicationCell()

@property(nonatomic,strong)UIImageView *faceImage;
@property(nonatomic,strong)UIImageView *carImage;
@property(nonatomic,strong)UIView *bottomView;

@property(nonatomic,strong)UIImageView *userTypeImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *distanceLabel;

@property(nonatomic,strong)UIButton *acceptedButton;
@property(nonatomic,strong)UIButton *refusalButton;
@end

@implementation MapCarpoolApplicationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.faceImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 100)];
//        self.faceImage.image = [UIImage imageNamed:@"location_pic"];
        self.faceImage.clipsToBounds = YES;
        self.faceImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.faceImage];
        
        self.carImage = [[UIImageView alloc] initWithFrame:CGRectMake(160, 0, 160, 100)];
//        self.carImage.image = [UIImage imageNamed:@"location_picBubble"];
        self.carImage.clipsToBounds = YES;
        self.carImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.carImage];
        
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 50)];
        self.bottomView.backgroundColor = RGBACOLOR(30, 30, 30, 0.8);
        [self addSubview:self.bottomView];
        
        self.userTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 30, 30)];
        self.userTypeImage.backgroundColor = [UIColor clearColor];
        self.userTypeImage.image = [UIImage imageNamed:@"location_driver"];
        self.userTypeImage.hidden = YES;
        [self.bottomView addSubview:self.userTypeImage];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 125, 40)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.font = [UIFont systemFontOfSize:18.0f];
//        self.nameLabel.text = @"元芳的风";
        [self.bottomView addSubview:self.nameLabel];
        
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 125, 15)];
        self.distanceLabel.backgroundColor = [UIColor clearColor];
        self.distanceLabel.textColor = [UIColor whiteColor];
        self.distanceLabel.font = [UIFont systemFontOfSize:13.0f];
        self.distanceLabel.text = @"距离:10.2km";
        self.distanceLabel.hidden = YES;
        [self.bottomView addSubview:self.distanceLabel];
        
        self.acceptedButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 5, 40, 40)];
        [self.acceptedButton setImage:[UIImage imageNamed:@"accept_normal"] forState:UIControlStateNormal];
        [self.acceptedButton setImage:[UIImage imageNamed:@"accept_press"] forState:UIControlStateHighlighted];
        self.acceptedButton.tag = 1;
        [self.acceptedButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.acceptedButton];
        
        self.refusalButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 5, 40, 40)];
        [self.refusalButton setImage:[UIImage imageNamed:@"refuse_normal"] forState:UIControlStateNormal];
        [self.refusalButton setImage:[UIImage imageNamed:@"refuse_press"] forState:UIControlStateHighlighted];
        self.refusalButton.tag = 2;
        [self.refusalButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.refusalButton];
    }
    return self;
}
-(void)clickButton:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(carpoolApplicationCell:clickButtonAtIndex:)]) {
        [self.delegate carpoolApplicationCell:self clickButtonAtIndex:button.tag];
    }
}
-(void)setModel:(MapApplyCarpoolModel *)model
{
    [self.faceImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,model.userPhoto]] placeholderImage:PLACEHOLDER];
    [self.carImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,model.carPhoto]] placeholderImage:PLACEHOLDER];
    self.nameLabel.text = model.userName;
}
@end
