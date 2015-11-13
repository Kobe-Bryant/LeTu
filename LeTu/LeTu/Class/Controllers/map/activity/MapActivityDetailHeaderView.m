//
//  MapActivityDetailHeaderView.m
//  LeTu
//
//  Created by DT on 14-6-17.
//
//

#import "MapActivityDetailHeaderView.h"

@interface MapActivityDetailHeaderView()
@property(nonatomic,strong)UIImageView *activityImage;
@property(nonatomic,strong)UILabel *activityTitle;
@property(nonatomic,strong)UIImageView *timeImage;
@property(nonatomic,strong)UILabel *activityTime;
@property(nonatomic,strong)UILabel *activityAddress;
@property(nonatomic,strong)UIImageView *locateImage;
@property(nonatomic,strong)UILabel *activityDistance;
@property(nonatomic,strong)UIImageView *separateImage;
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
        self.activityDistance.hidden = YES;
        [self addSubview:self.activityDistance];
        
        self.separateImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-3, 320, 3)];
        self.separateImage.image = [UIImage imageNamed:@"pengyouquan_comment_fengexian"];
        [self addSubview:self.separateImage];
    }
    return self;
}
-(void)setModel:(MapActivityModel *)model
{
    [self.activityImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,model.logPath]] placeholderImage:PLACEHOLDER];
    self.activityTitle.text = model.subject;
    self.activityTime.text = [model.startTime substringToIndex:[model.startTime length]-3];
    self.activityAddress.text = model.address;

}
@end
