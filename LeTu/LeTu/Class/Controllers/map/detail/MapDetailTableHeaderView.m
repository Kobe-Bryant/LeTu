//
//  MapDetailTableHeaderView.m
//  LeTu
//
//  Created by DT on 14-5-22.
//
//

#import "MapDetailTableHeaderView.h"
#import "EGOImageView.h"

@interface MapDetailTableHeaderView()
@property(nonatomic,strong)UIImageView *headerImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *signatureLabel;
@property(nonatomic,strong)UIButton *userTypeButton;
@property(nonatomic,strong)UIButton *freeButton;
@end

@implementation MapDetailTableHeaderView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
        self.bgImageView.clipsToBounds = YES;
        self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.bgImageView.image = [UIImage imageNamed:@"loaction_item_bg"];
        [self addSubview:self.bgImageView];
        
        self.headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 80, 80)];
        
        self.headerImage.userInteractionEnabled = YES;
//        self.headerImage.image = [UIImage imageNamed:@"location_pic"];
        self.headerImage.clipsToBounds = YES;
        self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
        CALayer *layer = [self.headerImage layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:6.0];
        UITapGestureRecognizer *clickTapGR = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(clickTap:)];
        clickTapGR.numberOfTapsRequired = 1;
        [self.headerImage addGestureRecognizer:clickTapGR];//点击事件
        
        [self addSubview:self.headerImage];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90+10, 12, 200, 30)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.font = [UIFont systemFontOfSize:18.0f];
//        self.nameLabel.text = @"元芳的风";
        [self addSubview:self.nameLabel];
        
        self.signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(90+10, 45, 200, 20)];
        self.signatureLabel.backgroundColor = [UIColor clearColor];
        self.signatureLabel.textColor = [UIColor whiteColor];
        self.signatureLabel.font = [UIFont systemFontOfSize:14.0f];
//        self.signatureLabel.text = @"我们一起一起呵呵呵。。";
        [self addSubview:self.signatureLabel];
        
        self.userTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(90+10, 70, 50, 20)];
        self.userTypeButton.backgroundColor = [UIColor clearColor];
        [self.userTypeButton setImage:[UIImage imageNamed:@"location_driver"] forState:UIControlStateNormal];
        [self.userTypeButton setImage:[UIImage imageNamed:@"location_driver"] forState:UIControlStateHighlighted];
        [self.userTypeButton setTitle:@"车主" forState:UIControlStateNormal];
        [self.userTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.userTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        self.userTypeButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        self.userTypeButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
        [self addSubview:self.userTypeButton];
        
        /*
        self.freeButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 70, 50, 20)];
        self.freeButton.backgroundColor = [UIColor clearColor];
        [self.freeButton setImage:[UIImage imageNamed:@"location_coin"] forState:UIControlStateNormal];
        [self.freeButton setImage:[UIImage imageNamed:@"location_coin"] forState:UIControlStateHighlighted];
        [self.freeButton setTitle:@"付费" forState:UIControlStateNormal];
        [self.freeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.freeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        self.freeButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        self.freeButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
         [self addSubview:self.freeButton];
         //*/
        
        /*
        self.collectButton = [[UIButton alloc] initWithFrame:CGRectMake(245, 55, 56, 26)];
        [self.collectButton setImage:[UIImage imageNamed:@"collection_btn_normal"] forState:UIControlStateNormal];
        [self.collectButton setImage:[UIImage imageNamed:@"collection_btn_press"] forState:UIControlStateHighlighted];
        [self.collectButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        self.collectButton.hidden = YES;
        [self addSubview:self.collectButton];
         //*/
    }
    return self;
}
-(void)clickButton:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(mapDetailHeaderView:didClickAtIndex:)]) {
        [self.delegate mapDetailHeaderView:self didClickAtIndex:2];
    }
}
/*
- (void)drawRect:(CGRect)rect
{
    UIImage *backgroundImage = [UIImage imageNamed:@"loaction_item_bg"];
    [backgroundImage drawInRect:rect];
}
 //*/

- (void)setModel:(MapCarSharingModel *)model
{
//    self.headerImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,model.userPhoto]];
    [self.headerImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,model.userPhoto]] placeholderImage:PLACEHOLDER];
    self.nameLabel.text = model.userName;
    self.signatureLabel.text = model.userSign;
    if ([model.userType intValue] == 1) {
        [self.userTypeButton setImage:[UIImage imageNamed:@"location_driver"] forState:UIControlStateNormal];
        [self.userTypeButton setImage:[UIImage imageNamed:@"location_driver"] forState:UIControlStateHighlighted];
        [self.userTypeButton setTitle:@"车主" forState:UIControlStateNormal];
    }else if ([model.userType intValue] == 2){
        [self.userTypeButton setImage:[UIImage imageNamed:@"location_passenger"] forState:UIControlStateNormal];
        [self.userTypeButton setImage:[UIImage imageNamed:@"location_passenger"] forState:UIControlStateHighlighted];
        [self.userTypeButton setTitle:@"乘客" forState:UIControlStateNormal];
    }
}

//点击事件
-(void)clickTap:(UITapGestureRecognizer*)recognizer
{
    if ([self.delegate respondsToSelector:@selector(mapDetailHeaderView:didClickAtIndex:)]) {
        [self.delegate mapDetailHeaderView:self didClickAtIndex:1];
    }
}

@end
