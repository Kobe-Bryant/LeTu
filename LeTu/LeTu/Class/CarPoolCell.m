//
//  CarPoolCell.m
//  LeTu
//
//  Created by mafeng on 14-9-19.
//
//



#import "CarPoolCell.h"
#import "LeTuRouteModel.h"


@implementation CarPoolCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
  
     
        //头像👦
        self.avatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 12, 50, 50)];
        self.avatorImageView.userInteractionEnabled = YES;
        self.avatorImageView.layer.masksToBounds = NO;
        self.avatorImageView.clipsToBounds = YES;
        self.avatorImageView.layer.cornerRadius =25.0;
        [self.contentView addSubview:self.avatorImageView];
        
        //车的标志或者乘客的标志
        self.cartypeImageView = [[UIImageView alloc]init];
        UIImage* carimage = [UIImage imageNamed:@"meIconDriverBlue.png"];
        self.cartypeImageView.frame = CGRectMake(CGRectGetMaxX(self.avatorImageView.frame) -carimage.size.width, CGRectGetMaxY(self.avatorImageView.frame)-carimage.size.height, carimage.size.width, carimage.size.height);
        [self.contentView addSubview:self.cartypeImageView];
        
        //昵称
        self.nicknameLabel = [[UILabel alloc]init];
        self.nicknameLabel.frame = CGRectMake(CGRectGetMinX(self.avatorImageView.frame)+10, CGRectGetMaxY(self.avatorImageView.frame)+5.0, 100.0,20.0);
        self.nicknameLabel.font = [UIFont systemFontOfSize:11.0];
        self.nicknameLabel.textColor = RGBCOLOR(54.0, 54.0, 54.0);
        [self.contentView addSubview:self.nicknameLabel];
        
        
        
        
        //车的图片，只有车主才显示
        self.carImageView = [[UIImageView alloc]init];
        UIImage* carimagetwo = [UIImage imageNamed:@"meIconDriverBlue.png"];
        self.carImageView.frame = CGRectMake(20.0, CGRectGetMaxY(self.nicknameLabel.frame)+7.0, carimagetwo.size.width, carimagetwo.size.height);
        self.carImageView.image = carimagetwo;
       [self.contentView addSubview:self.carImageView];
        
        //车的名字 只有车主才显示
        self.carNameLabel = [[UILabel alloc]init];
        self.carNameLabel.frame = CGRectMake(CGRectGetMaxX(self.carImageView.frame)+7.0,CGRectGetMaxY(self.nicknameLabel.frame)+5.0 , 100.0,20.0);
        self.carNameLabel.font = [UIFont systemFontOfSize:10.0];
        self.carNameLabel.textColor = RGBCOLOR(160.0, 160.0,160.0);
       [self.contentView addSubview:self.carNameLabel];
        
        //车牌号 只有车主才显示
        self.carNumberLabel = [[UILabel alloc]init];
        self.carNumberLabel.frame = CGRectMake(20.0, CGRectGetMaxY(self.carNameLabel.frame)-3.0, 180.0,20.0);
        self.carNumberLabel.font = [UIFont systemFontOfSize:10.0];
        self.carNumberLabel.textColor = RGBCOLOR(160.0, 160.0,160.0);
        [self.contentView addSubview:self.carNumberLabel];
        
        //关注图片
        self.careImageview = [[UIImageView alloc]init];
        UIImage* carimagethree = [UIImage imageNamed:@"meIconAttention.png"];
        self.careImageview.frame = CGRectMake(CGRectGetMaxX(self.avatorImageView.frame)+26.0, 15.0,carimagethree.size.width, carimagethree.size.height);
        self.careImageview.image = carimagethree;
        [self.contentView addSubview:self.careImageview];
        
       //关注
        self.careLabel = [[UILabel alloc]init];
        self.careLabel.frame = CGRectMake(CGRectGetMaxX(self.careImageview.frame)+5.0, 10.0, 40.0,20.0);
        self.careLabel.font = [UIFont systemFontOfSize:12.0];
        self.careLabel.textColor = RGBCOLOR(54.0, 54.0,54.0);
        self.careLabel.text =@"关注";
        [self.contentView addSubview:self.careLabel];
        
        //关注个数 careCountLabel
        self.careCountLabel = [[UILabel alloc]init];
        self.careCountLabel.frame = CGRectMake(CGRectGetMaxX(self.careImageview.frame)+31.0, 10.0, 40.0,20.0);
        self.careCountLabel.font = [UIFont systemFontOfSize:15.0];
        self.careCountLabel.textColor = RGBCOLOR(54.0, 54.0,54.0);
        [self.contentView addSubview:self.careCountLabel];
        
        
        //线条
        self.lineLabelOne = [[UILabel alloc]init];
        self.lineLabelOne.frame = CGRectMake(CGRectGetMaxX(self.careCountLabel.frame)-25.0, 10.0, 1.0,20.0);
        self.lineLabelOne.backgroundColor = RGBCOLOR(160.0, 160.0,160.0);
        [self.contentView addSubview:self.lineLabelOne];
        
        
        //报名乘客的图片
        self.personImageview = [[UIImageView alloc]init];
        UIImage* carimagefour = [UIImage imageNamed:@"meIconRegistration.png"];
        self.personImageview.frame = CGRectMake(CGRectGetMaxX(self.lineLabelOne.frame)+10.0, 15.0,carimagefour.size.width, carimagefour.size.height);
        self.personImageview.image = carimagefour;
        [self.contentView addSubview:self.personImageview];
        
        //报名
        self.enrollLabel = [[UILabel alloc]init];
        self.enrollLabel.frame = CGRectMake(CGRectGetMaxX(self.personImageview.frame)+5.0, 11.0, 50.0,20.0);
        self.enrollLabel.font = [UIFont systemFontOfSize:12.0];
        self.enrollLabel.textColor = RGBCOLOR(54.0, 54.0,54.0);
       [self.contentView addSubview:self.enrollLabel];
        
        //报名个数
        self.enrollCountLabel = [[UILabel alloc]init];
        self.enrollCountLabel.frame = CGRectMake(CGRectGetMaxX(self.personImageview.frame)+55.0, 10.0, 40.0,20.0);
        self.enrollCountLabel.font = [UIFont systemFontOfSize:15.0];
        self.enrollCountLabel.textColor = RGBCOLOR(54.0, 54.0,54.0);
        [self.contentView addSubview:self.enrollCountLabel];
        
        
        //线条
        self.lineLabelTwo = [[UILabel alloc]init];
        self.lineLabelTwo.frame = CGRectMake(CGRectGetMaxX(self.enrollCountLabel.frame)-25.0, 10.0, 1.0,20.0);
        self.lineLabelTwo.backgroundColor = RGBCOLOR(160.0, 160.0,160.0);
        [self.contentView addSubview:self.lineLabelTwo];

        //余座的图片
        self.downImageView = [[UIImageView alloc]init];
        UIImage* carimagefive = [UIImage imageNamed:@"meIconSeat.png"];
        self.downImageView.frame = CGRectMake(CGRectGetMaxX(self.lineLabelTwo.frame)+8.0, 15.0,carimagefive.size.width, carimagefive.size.height);
        self.downImageView.image = carimagefive;
       [self.contentView addSubview:self.downImageView];

        //余座
        self.downCountLabel = [[UILabel alloc]init];
        self.downCountLabel.frame = CGRectMake(CGRectGetMaxX(self.downImageView.frame)+5.0, 11.0, 40.0,20.0);
        self.downCountLabel.font = [UIFont systemFontOfSize:12.0];
        self.downCountLabel.textColor = RGBCOLOR(54.0, 54.0,54.0);
        [self.contentView addSubview:self.downCountLabel];
        
        
       //余座的个数 downnumberLabel
        self.downnumberLabel = [[UILabel alloc]init];
        self.downnumberLabel.frame = CGRectMake(CGRectGetMaxX(self.downCountLabel.frame)-13, 10.0, 40.0,20.0);
        self.downnumberLabel.font = [UIFont systemFontOfSize:15.0];
        self.downnumberLabel.textColor = RGBCOLOR(54.0, 54.0,54.0);
        [self.contentView addSubview:self.downnumberLabel];
        
        //起点
        self.startStationLabel = [[UILabel alloc]init];
        self.startStationLabel.frame = CGRectMake(CGRectGetMinX(self.careImageview.frame),CGRectGetMaxY(self.careImageview.frame)+15.0, 40.0,20.0);
        self.startStationLabel.font = [UIFont systemFontOfSize:15.0];
        self.startStationLabel.textColor = RGBCOLOR(160.0, 160.0,160.0);
        self.startStationLabel.text = @"起点:";
        [self.contentView addSubview:self.startStationLabel];
        
        //起点的位置
        self.startplaceLabel = [[UILabel alloc]init];
        self.startplaceLabel.frame = CGRectMake(CGRectGetMaxX(self.startStationLabel.frame),CGRectGetMaxY(self.careImageview.frame)+14.0, 90.0,20.0);
        self.startplaceLabel.font = [UIFont systemFontOfSize:14.0];
        self.startplaceLabel.textColor = RGBCOLOR(54.0, 54.0,54.0);
        [self.contentView addSubview:self.startplaceLabel];
        
        //起点的区
        self.locationstarLabel = [[UILabel alloc]init];
        self.locationstarLabel.font = [UIFont systemFontOfSize:10.0];
        self.locationstarLabel.textColor = RGBCOLOR(160.0, 160.0,160.0);
       [self.contentView addSubview:self.locationstarLabel];
        
        //终点
        self.overStationLabel = [[UILabel alloc]init];
        self.overStationLabel.frame = CGRectMake(CGRectGetMinX(self.careImageview.frame),CGRectGetMaxY(self.startStationLabel.frame)+12.0, 40.0,20.0);
        self.overStationLabel.font = [UIFont systemFontOfSize:15.0];
        self.overStationLabel.textColor = RGBCOLOR(160.0, 160.0,160.0);
        self.overStationLabel.text = @"终点:";
        [self.contentView addSubview:self.overStationLabel];

        //终点的位置
        self.overplaceLabel = [[UILabel alloc]init];
        self.overplaceLabel.frame = CGRectMake(CGRectGetMaxX(self.startStationLabel.frame),CGRectGetMaxY(self.startplaceLabel.frame)+12.0, 90.0,20.0);
        self.overplaceLabel.font = [UIFont systemFontOfSize:14.0];
        self.overplaceLabel.textColor = RGBCOLOR(54.0, 54.0,54.0);
       [self.contentView addSubview:self.overplaceLabel];
        
        //终点的区
        self.locationoverLabel = [[UILabel alloc]init];
        self.locationoverLabel.frame = CGRectMake(CGRectGetMinX(self.locationstarLabel.frame),CGRectGetMaxY(self.locationstarLabel.frame)+12.0, 40.0,20.0);
        self.locationoverLabel.font = [UIFont systemFontOfSize:10.0];
        self.locationoverLabel.textColor = RGBCOLOR(160.0, 160.0,160.0);
       [self.contentView addSubview:self.locationoverLabel];
        
        
        //时间
        self.time = [[UILabel alloc]init];
        self.time.frame = CGRectMake(CGRectGetMinX(self.careImageview.frame),CGRectGetMaxY(self.overStationLabel.frame)+10.0, 40.0,20.0);
        self.time.font = [UIFont systemFontOfSize:15.0];
        self.time.textColor = RGBCOLOR(160.0, 160.0,160.0);
        self.time.text = @"时间:";
       [self.contentView addSubview:self.time];
        
        //日期和时间
        self.time = [[UILabel alloc]init];
        self.time.frame = CGRectMake(CGRectGetMinX(self.overplaceLabel.frame),CGRectGetMaxY(self.overStationLabel.frame)+10.0, 200.0,20.0);
        self.time.font = [UIFont systemFontOfSize:14.0];
        self.time.textColor = RGBCOLOR(54.0, 54.0,54.0);
        [self.contentView addSubview:self.time];
 
    }
    return self;
}

