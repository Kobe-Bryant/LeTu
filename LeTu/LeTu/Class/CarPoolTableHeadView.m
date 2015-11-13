//
//  CarPoolTableHeadView.m
//  LeTu
//
//  Created by mafeng on 14-9-22.
//
//

#import "CarPoolTableHeadView.h"
#import "CarManagerModel.h"
#import "LeTuRouteModel.h"



@implementation CarPoolTableHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
   
        
        //头像👦
        self.avatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 10, 50, 50)];
        UIImage* defaultImage = [UIImage imageNamed:@"meDefaultPhoto60x60.png"];
        self.avatorImageView.image = defaultImage;
        self.avatorImageView.userInteractionEnabled = YES;
        self.avatorImageView.layer.masksToBounds = NO;
        self.avatorImageView.clipsToBounds = YES;
        self.avatorImageView.layer.cornerRadius =25.0;
        [self addSubview:self.avatorImageView];
        
        //车的标志或者乘客的标志
        self.cartypeImageView = [[UIImageView alloc]init];
        UIImage* carimage = [UIImage imageNamed:@"meIconDriverBlue.png"];
        self.cartypeImageView.frame = CGRectMake(CGRectGetMaxX(self.avatorImageView.frame) -carimage.size.width, CGRectGetMaxY(self.avatorImageView.frame)-carimage.size.height, carimage.size.width, carimage.size.height);
        self.cartypeImageView.image = carimage;
        [self addSubview:self.cartypeImageView];
        
        //昵称
        self.nicknameLabel = [[UILabel alloc]init];
        self.nicknameLabel.frame = CGRectMake(CGRectGetMinX(self.avatorImageView.frame)+10, CGRectGetMaxY(self.avatorImageView.frame)+5.0, 100.0,20.0);
        self.nicknameLabel.font = [UIFont systemFontOfSize:10.0];
        self.nicknameLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.nicknameLabel];
        
        
        
        
        //车的图片，只有车主才显示
        self.carImageView = [[UIImageView alloc]init];
        UIImage* carimagetwo = [UIImage imageNamed:@"meIconDriverBlue.png"];
        self.carImageView.frame = CGRectMake(20.0, CGRectGetMaxY(self.nicknameLabel.frame)-2, carimagetwo.size.width, carimagetwo.size.height);
        self.carImageView.image = carimagetwo;
        [self addSubview:self.carImageView];
        
        //车的名字 只有车主才显示
        self.carNameLabel = [[UILabel alloc]init];
        self.carNameLabel.frame = CGRectMake(CGRectGetMaxX(self.carImageView.frame)+7.0,CGRectGetMaxY(self.nicknameLabel.frame) , 100.0,20.0);
        self.carNameLabel.font = [UIFont systemFontOfSize:10.0];
        self.carNameLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.carNameLabel];
        
        //车牌号 只有车主才显示
        self.carNumberLabel = [[UILabel alloc]init];
        self.carNumberLabel.frame = CGRectMake(20.0, CGRectGetMaxY(self.carNameLabel.frame)-2-2, 180.0,20.0);
        self.carNumberLabel.font = [UIFont systemFontOfSize:10.0];
        self.carNumberLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.carNumberLabel];
        
        //起点
        self.startStationLabel = [[UILabel alloc]init];
        self.startStationLabel.frame = CGRectMake(CGRectGetMaxX(self.avatorImageView.frame)+28.0,20.0, 40.0,20.0);
        self.startStationLabel.font = [UIFont systemFontOfSize:14.0];
        self.startStationLabel.textColor = [UIColor whiteColor];
        self.startStationLabel.text = @"起点:";
        [self addSubview:self.startStationLabel];
        
        //起点的位置
        self.startplaceLabel = [[UILabel alloc]init];
        self.startplaceLabel.frame = CGRectMake(CGRectGetMaxX(self.startStationLabel.frame)+3,20, 90.0,20.0);
        self.startplaceLabel.font = [UIFont systemFontOfSize:14.0];
        self.startplaceLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.startplaceLabel];
        
        //起点的区
        self.locationstarLabel = [[UILabel alloc]init];
        self.locationstarLabel.font = [UIFont systemFontOfSize:10.0];
        self.locationstarLabel.frame = CGRectMake(CGRectGetMaxX(self.startplaceLabel.frame)+3, 23.0, 100, 20);
        self.locationstarLabel.textColor =[UIColor whiteColor];
        self.locationstarLabel.text = @"南山区";
        [self addSubview:self.locationstarLabel];
        
        //终点
        self.overStationLabel = [[UILabel alloc]init];
        self.overStationLabel.frame = CGRectMake(CGRectGetMinX(self.startStationLabel.frame),CGRectGetMaxY(self.startStationLabel.frame)+15.0, 40.0,20.0);
        self.overStationLabel.font = [UIFont systemFontOfSize:14.0];
        self.overStationLabel.textColor = [UIColor whiteColor];
        self.overStationLabel.text = @"终点:";
        [self addSubview:self.overStationLabel];
        
        //终点的位置
        self.overplaceLabel = [[UILabel alloc]init];
        self.overplaceLabel.frame = CGRectMake(CGRectGetMaxX(self.startStationLabel.frame),CGRectGetMaxY(self.startplaceLabel.frame)+15.0, 90.0,20.0);
        self.overplaceLabel.font = [UIFont systemFontOfSize:14.0];
        self.overplaceLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.overplaceLabel];
        
        //终点的区
        self.locationoverLabel = [[UILabel alloc]init];
        self.locationoverLabel.frame = CGRectMake(CGRectGetMaxX(self.overplaceLabel.frame), CGRectGetMaxY(self.locationstarLabel.frame)+18, 100, 20);
        self.locationoverLabel.font = [UIFont systemFontOfSize:10.0];
        self.locationoverLabel.textColor = [UIColor whiteColor];
        self.locationoverLabel.text = @"南山区";
        [self addSubview:self.locationoverLabel];
        
        
        //时间
        self.time = [[UILabel alloc]init];
         self.time.frame = CGRectMake(CGRectGetMinX(self.startStationLabel.frame),CGRectGetMaxY(self.overStationLabel.frame)+15.0, 40.0,20.0);
        self.time.font = [UIFont systemFontOfSize:14.0];
        self.time.textColor = [UIColor whiteColor];
        self.time.text = @"时间:";

        [self addSubview:self.time];
        
        //日期和时间
        self.time = [[UILabel alloc]init];
        self.time.frame = CGRectMake(CGRectGetMinX(self.overplaceLabel.frame),CGRectGetMaxY(self.overStationLabel.frame)+15.0, 200.0,20.0);
        self.time.font = [UIFont systemFontOfSize:14.0];
        self.time.textColor = [UIColor whiteColor];
        [self addSubview:self.time];
        
        
        //余座
        self.downCountLabel = [[UILabel alloc]init];
        self.downCountLabel.frame = CGRectMake(320.0 - 15- 50, CGRectGetMinY(self.time.frame), 40.0,20.0);
        self.downCountLabel.font = [UIFont systemFontOfSize:11.0];
        self.downCountLabel.text =@"余座";
        self.downCountLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.downCountLabel];
        
        
        //余座的个数 downnumberLabel
        self.downnumberLabel = [[UILabel alloc]init];
        self.downnumberLabel.frame = CGRectMake(320.0-35.0, CGRectGetMinY(self.time.frame), 40.0,20.0);
        self.downnumberLabel.font = [UIFont systemFontOfSize:18.0];
        self.downnumberLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.downnumberLabel];
        
    
    }
    return self;
}

