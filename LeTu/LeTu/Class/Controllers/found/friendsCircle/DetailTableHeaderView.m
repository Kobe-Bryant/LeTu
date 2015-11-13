//
//  DetailTableHeaderView.m
//  LeTu
//
//  Created by DT on 14-5-14.
//
//

#import "DetailTableHeaderView.h"
#import "FriendsCirclePhotoView.h"

@interface DetailTableHeaderView()
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)UILabel *contentLabel;
@property(nonatomic,strong)FriendsCirclePhotoView *photosView;

@end

@implementation DetailTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /*
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 180, 20)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = @"新挑选的家具摆设";
        self.titleLabel.font = [UIFont fontWithName: @"Helvetica-Bold" size : 16.0f ];
        [self addSubview:self.titleLabel];
         //*/
        
        self.heartButton = [DTButton buttonWithType:UIButtonTypeCustom];
        self.heartButton.backgroundColor = [UIColor clearColor];
        self.heartButton.frame = CGRectMake(220, 10, 50, 20);
        self.heartButton.titleLabel.font =[UIFont systemFontOfSize:12.0f];
        [self.heartButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.heartButton setTitle:@"4554" forState:UIControlStateNormal];
        self.heartButton.titleEdgeInsets = UIEdgeInsetsMake(2, 5, 0, 0);
        self.heartButton.normalImage = [UIImage imageNamed:@"friendscircle_others_dialogbox_heart_normal"];
        self.heartButton.pressImage = [UIImage imageNamed:@"friendscircle_others_dialogbox_heart_current"];
        self.heartButton.isSelect = NO;
        self.heartButton.tag=1;
        [self.heartButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.heartButton];
        
        self.bubbleButton = [DTButton buttonWithType:UIButtonTypeCustom];
        self.bubbleButton.backgroundColor = [UIColor clearColor];
        self.bubbleButton.frame = CGRectMake(270, 10, 50, 20);
        self.bubbleButton.titleLabel.font =[UIFont systemFontOfSize:12.0f];
        [self.bubbleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.bubbleButton setTitle:@"44" forState:UIControlStateNormal];
        self.bubbleButton.titleEdgeInsets = UIEdgeInsetsMake(2, 5, 0, 0);
        self.bubbleButton.normalImage = [UIImage imageNamed:@"friendscircle_others_dialogbox_bubble_normal"];
        self.bubbleButton.pressImage = [UIImage imageNamed:@"friendscircle_others_dialogbox_bubble_current"];
        self.bubbleButton.isSelect = NO;
        self.bubbleButton.tag=2;
        [self.bubbleButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bubbleButton];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 180, 20)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.text = @"小美   2014-05-12 12:22";
        self.nameLabel.textColor = [UIColor grayColor];
        self.nameLabel.font = [UIFont fontWithName: @"Helvetica" size : 13.0f ];
        [self addSubview:self.nameLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, 280, 20)];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.text = @"广州塔位于广州市中心，城市新中轴线与珠江景观轴交汇处， 与海心沙岛和广州市21世纪CBD区珠江新城隔江相望，是中国第一高塔，世界第三高塔。";
        self.contentLabel.textColor = [UIColor blackColor];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont fontWithName: @"Helvetica" size : 15.0f ];
        [self addSubview:self.contentLabel];
        
        self.photosView  = [[FriendsCirclePhotoView alloc] initWithFrame:CGRectZero width:292];
        self.photosView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.photosView];

    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
//    UIImage *biaozhu = [UIImage imageNamed:@"pengyouquan_content_biaozhu"];
//    [biaozhu drawInRect:CGRectMake(14, 11, 2, 14)];
    UIImage *fengexian = [UIImage imageNamed:@"pengyouquan_comment_fengexian"];
    [fengexian drawInRect:CGRectMake(0, rect.size.height-3, rect.size.width, 3)];
}
/**
 *  按钮点击事件
 *
 *  @param button UIButton
 */
- (void)clickButton:(DTButton*)button
{
    if (button.tag ==1) {//赞按钮
        button.isSelect = ![button isSelect];
        if ([self.delegate respondsToSelector:@selector(tableHeaderView:button:didClickAtIndex:)]) {
            [self.delegate tableHeaderView:self button:button didClickAtIndex:1];
        }
    }else if (button.tag == 2){//评论按钮
        if ([self.delegate respondsToSelector:@selector(tableHeaderView:button:didClickAtIndex:)]) {
            [self.delegate tableHeaderView:self button:button didClickAtIndex:2];
        }
    }
}
- (void)setIsAuto:(BOOL)isAuto
{
    if (isAuto) {
        CGSize size = CGSizeMake(280, 1000);
        CGSize labelSize = [self.contentLabel.text sizeWithFont:self.contentLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
        self.contentLabel.frame = CGRectMake(20, 35, labelSize.width, labelSize.height);
        
        self.photosView.frame = CGRectMake(14, labelSize.height+40, 292, self.photosView.height);
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.photosView.frame.origin.y+self.photosView.frame.size.height+5);
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
    self.nameLabel.text = [model.userName stringByAppendingFormat:@"    %@",[model.createdDate substringToIndex:[model.createdDate length]-3]];
    
    for (UIView *view in [self.photosView subviews]) {
        [view removeFromSuperview];
    }
    
    if ([model.imagesArray count]>=1) {
        self.photosView.photoArray = model.imagesArray;
    }
}
@end
