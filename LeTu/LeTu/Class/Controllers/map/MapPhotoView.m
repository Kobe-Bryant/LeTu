//
//  MapPhotoView.m
//  LeTu
//
//  Created by DT on 14-5-23.
//
//

#import "MapPhotoView.h"
#import "EGOImageView.h"

@interface MapPhotoView()
{
    CALayer *_grayCover;
}

@property(nonatomic,strong)UIImageView *headerImage;
@property(nonatomic,strong)UIImageView *footImage;
@property(nonatomic,strong)UIImageView *sexImage;
@end

@implementation MapPhotoView

- (id)initWithFrame:(CGRect)frame block:(PhotoViewBack)block
{
    self = [super initWithFrame:frame];
    if (self) {
        callBack = block;
        self.headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        self.headerImage.image = [UIImage imageNamed:@"location_pic"];
        [self addSubview:self.headerImage];
        
        self.footImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        self.footImage.backgroundColor = [UIColor clearColor];
        self.footImage.image = [UIImage imageNamed:@"location_tanchu_titlebg"];
        [self addSubview:self.footImage];
        
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, frame.size.width-25, 20)];
        self.distanceLabel.backgroundColor = [UIColor clearColor];
        self.distanceLabel.textColor = [UIColor whiteColor];
        self.distanceLabel.font = [UIFont systemFontOfSize:14.0f];
        self.distanceLabel.text = @"0.024km";
        [self.footImage addSubview:self.distanceLabel];
        
        self.sexImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-20, 2.5, 15, 15)];
        self.sexImage.image = [UIImage imageNamed:@"common_female"];
        [self.footImage addSubview:self.sexImage];
        
        //背景图片增加一个层
        CALayer *bgLayer = self.layer;
        _grayCover = [[CALayer alloc] init];
        _grayCover.frame = self.bounds;
        _grayCover.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
        [bgLayer addSublayer:_grayCover];
        _grayCover.hidden = YES;
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    _grayCover.hidden = NO;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    _grayCover.hidden = YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self performSelector:@selector(touchesEnded) withObject:nil afterDelay:0.1f];
}
- (void)touchesEnded
{
    _grayCover.hidden = YES;
    if (callBack) {
        callBack(self.index);
    }
}
-(void)setModel:(MapCarSharingModel *)model
{
//    self.headerImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,model.userPhoto]];
    [self.headerImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,model.userPhoto]] placeholderImage:PLACEHOLDER];
    if ([model.userGender intValue]==1) {//男
        self.sexImage.image = [UIImage imageNamed:@"common_male"];
    }else if ([model.userGender intValue]==2){//女
        self.sexImage.image = [UIImage imageNamed:@"common_female"];
    }
    CGFloat distance = [model.distance floatValue];
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.2f%@",distance,@"km"];
}
@end