+ (CGFloat)getCellHeight//设置cell的行高
{

    return 145.0;
    
}
- (void)setCellInformation:(LeTuRouteModel*)model
{
    
  
    UIImage* defaultImage = [UIImage imageNamed:@"meDefaultPhoto60x60.png"];
    NSString* url = [NSString stringWithFormat:@"%@%@",SERVERimageURL,model.userPhoto];
    [self.avatorImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:defaultImage];
    
    if (model.userType ==1) {
        
     UIImage* carimage = [UIImage imageNamed:@"meIconDriverBlue.png"];
     self.cartypeImageView.image =carimage;
     UIImage* carimagetwo = [UIImage imageNamed:@"meIconDriverBlue.png"];
    NSString* url = [NSString stringWithFormat:@"%@%@",SERVERimageURL,model.carPhoto];
     [self.carImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:carimagetwo];
      self.carNameLabel.text = model.carName;
      self.carNumberLabel.text = [NSString stringWithFormat:@"%@  %d",model.carLocation,model.carNumber];
        self.enrollLabel.text = @"报名乘客";
        self.downCountLabel.text = @"余座";
    }else {
        
      self.cartypeImageView.image = [UIImage imageNamed:@"meIconPassengerBlue.png"];
      self.carImageView.hidden = YES;
    self.carNameLabel.hidden = YES;
     self.carNumberLabel.hidden = YES;
    self.enrollLabel.text = @"报名车主";
    self.downCountLabel.text = @"需座";

        
    }
    self.downnumberLabel.text =[NSString stringWithFormat:@"%d",model.seatLeftCount];
    self.nicknameLabel.text = model.userName;
    self.careCountLabel.text =[NSString stringWithFormat:@"%d",model.collectCount];
  
    self.enrollCountLabel.text =[NSString stringWithFormat:@"%d",model.applyCount];
    
    

    //NSString* starPlace =[model.routeStartPlace substringToIndex:6];
    CGSize size = [model.routeStartPlace sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)];
    //重新修改frame.
  self.startplaceLabel.frame = CGRectMake(CGRectGetMaxX(self.startStationLabel.frame),CGRectGetMaxY(self.careImageview.frame)+14.0, size.width,20.0);
     self.locationstarLabel.frame = CGRectMake(CGRectGetMaxX(self.startplaceLabel.frame)+5,CGRectGetMaxY(self.careImageview.frame)+16.0, 40.0,20.0);
    
    
    self.startplaceLabel.text =model.routeStartPlace;
    //NSString* starQu = [model.routeStartPlace substringWithRange:NSMakeRange(6, 3)];
   // self.locationstarLabel.text = starQu;
    
    
  // NSString* endPlace =[model.routeEndPlace substringToIndex:6];
   CGSize sizeTwo = [model.routeEndPlace  sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)];
    //重新修改frame.
    self.overplaceLabel.frame = CGRectMake(CGRectGetMaxX(self.overStationLabel.frame),CGRectGetMaxY(self.startplaceLabel.frame)+12.0, sizeTwo.width,20.0);
    self.locationoverLabel.frame = CGRectMake(CGRectGetMaxX(self.overplaceLabel.frame)+5,CGRectGetMaxY(self.locationstarLabel.frame)+12.0, 40.0,20.0);
    
    self.overplaceLabel.text = model.routeEndPlace ;
    
   // NSString* endQu = [model.routeEndPlace substringWithRange:NSMakeRange(6, 3)];
  //  self.locationoverLabel.text = endQu;
    self.time.text = model.startTime;
    
    
}

@end
