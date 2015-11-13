//
//  FriendsCircleOtherCell.m
//  LeTu
//
//  Created by DT on 14-5-8.
//
//

#import "FriendsCircleOtherCell.h"
#import "CircleImageView.h"
#import "FriendsCirclePhotoView.h"

@interface FriendsCircleOtherCell()
{
    MiniBlogModel *_model;
}
@property(nonatomic,strong) UILabel *animationLabel;
@property(nonatomic,retain) UIImageView *headbgImage;
@property(nonatomic,retain) UIButton *faceImage;
@property(nonatomic,retain) UIImageView *markImage;
@property(nonatomic,retain) UILabel *contentLabel;
@property(nonatomic,retain) UILabel *timeLabel;
@property(nonatomic,strong) FriendsCirclePhotoView *photoView;
@end

@implementation FriendsCircleOtherCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.faceImage = [[UIButton alloc] initWithFrame:CGRectMake(7, 10, 35, 35)];
        self.faceImage.layer.masksToBounds=YES;
        self.faceImage.layer.cornerRadius=self.faceImage.frame.size.height/2;
        [self.faceImage.layer setBorderWidth:2];
        [self.faceImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        self.faceImage.tag = 3;
        [self.faceImage addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.faceImage];
        /*
        self.faceImage = [[CircleImageView alloc] initWithFrame:CGRectMake(7, 10, 35, 35) block:^{
            if ([self.delegate respondsToSelector:@selector(otherCell:didClickAtIndex:)]) {
                [self.delegate otherCell:self didClickAtIndex:3];
            }
        }];
        self.faceImage.layer.masksToBounds=YES;
        self.faceImage.layer.cornerRadius=self.faceImage.frame.size.height/2;
        [self.faceImage.layer setBorderWidth:2];
        [self.faceImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        
        
        self.faceImage.userInteractionEnabled = YES;
//        self.faceImage.image = [UIImage imageNamed:@"friendscircle_others_smallhead_20"];
        self.faceImage.placeholderImage = PLACEHOLDER;
        [self addSubview:self.faceImage];
         //*/
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.markImage.image = [UIImage imageNamed:@"friendscircle_others_graycircle"];
        [self addSubview:self.markImage];
        
        UIImage *image = [UIImage imageNamed:@"friendscircle_others_dialogbox"];
        self.headbgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.headbgImage.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
        [self addSubview:self.headbgImage];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.contentLabel.font = [UIFont systemFontOfSize:16.0f];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.backgroundColor = [UIColor clearColor];
//        self.contentLabel.text = @"广州塔位于广州市中心，城市新中轴线与珠江景观轴交汇处， 与海心沙岛和广州市21世纪CBD区珠江新城隔江相望，是中国第一高塔，世界第三高塔。";
        [self addSubview:self.contentLabel];
        
        self.photoView  = [[FriendsCirclePhotoView alloc] initWithFrame:CGRectZero width:235];
        self.photoView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.photoView];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.font = [UIFont systemFontOfSize:12.0f];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = [UIColor grayColor];
