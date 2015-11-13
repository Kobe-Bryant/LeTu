//
//  FriendsCircleMECell.m
//  LeTu
//
//  Created by DT on 14-5-8.
//
//

#import "FriendsCircleMECell.h"
#import "FriendsCirclePhotoView.h"
@interface FriendsCircleMECell()

@property(nonatomic,retain) UIImageView *headbgImage;
@property(nonatomic,retain) UIImageView *faceImage;
@property(nonatomic,retain) UIImageView *markImage;
@property(nonatomic,retain) UILabel *contentLabel;
//@property(nonatomic,retain) UIImageView *mainImage;
@property(nonatomic,retain) UILabel *timeLabel;
@property(nonatomic,strong) FriendsCirclePhotoView *photoView;

@end

@implementation FriendsCircleMECell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.faceImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.faceImage.image = [UIImage imageNamed:@"friendscircle_me_datebox"];
        [self addSubview:self.faceImage];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.font = [UIFont systemFontOfSize:10.0f];
        self.timeLabel.textAlignment = UITextAlignmentCenter;
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = [UIColor whiteColor];
//        self.timeLabel.text = @"02-17";
        [self addSubview:self.timeLabel];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.markImage.image = [UIImage imageNamed:@"friendscircle_others_graycircle"];
        [self addSubview:self.markImage];
        
        UIImage *image = [UIImage imageNamed:@"friendscircle_others_dialogbox"];
        self.headbgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.headbgImage.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
        [self addSubview:self.headbgImage];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.contentLabel.font = [UIFont systemFontOfSize:14.0f];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.backgroundColor = [UIColor clearColor];
//        self.contentLabel.text = @"广州塔位于广州市中心，城市新中轴线与珠江景观轴交汇处， 与海心沙岛和广州市21世纪CBD区珠江新城隔江相望，是中国第一高塔，世界第三高塔。";
        [self addSubview:self.contentLabel];
        
        self.photoView  = [[FriendsCirclePhotoView alloc] initWithFrame:CGRectZero width:235];
        self.photoView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.photoView];
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
    self.timeLabel.text = [model.createdDate substringWithRange:NSMakeRange(5, 5)];
    
    //获得当前cell高度
    CGSize size = CGSizeMake(237.5, 1000);
    CGSize labelSize = CGSizeMake(0.0, 0.0);
    if ([model.content isEqualToString:@""]) {
        self.contentLabel.frame = CGRectMake(70, 15, size.width, 0);
    }else{
        labelSize = [self.contentLabel.text sizeWithFont:self.contentLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
        self.contentLabel.frame = CGRectMake(70, 15, labelSize.width, labelSize.height);
    }
    
    //获得当前cell高度
//    CGRect frame = [self frame];
//    CGSize size = CGSizeMake(237.5, 1000);
//    CGSize labelSize = [self.contentLabel.text sizeWithFont:self.contentLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
//    self.contentLabel.frame = CGRectMake(70, 15, labelSize.width, labelSize.height);
    
    self.photoView.frame = CGRectMake(70, labelSize.height+20, 235, 0);
    
    for (UIImageView *imageView in self.photoView.imageViewArray) {
        [imageView removeFromSuperview];
    }
    if ([model.imagesArray count]>=1) {
        self.photoView.photoArray = model.imagesArray;
        self.photoView.frame = CGRectMake(70, labelSize.height+20, 235, self.photoView.height);
    }
    [self resetFrame];
}
/**
 *  重置Frame
 */
- (void)resetFrame
{
    self.faceImage.frame = CGRectMake(5, 15, 35, 20);
    self.timeLabel.frame = CGRectMake(5, 15, 35, 20);
    self.markImage.frame = CGRectMake(45, 20, 10, 10);
    
    CGFloat height = self.photoView.frame.origin.y+self.photoView.frame.size.height+5;
    if (self.isFinal) {
        height +=20;
    }
    self.frame = CGRectMake(0, 0, self.frame.size.width, height);
    
    int remainder = self.tag%5;
    switch (remainder) {
        case 0:{
            self.faceImage.image = [UIImage imageNamed:@"friendscircle_me_datebox"];
            break;
        }case 1:{
            self.faceImage.image = [UIImage imageNamed:@"friendscircle_me_datebox_yellow"];
            break;
        }case 2:{
            self.faceImage.image = [UIImage imageNamed:@"friendscircle_me_datebox_green"];
            break;
        }case 3:{
            self.faceImage.image = [UIImage imageNamed:@"friendscircle_me_datebox_blue"];
            break;
        }case 4:{
            self.faceImage.image = [UIImage imageNamed:@"friendscircle_me_datebox_purple"];
            break;
        }
        default:
            break;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.headbgImage.frame = CGRectMake(60, 10, 250, self.frame.size.height - 10);
    if (self.isFinal) {
        self.headbgImage.frame = CGRectMake(60, 10, 250, self.frame.size.height - 30);
    }
}
@end
