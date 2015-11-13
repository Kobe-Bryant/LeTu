//
//  MyselfHomeTableHeaderView.m
//  LeTu
//
//  Created by DT on 14-5-18.
//
//

#import "MyselfHomeTableHeaderView.h"
#import "EGOImageButton.h"

@interface MyselfHomeTableHeaderView()
{
    CALayer *_grayCover;
}

@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UIButton *faceImage;
@property(nonatomic,strong)UILabel *nicknameLabel;
@property(nonatomic,strong)UILabel *moodLabel;
@property(nonatomic,strong)UIImageView *arrowImage;


@end

@implementation MyselfHomeTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UIImage* image = [UIImage imageNamed:@"me_headphoto_bg"];
        self.bgView = [[UIImageView alloc] init];
        self.bgView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
        self.bgView.image = image;
        [self addSubview:self.bgView];
        
        self.faceImage = [[UIButton alloc] initWithFrame:CGRectMake(15, 18, 50, 50)];
        [self.faceImage addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        UIImage* defaultImage = [UIImage imageNamed:@"meDefaultPhoto60x60.png"];
   
        self.faceImage.userInteractionEnabled = YES;
        [self.faceImage setImage:defaultImage forState:UIControlStateNormal];
        self.faceImage.layer.masksToBounds = NO;
        self.faceImage.clipsToBounds = YES;
        self.faceImage.layer.cornerRadius =25.0;
        [self.bgView addSubview:self.faceImage];
     
        self.nicknameLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.faceImage.frame)+15.0, CGRectGetMinY(self.faceImage.frame)-5.0, 200, 30)];
        self.nicknameLabel.font = [UIFont fontWithName: @"Helvetica-Bold" size : 16.0f ];
        self.nicknameLabel.backgroundColor = [UIColor clearColor];
        self.nicknameLabel.textColor = RGBCOLOR(54, 54, 54);
        [self.bgView addSubview:self.nicknameLabel];
        
        
        
       
        
        self.moodLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.faceImage.frame)+15.0, CGRectGetMaxY(self.nicknameLabel.frame)+10.0 , 110, 20)];
        self.moodLabel.font = [UIFont systemFontOfSize:15.0f];
        self.moodLabel.backgroundColor =[UIColor clearColor] ;
        self.moodLabel.textColor = RGBCOLOR(160, 160, 160);
        self.moodLabel.text = @"我们一起去旅游吧...";
        [self.bgView addSubview:self.moodLabel];
        
        UIImage* arrImage = [UIImage imageNamed:@"meNext12x20"];
        self.arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(303, 36.0,arrImage.size.width, arrImage.size.height)];
        self.arrowImage.image = arrImage;
        [self.bgView addSubview:self.arrowImage];
        
        //背景图片增加一个层
        CALayer *bgLayer = self.bgView.layer;
        _grayCover = [[CALayer alloc] init];
        _grayCover.frame = self.bgView.bounds;
        _grayCover.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
        [bgLayer addSublayer:_grayCover];
        _grayCover.hidden = YES;
        
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取当前ctx
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(ctx, 0.5);  //线宽
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGContextSetRGBStrokeColor(ctx, 0.8, 0.8, 0.8, 1);  //颜色
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, self.bgView.frame.size.height);  //起点坐标
    CGContextAddLineToPoint(ctx, 320, self.bgView.frame.size.height+0.5);   //终点坐标
    CGContextStrokePath(ctx);
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
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
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
    if ([self.delegate respondsToSelector:@selector(tableHeaderView:didClickToView:)]) {
        [self.delegate tableHeaderView:self didClickToView:self.tag];
    }
}

- (void)setUserModel:(UserModel *)userModel
{
    
    
    //昵称设置。
    self.nicknameLabel.text = userModel.fullName;
    //self.nicknameLabel.text = @"远方的风";
    
    
  
    
    self.moodLabel.text = userModel.sign;
   // self.moodLabel.text = @"我们一起去玩玩完";

    
    [self.faceImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERimageURL, userModel.userPhoto]] forState:UIControlStateNormal placeholderImage:PLACEHOLDER];
    
}
-(void)clickButton:(UIButton*)button
{
    
}
@end
