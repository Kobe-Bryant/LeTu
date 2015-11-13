//
//  DetailCommentCell.m
//  LeTu
//
//  Created by DT on 14-5-15.
//
//

#import "DetailCommentCell.h"
#import "CircleImageView.h"

@interface DetailCommentCell()
@property(nonatomic,retain) UIButton *faceImage;
@property(nonatomic,retain) UILabel *nameLabel;
@property(nonatomic,retain) UILabel *timeLabel;
@property(nonatomic,retain) UILabel *contentLabel;
@property(nonatomic,retain) UIImageView *lineImage;
@end

@implementation DetailCommentCell
@synthesize model = _model;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.faceImage = [[UIButton alloc] initWithFrame:CGRectMake(12, 12, 40, 40)];
        [self.faceImage setImage:PLACEHOLDER forState:UIControlStateNormal];
        self.faceImage.layer.masksToBounds=YES;
        self.faceImage.layer.cornerRadius=self.faceImage.frame.size.height/2;
        [self.faceImage.layer setBorderWidth:2];
        [self.faceImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        self.faceImage.tag = 3;
        [self.faceImage addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.faceImage];
        
        /*
        self.faceImage = [[CircleImageView alloc] initWithFrame:CGRectMake(12, 12, 40, 40) block:^{
            if ([self.delegate respondsToSelector:@selector(commentCell:clickFaceImage:)]) {
                [self.delegate commentCell:self clickFaceImage:_model.userId];
            }
        }];
        self.faceImage.placeholderImage = PLACEHOLDER;
        self.faceImage.layer.masksToBounds=YES;
        self.faceImage.layer.cornerRadius=self.faceImage.frame.size.height/2;
        [self.faceImage.layer setBorderWidth:1];
        [self.faceImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        
        self.faceImage.backgroundColor = [UIColor clearColor];
        self.faceImage.userInteractionEnabled = YES;
//        self.faceImage.image = [UIImage imageNamed:@"pengyouquan_comment_photo"];
        [self addSubview:self.faceImage];
         //*/
        
        self.nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(60, 5, 160, 30)];
        self.nameLabel.font = [UIFont fontWithName: @"Helvetica-Bold" size : 15.0f ];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = RGBCOLOR(50, 160, 245);
//        self.nameLabel.text = @"一只胡萝卜";
        [self addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 10, 60, 20)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.font = [UIFont systemFontOfSize:12.0f];
        self.timeLabel.textAlignment = UITextAlignmentRight;
        self.timeLabel.textColor = RGBCOLOR(134, 134, 134);
//        self.timeLabel.text = @"03-13";
        [self addSubview:self.timeLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 255, 60)];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:13.0f];
        self.contentLabel.textColor = RGBCOLOR(67, 67, 67);
//        self.contentLabel.text = @"家里的装修就是这种简约的风格,一直很喜欢,也很省成本呦。家里的装修就是这种简约的风格,一直很喜欢,也很省成本呦。";
        [self addSubview:self.contentLabel];
        
        CGSize size = CGSizeMake(255, 1000);
        CGSize labelSize = [self.contentLabel.text sizeWithFont:self.contentLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
        self.contentLabel.frame = CGRectMake(60, 35, labelSize.width, labelSize.height);
        
        self.lineImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.lineImage.image = [UIImage imageNamed:@"pengyouquan_fengexian"];
        [self addSubview:self.lineImage];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.lineImage.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
}
- (void)setModel:(BlogCommentModel *)model
{
    _model = model;
    
//    self.faceImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, model.userPhoto]];
    [self.faceImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, model.userPhoto]] forState:UIControlStateNormal placeholderImage:PLACEHOLDER];
    self.nameLabel.text = model.userName;
    self.timeLabel.text = [DateUtil timeFormatString:model.createdDate];
    self.contentLabel.text = model.content;
    
    //获得当前cell高度
    CGSize size = CGSizeMake(255, 1000);
    CGSize labelSize = [self.contentLabel.text sizeWithFont:self.contentLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    self.contentLabel.frame = CGRectMake(60, 35, labelSize.width, labelSize.height);
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+10);
}
-(void)clickButton:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(commentCell:clickFaceImage:)]) {
        [self.delegate commentCell:self clickFaceImage:_model.userId];
    }
}

-(void)setMessageModel:(MapActivityMessageModel *)messageModel
{
    
    [self.faceImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, messageModel.userPhote]] forState:UIControlStateNormal placeholderImage:PLACEHOLDER];
    self.nameLabel.text = messageModel.nickName;
//    self.timeLabel.text = [DateUtil timeFormatString:model.createdDate];
    self.contentLabel.text = messageModel.message;
//    self.nameLabel.text = messageModel.alias;
    
    CLLocation *toLocation = [[CLLocation alloc] initWithLatitude:[messageModel.latitude floatValue] longitude:[messageModel.longitude floatValue]];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:[messageModel.activityLatitude floatValue] longitude:[messageModel.activityLongitude floatValue]];
    CLLocationDistance distance = [currentLocation distanceFromLocation:toLocation];
    if(distance>1000){
        self.timeLabel.text = [NSString stringWithFormat:@"%.0f公里",distance/1000];
    }else{
        self.timeLabel.text = [NSString stringWithFormat:@"%.0f米",distance];
    }
    
    //获得当前cell高度
    CGSize size = CGSizeMake(255, 1000);
    CGSize labelSize = [self.contentLabel.text sizeWithFont:self.contentLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    self.contentLabel.frame = CGRectMake(60, 35, labelSize.width, labelSize.height);
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+5);
}
@end
