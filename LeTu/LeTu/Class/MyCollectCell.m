//
//  MyCollectCell.m
//  LeTu
//
//  Created by mafeng on 14-9-27.
//
//

#import "MyCollectCell.h"
#import "LeTuRouteModel.h"

@implementation MyCollectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //头像👦
        self.avatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 60, 60)];
        UIImage* defaultImage = [UIImage imageNamed:@"meDefaultPhoto60x60.png"];
        self.avatorImageView.image = defaultImage;
        self.avatorImageView.userInteractionEnabled = YES;
        self.avatorImageView.layer.masksToBounds = NO;
        self.avatorImageView.clipsToBounds = YES;
        self.avatorImageView.layer.cornerRadius =30.0;
        [self.contentView addSubview:self.avatorImageView];
        
        UIView* backView = [[UIView alloc]init];
        backView.frame = CGRectMake(42.0, 65.0, 40.0, 12.0);
        backView.backgroundColor =[UIColor blackColor];
        backView.alpha = 0.2;
        backView.layer.cornerRadius = 5.0;
        [self.contentView addSubview:backView];
        
        UIImage* DriveImage = [UIImage imageNamed:@"iconDriver.png"];
        self.carTypeImageView = [[UIImageView alloc]init];
        self.carTypeImageView .frame = CGRectMake(5.0,2.0,8,8);
        self.carTypeImageView.image = DriveImage;
        [backView addSubview:self.carTypeImageView];
        
        
        UIImage* GirlRedImage = [UIImage imageNamed:@"meIconGirlRed.png"];
        self.sexImageView = [[UIImageView alloc]init];
        self.sexImageView .frame = CGRectMake(CGRectGetMaxX(self.carTypeImageView.frame)+3,2.0,8,8);
        self.sexImageView.image = GirlRedImage;
        [backView addSubview:self.sexImageView];
        
        self.ageLabel = [[UILabel alloc]init];
        self.ageLabel.frame = CGRectMake(CGRectGetMaxX(self.sexImageView.frame)+2,1.0, 40.0,10.0);
        self.ageLabel.font = [UIFont systemFontOfSize:10.0];
        self.ageLabel.textColor = [UIColor whiteColor];
        self.ageLabel.text = @"23";
        [backView addSubview:self.ageLabel];
        
        
        
        //昵称
        self.nickNameLabel = [[UILabel alloc]init];
        self.nickNameLabel.frame = CGRectMake(0, CGRectGetMaxY(self.avatorImageView.frame)+12.0, 80.0,20.0);
        self.nickNameLabel.font = [UIFont systemFontOfSize:12.0];
        self.nickNameLabel.textAlignment = NSTextAlignmentCenter;
        self.nickNameLabel.textColor = RGBCOLOR(54.0, 54.0, 54.0);
        [self.contentView addSubview:self.nickNameLabel];
        
        
        UIImage* starImage = [UIImage imageNamed:@"dycListStart.png"];
        self.seView = [[UIImageView alloc]init];
        self.seView .frame = CGRectMake(CGRectGetMaxX(self.avatorImageView.frame)+14.0, 15.0,starImage.size.width, starImage.size.height);
        self.seView .image = starImage;
        [self.contentView addSubview:self.seView];
        
        
        
        //起点的位置
        self.starLabel = [[UILabel alloc]init];
        self.starLabel.frame = CGRectMake(CGRectGetMaxX(self.seView.frame) +5,16.0, 180.0,20.0);
        self.starLabel.font = [UIFont systemFontOfSize:14.0];
        self.starLabel.textColor = RGBCOLOR(54.0, 54.0,54.0);
       [self.contentView addSubview:self.starLabel];
       
        //终点的位置
        self.endLabel = [[UILabel alloc]init];
        self.endLabel.frame = CGRectMake(CGRectGetMaxX(self.seView.frame) +5,CGRectGetMaxY(self.starLabel.frame)+12.0, 180.0,20.0);
        self.endLabel.font = [UIFont systemFontOfSize:14.0];
        self.endLabel.textColor = RGBCOLOR(54.0, 54.0,54.0);
        [self.contentView addSubview:self.endLabel];
        
        
        
        //车的图片，只有车主才显示
        self.carImageView = [[UIImageView alloc]init];
        UIImage* carimagetwo = [UIImage imageNamed:@"meIconDriverBlue.png"];
        self.carImageView.frame = CGRectMake(CGRectGetMinX(self.seView.frame)+2, CGRectGetMaxY(self.seView.frame)+12.0, carimagetwo.size.width, carimagetwo.size.height);
        self.carImageView.image = carimagetwo;
        [self.contentView addSubview:self.carImageView];
        
        //车的名字 只有车主才显示
        self.carNameLabel = [[UILabel alloc]init];
        self.carNameLabel.frame = CGRectMake(CGRectGetMaxX(self.carImageView.frame)+7.0,self.carImageView.frame.origin.y-2 , 100.0,20.0);
        self.carNameLabel.font = [UIFont systemFontOfSize:12.0];
        self.carNameLabel.textColor = RGBCOLOR(160.0, 160.0,160.0);
        [self.contentView addSubview:self.carNameLabel];

        
        self.starTimeLabel = [[UILabel alloc]init];
        self.starTimeLabel.frame = CGRectMake(240.0,25.0,100.0,20.0);
        self.starTimeLabel.font = [UIFont systemFontOfSize:12.0];
        self.starTimeLabel.textColor = RGBCOLOR(160.0, 160.0,160.0);
        [self.contentView addSubview:self.starTimeLabel];
        
        self.distanceLabel = [[UILabel alloc]init];
        self.distanceLabel.frame = CGRectMake(250.0,55.0,100.0,20.0);
        self.distanceLabel.font = [UIFont systemFontOfSize:12.0];
        self.distanceLabel.textColor = RGBCOLOR(160.0, 160.0,160.0);
        [self.contentView addSubview:self.distanceLabel];
    }
    return self;
}
- (void)setCellInfomation:(LeTuRouteModel*)model
{
    

    NSString* url = [NSString stringWithFormat:@"%@%@",SERVERimageURL,model.userPhoto];
    [self.avatorImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:PLACEHOLDER];
    if (model.userType ==1) {
        
        UIImage* DriveImage = [UIImage imageNamed:@"iconDriver.png"];
        self.carTypeImageView.image = DriveImage;
        
        NSString* url = [NSString stringWithFormat:@"%@%@",SERVERimageURL,model.carPhoto];
        [self.carImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        self.carNameLabel.text = [NSString stringWithFormat:@"%@",model.carName];
        

        
    }else {
    
        
        
    
    }
    
    if (model.userGender ==1) {
        
        
        UIImage* boyRedImage = [UIImage imageNamed:@"meIconBoyBlue.png"];
        self.sexImageView.image = boyRedImage;
    }else {
        UIImage* GirlRedImage = [UIImage imageNamed:@"meIconGirlRed.png"];
        self.sexImageView.image = GirlRedImage;
        
    }
    NSString* starString = [model.routeStartPlace substringFromIndex:6];
    NSString* endString = [model.routeEndPlace substringFromIndex:6];
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@",model.userName];
    self.ageLabel.text = [NSString stringWithFormat:@"%d",model.userAge];
    self.starLabel.text = starString;
    self.endLabel.text = endString;
    NSString* date = [model.startTime substringToIndex:10];
    self.starTimeLabel.text = date;
    
    self.distanceLabel.text = [NSString stringWithFormat:@"约%0.2fkm",[model.distanceString integerValue]/1000.0];
}




@end