- (void)setTableHeadViewInformation:(LeTuRouteModel*)model
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
        self.downCountLabel.text = @"余座";
    }else {
        
        self.cartypeImageView.image = [UIImage imageNamed:@"meIconPassengerBlue.png"];
        self.carImageView.hidden = YES;
        self.carNameLabel.hidden = YES;
        self.carNumberLabel.hidden = YES;
        self.downCountLabel.text = @"需座";
        
        
    }
    self.downnumberLabel.text =[NSString stringWithFormat:@"%d",model.seatLeftCount];
    self.nicknameLabel.text = model.userName;
    NSString* starPlace =[model.routeStartPlace substringToIndex:6];
    
    CGSize size = [starPlace sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)];
    //重新修改frame.
    self.startplaceLabel.frame = CGRectMake(CGRectGetMaxX(self.startStationLabel.frame),20.0, size.width,20.0);
    self.locationstarLabel.frame = CGRectMake(CGRectGetMaxX(self.startplaceLabel.frame)+8,22.0, 40.0,20.0);
    
    
    self.startplaceLabel.text =starPlace;
  //  NSString* starQu = [model.routeStartPlace substringWithRange:NSMakeRange(6, 3)];
    //self.locationstarLabel.text = starQu;
    
    
    NSString* endPlace =[model.routeEndPlace substringToIndex:6];
    CGSize sizeTwo = [endPlace sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)];
    //重新修改frame.
    self.overplaceLabel.frame = CGRectMake(CGRectGetMaxX(self.overStationLabel.frame),CGRectGetMaxY(self.startplaceLabel.frame)+18.0, sizeTwo.width,20.0);
    self.locationoverLabel.frame = CGRectMake(CGRectGetMaxX(self.overplaceLabel.frame)+8,CGRectGetMaxY(self.locationstarLabel.frame)+18.0, 40.0,20.0);
    
    self.overplaceLabel.text = endPlace;
    
   // NSString* endQu = [model.routeEndPlace substringWithRange:NSMakeRange(6, 3)];
    //self.locationoverLabel.text = endQu;
    
    NSString* timeDate = [model.startTime substringWithRange:NSMakeRange(5, 5)];
    NSString* timedetaile = [model.startTime substringWithRange:NSMakeRange(11, 5)];
    NSString* lastTime = [timeDate stringByAppendingFormat:@" %@",timedetaile];
    self.time.text = lastTime;
}

@end