//        self.timeLabel.text = @"2小时前";
        [self addSubview:self.timeLabel];
        
        self.heartButton = [DTButton buttonWithType:UIButtonTypeCustom];
        self.heartButton.backgroundColor = [UIColor clearColor];
        self.heartButton.frame = CGRectZero;
        self.heartButton.titleLabel.font =[UIFont systemFontOfSize:12.0f];
        [self.heartButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [self.heartButton setTitle:@"45354" forState:UIControlStateNormal];
        self.heartButton.titleEdgeInsets = UIEdgeInsetsMake(2, 5, 0, 0);
        self.heartButton.normalImage = [UIImage imageNamed:@"friendscircle_others_dialogbox_heart_normal"];
        self.heartButton.pressImage = [UIImage imageNamed:@"friendscircle_others_dialogbox_heart_current"];
        self.heartButton.isSelect = NO;
        self.heartButton.tag=1;
        [self.heartButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.heartButton];
        
        self.bubbleButton = [DTButton buttonWithType:UIButtonTypeCustom];
        self.bubbleButton.backgroundColor = [UIColor clearColor];
        self.bubbleButton.frame = CGRectZero;
        self.bubbleButton.titleLabel.font =[UIFont systemFontOfSize:12.0f];
        [self.bubbleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [self.bubbleButton setTitle:@"44244" forState:UIControlStateNormal];
        self.bubbleButton.titleEdgeInsets = UIEdgeInsetsMake(2, 5, 0, 0);
        self.bubbleButton.normalImage = [UIImage imageNamed:@"friendscircle_others_dialogbox_bubble_normal"];
        self.bubbleButton.pressImage = [UIImage imageNamed:@"friendscircle_others_dialogbox_bubble_current"];
        self.bubbleButton.isSelect = NO;
        self.bubbleButton.tag=2;
        [self.bubbleButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bubbleButton];
        
        self.animationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.animationLabel.backgroundColor = [UIColor clearColor];
        self.animationLabel.font =[UIFont systemFontOfSize:14.0f];
        self.animationLabel.textColor = RGBCOLOR(30, 140, 246);
        self.animationLabel.text = @"+1";
        [self addSubview:self.animationLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)drawRect:(CGRect)rect
{
//    [RGBCOLOR(224,224,224) set];
    [RGBCOLOR(230,230,230) set];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineJoin(currentContext, kCGLineJoinMiter);
    CGContextSetLineWidth(currentContext,2.0f);
    CGContextMoveToPoint(currentContext,50,0);
    CGContextAddLineToPoint(currentContext,50, 20);
    CGContextStrokePath(currentContext);
    
    if (!self.isFinal) {
        CGContextSetLineJoin(currentContext, kCGLineJoinMiter);
        CGContextSetLineWidth(currentContext,2.0f);
        CGContextMoveToPoint(currentContext,50,25);
        CGContextAddLineToPoint(currentContext,50, rect.size.height);
        CGContextStrokePath(currentContext);
    }
}

- (void)setModel:(MiniBlogModel *)model
{
    self.contentLabel.text = model.content;
    [self.heartButton setTitle:[NSString stringWithFormat:@"%i",[model.commendNum intValue]] forState:UIControlStateNormal];
    [self.heartButton setTitle:[NSString stringWithFormat:@"%i",[model.commendNum intValue]] forState:UIControlStateHighlighted];
    
    [self.bubbleButton setTitle:[NSString stringWithFormat:@"%i",[model.commentNum intValue]] forState:UIControlStateNormal];
    [self.bubbleButton setTitle:[NSString stringWithFormat:@"%i",[model.commentNum intValue]] forState:UIControlStateHighlighted];
    
    if (1 == [model.hasCommend intValue]) {//是否赞了
        self.heartButton.isSelect = YES;
    }else{
        self.heartButton.isSelect = NO;
    }
    if (1 == [model.hasComment intValue]) {//是否评论
        self.bubbleButton.isSelect = YES;
    }else{
        self.bubbleButton.isSelect = NO;
    }
    
//    self.faceImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, model.userPhoto]];
    [self.faceImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, model.userPhoto]] forState:UIControlStateNormal placeholderImage:PLACEHOLDER];
    self.timeLabel.text = [DateUtil compareCurrentTimeString:model.createdDate];
    
    //获得当前cell高度
    CGSize size = CGSizeMake(232.5, 1000);
    if ([model.content isEqualToString:@""]) {
        self.contentLabel.frame = CGRectMake(75, 15, size.width, 0);
    }else{
        CGSize labelSize = [self.contentLabel.text sizeWithFont:self.contentLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
        self.contentLabel.frame = CGRectMake(75, 15, labelSize.width, labelSize.height);
    }
    //计算出自适应的高度
    int height = self.contentLabel.frame.size.height + self.contentLabel.frame.origin.y+5;
    
//    for (UIView *view in [self.photoView subviews]) {
//        NSLog(@"view:%@",view);
//        [view removeFromSuperview];
//    }
    for (UIImageView *imageView in self.photoView.imageViewArray) {
        [imageView removeFromSuperview];
    }
    
    self.photoView.frame = CGRectMake(70, height, 235, 0);
    
    if ([model.imagesArray count]>=1) {
        self.photoView.photoArray = model.imagesArray;
//        self.photoView.backgroundColor = [UIColor clearColor];
        self.photoView.frame = CGRectMake(70, height, 235, self.photoView.height);
    }
    [self resetFrame];
}
/**
 *  重置Frame
 */
- (void)resetFrame
{
    CGRect frame = self.photoView.frame;
    
    self.faceImage.frame = CGRectMake(7, 10, 35, 35);
    self.markImage.frame = CGRectMake(45, 20, 10, 10);
//    self.headbgImage.frame = CGRectMake(60, 10, 250, self.frame.size.height - 10);
//    if (self.isFinal) {
//        self.headbgImage.frame = CGRectMake(60, 10, 250, self.frame.size.height - 30);
//    }
    int y = frame.origin.y + frame.size.height +5;
    
    self.timeLabel.frame = CGRectMake(75, y-2, 100, 20);
    self.heartButton.frame = CGRectMake(210, y, 55, 20);
    self.bubbleButton.frame = CGRectMake(255, y, 55, 20);
    
    y = y+20;
    frame.size.height = y;
    if (self.isFinal) {
        frame.size.height = y+10;
    }
    self.frame = frame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.headbgImage.frame = CGRectMake(60, 10, 250, self.frame.size.height - 10);
    if (self.isFinal) {
        self.headbgImage.frame = CGRectMake(60, 10, 250, self.frame.size.height - 20);
    }
}
- (void)clickButton:(DTButton*)button
{
    if (button.tag ==1) {//赞按钮
        if ([button isSelect]) {
            self.animationLabel.text = @"-1";
            button.isSelect = NO;
            NSLog(@"-1 title:%@",self.heartButton.titleLabel.text);
            int commendNum = [[self.heartButton titleForState:UIControlStateNormal] intValue]-1;
            NSLog(@"-1:%i",commendNum);
            [self.heartButton setTitle:[NSString stringWithFormat:@"%i",commendNum] forState:UIControlStateNormal];
        }else{
            self.animationLabel.text = @"+1";
            button.isSelect = YES;
            NSLog(@"+1 title:%@",self.heartButton.titleLabel.text);
            int commendNum = [[self.heartButton titleForState:UIControlStateNormal] intValue]+1;
            NSLog(@"+1:%i",commendNum);
            [self.heartButton setTitle:[NSString stringWithFormat:@"%i",commendNum] forState:UIControlStateNormal];
        }
        CGRect frame = self.heartButton.frame;
        self.animationLabel.frame =CGRectMake(frame.origin.x+20, frame.origin.y-5, 30, 20);
        [self animateCount];
        
//        button.isSelect = ![button isSelect];
        if ([self.delegate respondsToSelector:@selector(otherCell:didClickAtIndex:)]) {
            [self.delegate otherCell:self didClickAtIndex:button.tag];
        }
    }else if (button.tag == 2){//评论按钮
        if ([self.delegate respondsToSelector:@selector(otherCell:didClickAtIndex:)]) {
            [self.delegate otherCell:self didClickAtIndex:button.tag];
        }
        /*
        if (![button isSelect]) {
            button.isSelect = ![button isSelect];
            if ([self.delegate respondsToSelector:@selector(otherCell:didClickAtIndex:)]) {
                [self.delegate otherCell:self didClickAtIndex:button.tag];
            }
        }
         //*/
        
    }else if (button.tag ==3){//头像
        if ([self.delegate respondsToSelector:@selector(otherCell:didClickAtIndex:)]) {
            [self.delegate otherCell:self didClickAtIndex:3];
        }
    }
}
-(void)animateCount
{
    self.animationLabel.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.animationLabel.frame;
        frame.origin.y -=15;
        self.animationLabel.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            self.animationLabel.alpha = 0;
        }];
    }];
}

+ (CGFloat)calculateCellHeightWithAlbum:(MiniBlogModel *)model isFinal:(BOOL)isFinal;
{
    CGFloat height = 0.0;
    //获得当前cell高度
    CGSize size = CGSizeMake(232.5, 1000);
    if ([model.content isEqualToString:@""]) {
        height = 15+5;
    }else{
        CGSize labelSize = [model.content sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
        height = 15 +labelSize.height+5;
    }
    
    if ([model.imagesArray count]>=1) {
        int numberOfColumn = 2;//行
        NSInteger rows = [model.imagesArray count] / numberOfColumn;//列
        NSInteger remainder = [model.imagesArray count] % numberOfColumn;
        if (remainder>0) {
            rows++;
        }
        height += 119.5*rows;
    }else{
        height +=0;
    }
    height +=25;
    if (isFinal) {
        height +=10;
    }
    return height ;
}
@end
