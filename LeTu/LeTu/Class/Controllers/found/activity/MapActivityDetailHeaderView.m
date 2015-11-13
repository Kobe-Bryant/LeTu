//
//  MapActivityDetailHeaderView.m
//  LeTu
//
//  Created by DT on 14-6-17.
//
//

#import "MapActivityDetailHeaderView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface MapActivityDetailHeaderView()
@property(nonatomic,strong)UIImageView *activityImage;
@property(nonatomic,strong)UILabel *activityTitle;
@property(nonatomic,strong)UIImageView *timeImage;
@property(nonatomic,strong)UILabel *activityTime;
@property(nonatomic,strong)UILabel *activityAddress;
@property(nonatomic,strong)UIImageView *locateImage;
@property(nonatomic,strong)UILabel *activityDistance;
@property(nonatomic,strong)UIImageView *separateImage;
@property(nonatomic,strong)UIButton *signupButton;
@end

@implementation MapActivityDetailHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.activityImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 165)];
        self.activityImage.image = PLACEHOLDER;
        self.activityImage.clipsToBounds = YES;
        self.activityImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.activityImage];
        
        self.activityTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 165, 300, 30)];
        self.activityTitle.backgroundColor = [UIColor clearColor];
        self.activityTitle.font = [UIFont systemFontOfSize:16.0f];
        self.activityTitle.text = @"法国爵士音乐鬼才三重奏";
        [self addSubview:self.activityTitle];
        
        self.timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 201, 13, 13)];
        self.timeImage.image = [UIImage imageNamed:@"activity_detial_time"];
        [self addSubview:self.timeImage];
        
        self.activityTime = [[UILabel alloc] initWithFrame:CGRectMake(30, 195, 300, 25)];
        self.activityTime.backgroundColor = [UIColor clearColor];
        self.activityTime.textColor = [UIColor grayColor];
        self.activityTime.font = [UIFont systemFontOfSize:14.0f];
        self.activityTime.text = @"06-08 周日 20:30-21:30";
        [self addSubview:self.activityTime];
        
        self.signupButton = [[UIButton alloc] initWithFrame:CGRectMake(240, 200, 70, 17)];
        [self.signupButton setImage:[UIImage imageNamed:@"check_people_normal"] forState:UIControlStateNormal];
        [self.signupButton setImage:[UIImage imageNamed:@"check people_press"] forState:UIControlStateHighlighted];
        self.signupButton.tag = 1;
        [self.signupButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.signupButton];
        
        self.activityAddress = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, 300, 25)];
        self.activityAddress.backgroundColor = [UIColor clearColor];
        self.activityAddress.textColor = [UIColor grayColor];
        self.activityAddress.font = [UIFont systemFontOfSize:14.0f];
        self.activityAddress.text = @"广东省广州市天河区天河北路776号创意大厦13-201";
        [self addSubview:self.activityAddress];
        
        self.locateImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 251-2, 13, 13)];
        self.locateImage.image = [UIImage imageNamed:@"activity_detial_location"];
        [self addSubview:self.locateImage];
        
        self.activityDistance = [[UILabel alloc] initWithFrame:CGRectMake(30, 245-2, 300, 25)];
        self.activityDistance.backgroundColor = [UIColor clearColor];
        self.activityDistance.textColor = [UIColor grayColor];
        self.activityDistance.font = [UIFont systemFontOfSize:14.0f];
        self.activityDistance.text = @"113.2km";
//        self.activityDistance.hidden = YES;
        [self addSubview:self.activityDistance];
        
        self.joinButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 270, 140, 30)];
        [self.joinButton setImage:[UIImage imageNamed:@"check_people_join"] forState:UIControlStateNormal];
        self.joinButton.tag = 2;
        [self.joinButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.joinButton];
        
        self.separateImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-3, 320, 3)];
        self.separateImage.image = [UIImage imageNamed:@"pengyouquan_comment_fengexian"];
        [self addSubview:self.separateImage];
    }
    return self;
}
-(void)setModel:(MapActivityModel *)model
{
    _model = model;
    [self.activityImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,model.logPath]] placeholderImage:PLACEHOLDER];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    self.activityImage.userInteractionEnabled = YES;
    [self.activityImage addGestureRecognizer:gesture];
    
    self.activityTitle.text = model.subject;
    self.activityTime.text = [model.startTime substringToIndex:[model.startTime length]-3];
    self.activityAddress.text = model.address;
    
    if ([model.apply intValue]==0) {//未报名
        [self.joinButton setImage:[UIImage imageNamed:@"check_people_join"] forState:UIControlStateNormal];
    }else if ([model.apply intValue]==1) {//已报名
        [self.joinButton setImage:[UIImage imageNamed:@"check_people_joined"] forState:UIControlStateNormal];
        [self.joinButton setImage:[UIImage imageNamed:@"check_people_joined"] forState:UIControlStateHighlighted];
        self.joinButton.tag = 5;
    }
    if (model.latitudeActivity == nil) {
        self.locateImage.hidden = YES;
        self.activityDistance.hidden = YES;
    }
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    CLLocation *toLocation = [[CLLocation alloc] initWithLatitude:[model.latitudeActivity floatValue] longitude:[model.longitudeActivity floatValue]];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:appDelegate.currentLocation.latitude longitude:appDelegate.currentLocation.longitude];
    
    CLLocationDistance distance = [currentLocation distanceFromLocation:toLocation];
    if(distance>1000){
        self.activityDistance.text = [NSString stringWithFormat:@"%.0f公里",distance/1000];
    }else{
        self.activityDistance.text = [NSString stringWithFormat:@"%.0f米",distance];
    }

}
-(void)clickButton:(UIButton*)button
{
    if (self.callBack) {
        self.callBack(button.tag);
    }
}
- (void)tapHandle:(UITapGestureRecognizer *)tap
{
    [self showBigImage:[NSString stringWithFormat:@"%@%@", SERVERImageURL, _model.logPath] imageView:self.activityImage];
}
/**
 *  显示大图
 *
 *  @param urlString 图片路径
 *  @param imageView 图片imageView
 */
-(void)showBigImage:(NSString*)urlString imageView:(UIImageView*)imageView
{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:urlString]; // 图片路径
    //    UIImageView * imageView = self.headImgView;
    photo.srcImageView = imageView;
    [photos addObject:photo];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = photos; // 设置所有的图片
    browser.currentPhotoIndex =  0; // 弹出相册时显示的第一张图片是？
    [browser show];
}
@end
