//
//  MapFaceAnnotationView.m
//  LeTu
//
//  Created by DT on 14-5-16.
//
//

#import "MapFaceAnnotationView.h"
#import "EGOImageView.h"

@interface MapFaceAnnotationView()

@property(nonatomic,strong)UIImageView *headPortraitImage;
@property(nonatomic,strong)UIImageView *footImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *userTypeImage;
@property(nonatomic,strong)UILabel *userTypeLabel;
@property(nonatomic,strong)UIImageView *freeImage;
@property(nonatomic,strong)UILabel *freeLabel;

@end

@implementation MapFaceAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.headPortraitImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 146, 137)];
        self.headPortraitImage.backgroundColor = [UIColor clearColor];
        self.headPortraitImage.clipsToBounds = YES;
        self.headPortraitImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.headPortraitImage];
        
        self.footImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 119, 146, 20)];
        self.footImage.backgroundColor = [UIColor clearColor];
        self.footImage.image = [UIImage imageNamed:@"location_tanchu_titlebg"];
        [self addSubview:self.footImage];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, 65, 20)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.footImage addSubview:self.nameLabel];
        
        self.userTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(65, 0, 20, 20)];
        self.userTypeImage.backgroundColor = [UIColor clearColor];
        [self.footImage addSubview:self.userTypeImage];
        
        self.userTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 0, 25, 20)];
        self.userTypeLabel.backgroundColor = [UIColor clearColor];
        self.userTypeLabel.textColor = [UIColor whiteColor];
        self.userTypeLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.footImage addSubview:self.userTypeLabel];
        
        /*
        self.freeImage = [[UIImageView alloc] initWithFrame:CGRectMake(103, 0, 20, 20)];
        self.freeImage.backgroundColor = [UIColor clearColor];
        [self.footImage addSubview:self.freeImage];
        
        self.freeLabel = [[UILabel alloc] initWithFrame:CGRectMake(121, 0, 25, 20)];
        self.freeLabel.backgroundColor = [UIColor clearColor];
        self.freeLabel.textColor = [UIColor whiteColor];
        self.freeLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.footImage addSubview:self.freeLabel];
         //*/
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIImage *background = [UIImage imageNamed:@"location_bubble"];
    [background drawInRect:rect];
}
- (void)setHeadPortrait:(NSString *)headPortrait
{
//    self.headPortraitImage.image = [UIImage imageNamed:headPortrait];
//    self.headPortraitImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,headPortrait]];
    [self.headPortraitImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,headPortrait]] placeholderImage:PLACEHOLDER];

}
- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}
- (void)setUserType:(int)userType
{
    if (userType==1) {
        self.userTypeImage.image = [UIImage imageNamed:@"location_driver"];
        self.userTypeLabel.text = @"车主";
    }else if (userType==2){
        self.userTypeImage.image = [UIImage imageNamed:@"location_passenger"];
        self.userTypeLabel.text = @"乘客";
    }
}
- (void)setFree:(int)free
{
    if (free==1) {//付费
        self.freeImage.image = [UIImage imageNamed:@"location_coin"];
        self.freeLabel.text = @"付费";
    }else if (free==0){
        self.freeImage.image = [UIImage imageNamed:@"location_coin"];
        self.freeLabel.text = @"免费";
    }
}
@end
