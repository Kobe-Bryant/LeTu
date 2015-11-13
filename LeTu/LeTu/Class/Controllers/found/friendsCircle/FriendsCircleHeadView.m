//
//  FriendsCircleHeadView.m
//  LeTu
//
//  Created by DT on 14-5-7.
//
//

#import "FriendsCircleHeadView.h"
#import "CircleImageView.h"
#import "EGOImageView.h"
#import "SYWaterDropView.h"

@interface FriendsCircleHeadView()
{
    BOOL isrefreshed;
}
@property(nonatomic,retain) CircleImageView *faceImage;
@property(nonatomic,retain) UILabel *nameLabel;
@property(nonatomic,retain) UILabel *remarkLabel;
@property(nonatomic,retain) UILabel *lineLabel;
@property(nonatomic,retain) UIImageView *markImage;
@property(nonatomic,strong) SYWaterDropView *waterDropView;
@end

@implementation FriendsCircleHeadView
@synthesize model = _model;

- (id)initWithFrame:(CGRect)frame block:(CallUserBack)block
{
    self = [super initWithFrame:frame];
    if (self) {
        callBack = block;
        
        self.bgImage = [[EGOImageView alloc] initWithFrame:CGRectZero];
        self.bgImage.frame = CGRectMake(0, 0,320, 104);
        self.bgImage.placeholderImage = [UIImage imageNamed:@"friendscircle_others_pic"];
        self.bgImage.clipsToBounds = YES;
        self.bgImage.contentMode = UIViewContentModeCenter;
        self.bgImage.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        [self.bgImage addGestureRecognizer:gesture];
        self.bgImage.image = [UIImage imageNamed:@"friendscircle_others_pic"];
        self.bgImage.userInteractionEnabled = YES;
        [self addSubview:self.bgImage];
        
        self.faceImage = [[CircleImageView alloc] initWithFrame:CGRectMake(18, 18, 60, 60) block:^{
            if (callBack) {
                callBack(1,_model.userId,_model.userName);
            }
        }];
        self.faceImage.userInteractionEnabled = YES;
//        self.faceImage.image = [UIImage imageNamed:@"friendscircle_others_bighead_11"];
        [self addSubview:self.faceImage];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 200, 30)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.font = [UIFont systemFontOfSize:25.0f];
//        self.nameLabel.text = @"Ella";
        [self addSubview:self.nameLabel];
        
        self.remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 200, 25)];
        self.remarkLabel.backgroundColor = [UIColor clearColor];
        self.remarkLabel.textColor = [UIColor whiteColor];
        self.remarkLabel.font = [UIFont systemFontOfSize:15.0f];
//        self.remarkLabel.text = @"我们一起去旅行吧...";
        [self addSubview:self.remarkLabel];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(45, 75, 10, 10)];
        self.markImage.image = [UIImage imageNamed:@"friendscircle_others_whitelcircle"];
//        [self addSubview:self.markImage];
        
        self.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(49, 85, 2, 19)];
        self.lineLabel.backgroundColor = RGBCOLOR(224,224,224);
//        [self addSubview:self.lineLabel];
        
        self.waterDropView = [[SYWaterDropView alloc] initWithFrame:CGRectMake(35, 75, 10, 30)];
        self.waterDropView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.waterDropView];
        self.waterDropView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        
        [self initWaterView];
        
    }
    return self;
}

-(void)refresh
{
    if(self.waterDropView.isRefreshing)
    {
        [self.waterDropView startRefreshAnimation];
    }
}
-(void)setIsRefreshed:(BOOL)b
{
    isrefreshed = b;
}
-(void)initWaterView
{
    __weak FriendsCircleHeadView* wself =self;
    [self.waterDropView setHandleRefreshEvent:^{
        [wself setIsRefreshed:YES];
        if(wself.handleRefreshEvent)
        {
            wself.handleRefreshEvent();
        }
    }];
}
-(void)setTouching:(BOOL)touching
{
    if(touching)
    {
        if(hasStop)
        {
            [self resetTouch];
        }
        
        if(touch1)
        {
            touch2 = YES;
        }
        else if(touch2 == NO && self.waterDropView.isRefreshing == NO)
        {
            touch1 = YES;
        }
    }
    else if(self.waterDropView.isRefreshing == NO)
    {
        [self resetTouch];
    }
    _touching = touching;
}
-(void)resetTouch
{
    touch1 = NO;
    touch2 = NO;
    hasStop = NO;
    isrefreshed = NO;
}
-(void)stopRefresh
{
    [self.waterDropView stopRefresh];
    if(_touching == NO)
    {
        [self resetTouch];
    }
    else
    {
        hasStop = YES;
    }
}
-(void)setOffsetY:(float)y
{
    _offsetY = y;
    CGRect frame = self.faceImage.frame;
    if(y<0)
    {
        if((self.waterDropView.isRefreshing) || hasStop)
        {
            if(touch1 && touch2 == NO)
            {
                frame.origin.y = 20+y;
//                self.faceImage.frame = frame;
            }
            else
            {
                if(frame.origin.y != 20)
                {
                    frame.origin.y = 20;
//                    self.faceImage.frame = frame;
                }
            }
        }
        else
        {
            frame.origin.y = 20+y;
//            self.faceImage.frame = frame;
        }
    }
    else{
        if(touch1 && _touching && isrefreshed)
        {
            touch2 = YES;
        }
        if(frame.origin.y != 20)
        {
            frame.origin.y = 20;
//            self.faceImage.frame = frame;
        }
    }
    if (hasStop == NO) {
        NSLog(@"y1:%f",y);
        self.waterDropView.currentOffset = y;
    }else{
        NSLog(@"y2:%f",y);
    }
}

/*
-(void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"friendscircle_others_pic"];
    [image drawInRect:rect];
    
    [RGBCOLOR(224,224,224) set];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineJoin(currentContext, kCGLineJoinMiter);
    CGContextSetLineWidth(currentContext,2.0f);
    CGContextMoveToPoint(currentContext,50,85);
    CGContextAddLineToPoint(currentContext,50, 104);
    CGContextStrokePath(currentContext);
}
 //*/
- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.bgImage.frame = CGRectMake(0, 0,self.frame.size.width, self.frame.size.height);
}
- (void)setModel:(BlogOverheadModel *)model
{
    _model = model;
    if (![model.hbgPhoto isEqualToString:@""]) {
        self.bgImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, model.hbgPhoto]];
    }
    self.faceImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, model.userPhoto]];
    self.nameLabel.text = model.userName;
    self.remarkLabel.text = model.sign;
}

- (void)tapHandle:(UITapGestureRecognizer *)tap {
    if (callBack) {
        callBack(2,@"",@"");
    }
}
@end
