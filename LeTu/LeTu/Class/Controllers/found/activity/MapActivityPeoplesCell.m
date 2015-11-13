//
//  MapActivityPeoplesCell.m
//  LeTu
//
//  Created by DT on 14-7-1.
//
//

#import "MapActivityPeoplesCell.h"

@interface MapActivityPeoplesCell()
@property(nonatomic,strong)UIImageView *faceImage;
@property(nonatomic,strong)UIImageView *sexImage;
@property(nonatomic,strong)UILabel *userNameLabel;
@property(nonatomic,strong)UILabel *userIdLabel;
@end

@implementation MapActivityPeoplesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.faceImage = [[UIImageView alloc] initWithFrame:CGRectMake(11, 7, 60, 60)];
        self.faceImage.backgroundColor = [UIColor clearColor];
        self.faceImage.image = PLACEHOLDER;
        self.faceImage.clipsToBounds = YES;
        self.faceImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.faceImage];
        
        self.sexImage = [[UIImageView alloc] initWithFrame:CGRectMake(150, 20, 15, 15)];
        self.sexImage.image = [UIImage imageNamed:@"common_male"];
        [self addSubview:self.sexImage];
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 15, 0, 25)];
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
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 74.5, 320, 0.5)];
        label.backgroundColor = RGBCOLOR(231, 231, 231);
        [self addSubview:label];
    }
    return self;
}
-(void)setModel:(MapActivityApplysModel *)model
{
    self.userNameLabel.text = model.userName;
    self.userIdLabel.text = model.userSign;
    
    [self.userNameLabel sizeToFit];
    [self.faceImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,model.userPhoto]] placeholderImage:PLACEHOLDER];
    if ([model.userGender intValue]==1) {
        self.sexImage.image = [UIImage imageNamed:@"common_male"];
    }else if ([model.userGender intValue]==2) {
        self.sexImage.image = [UIImage imageNamed:@"common_female"];
    }
    self.sexImage.frame = CGRectMake(self.userNameLabel.frame.origin.x+self.userNameLabel.frame.size.width+5, 20, 15, 15);
}
@end
