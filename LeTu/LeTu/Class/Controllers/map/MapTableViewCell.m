//
//  MapTableViewCell.m
//  LeTu
//
//  Created by DT on 14-6-13.
//
//

#import "MapTableViewCell.h"

@interface MapTableViewCell()
@property(nonatomic,strong)UIImageView *image;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *sexImage;
@property(nonatomic,strong)UIImageView *userTypeImage;
@property(nonatomic,strong)UILabel *distanceLabel;
@property(nonatomic,strong)UILabel *singLabel;
@property(nonatomic,strong)UILabel *lineLabel;
@end
@implementation MapTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 60, 60)];
        self.image.image = PLACEHOLDER;
        CALayer *l = [self.image layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:5.0];
        [self addSubview:self.image];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 1, 30)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont systemFontOfSize:16.0f];
        self.nameLabel.text = @"胡一菲";
        [self addSubview:self.nameLabel];
        
        self.sexImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.sexImage];
        
        self.userTypeImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.userTypeImage];
        
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 20, 80, 20)];
        self.distanceLabel.backgroundColor = [UIColor clearColor];
        self.distanceLabel.textColor = [UIColor grayColor];
        self.distanceLabel.textAlignment = UITextAlignmentRight;
        self.distanceLabel.font = [UIFont systemFontOfSize:12.0f];
        self.distanceLabel.text = @"111.11km";
        [self addSubview:self.distanceLabel];
        
        self.singLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 310, 25)];
        self.singLabel.backgroundColor = [UIColor clearColor];
        self.singLabel.textColor = [UIColor grayColor];
        self.singLabel.font = [UIFont systemFontOfSize:12.0f];
        self.singLabel.text = @"每天都有好心情...";
        [self addSubview:self.singLabel];
        
        self.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 73.5, 320, 0.5)];
        self.lineLabel.backgroundColor = RGBCOLOR(225, 225, 225);
        [self addSubview:self.lineLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(void)setModel:(MapCarSharingModel *)model
{
    [self.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,model.userPhoto]] placeholderImage:PLACEHOLDER];
    self.nameLabel.text = model.userName;
    [self.nameLabel sizeToFit];
    if ([model.userGender intValue]==1) {
        self.sexImage.image = [UIImage imageNamed:@"common_male"];
    }else if ([model.userGender intValue]==2){
        self.sexImage.image = [UIImage imageNamed:@"common_female"];
    }
    self.sexImage.frame = CGRectMake(self.nameLabel.frame.origin.x+self.nameLabel.frame.size.width+10, 12, 12, 12);
    if ([model.userType intValue]==1) {
        self.userTypeImage.image = [UIImage imageNamed:@"driver"];
    }else if ([model.userType intValue]==2){
        self.userTypeImage.image = [UIImage imageNamed:@"passage"];
    }
    self.userTypeImage.frame = CGRectMake(self.sexImage.frame.origin.x+self.sexImage.frame.size.width+5, 6, 25, 25);
    
    CGFloat distance = [model.distance floatValue];
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.2f%@",distance,@"km"];
    self.singLabel.text = model.userSign;
}
@end
