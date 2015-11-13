//
//  MyselfSignedCell.m
//  LeTu
//
//  Created by DT on 14-5-21.
//
//

#import "MyselfSignedCell.h"
#import "MyselfApplysModel.h"

@interface MyselfSignedCell()
@property(nonatomic,strong)NSMutableArray *applysInfoArray;
@property(nonatomic,strong)NSMutableArray *applsArray;
@property(nonatomic,strong)UIImageView *timeImage;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIImageView *startBackground;
@property(nonatomic,strong)UIImageView *startImage;
@property(nonatomic,strong)UILabel *startLabel;
@property(nonatomic,strong)UIImageView *endBackground;
@property(nonatomic,strong)UIImageView *endImage;
@property(nonatomic,strong)UILabel *endLabel;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation MyselfSignedCell
@synthesize type = _type;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.applsArray = [[NSMutableArray alloc] init];
        self.applysInfoArray = [[NSMutableArray alloc] init];
        
        self.timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 12, 12)];
        self.timeImage.image = [UIImage imageNamed:@"signed_time_icon"];
        [self addSubview:self.timeImage];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 6, 200, 14)];
        self.timeLabel.textColor = RGBCOLOR(50, 158, 241);
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.font = [UIFont systemFontOfSize:13.0f];
//        self.timeLabel.text = @"2014-04-055 12:23";
        [self addSubview:self.timeLabel];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(32, 30, 256, 45)];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.contentSize = CGSizeMake(256*2, 45);
        [self addSubview:self.scrollView];

        self.startBackground = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30+45, 300, 36)];
//        self.startBackground.image = [UIImage imageNamed:@"signed_blank_bg"];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        self.startBackground.tag = 100;
        self.startBackground.userInteractionEnabled = YES;
        [self.startBackground addGestureRecognizer:gesture];
        [self addSubview:self.startBackground];
        
        self.startImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 20, 30)];
        self.startImage.image = [UIImage imageNamed:@"signed_start_icon"];
        [self.startBackground addSubview:self.startImage];
        
        self.startLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 3, 255, 30)];
        self.startLabel.backgroundColor = [UIColor clearColor];
        self.startLabel.font = [UIFont systemFontOfSize:15.0f];
//        self.startLabel.text = @"广州市广东软件园彩频路110号";
        [self.startBackground addSubview:self.startLabel];
        
        self.endBackground = [[UIImageView alloc] initWithFrame:CGRectMake(10, 73+37, 300, 36)];
//        self.endBackground.image = [UIImage imageNamed:@"signed_blank_bg"];
        UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        self.endBackground.tag = 101;
        self.endBackground.userInteractionEnabled = YES;
        [self.endBackground addGestureRecognizer:gesture1];
        [self addSubview:self.endBackground];
        
        self.endImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 20, 30)];
        self.endImage.image = [UIImage imageNamed:@"signed_end_icon"];
        [self.endBackground addSubview:self.endImage];
        
        self.endLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 3, 255, 30)];
        self.endLabel.backgroundColor = [UIColor clearColor];
        self.endLabel.font = [UIFont systemFontOfSize:15.0f];
//        self.endLabel.text = @"深圳市没林路科学大道22号";
        [self.endBackground addSubview:self.endLabel];
        
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(106, 118+32, 108, 27)];
//        [self.button setImage:[UIImage imageNamed:@"signed_getcar_btn_normal"] forState:UIControlStateNormal];
//        [self.button setImage:[UIImage imageNamed:@"signed_getcar_btn_press"] forState:UIControlStateHighlighted];
         self.button.tag = 888;
        [self.button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(285, 118+32, 25, 25)];
        [self.deleteButton setImage:[UIImage imageNamed:@"Creatingevents_btn_delete_normal"] forState:UIControlStateNormal];
        [self.deleteButton setImage:[UIImage imageNamed:@"Creatingevents_btn_delete_press"] forState:UIControlStateHighlighted];
        self.deleteButton.tag = 222;
        [self.deleteButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteButton.hidden = YES;
        [self addSubview:self.deleteButton];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
- (void)drawRect:(CGRect)rect
{
    UIImage *backgroundImage = [UIImage imageNamed:@"signed_bg"];
    [backgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*0.94)];
}

- (void)setType:(int)type
{
    _type = type;
    self.button.enabled = YES;
    [self.button setImage:nil forState:UIControlStateNormal];
    if (_type==-1) {
        self.button.enabled = NO;
        [self.button setImage:[UIImage imageNamed:@"signed_cancel_btn_normal"] forState:UIControlStateNormal];
    }else if (_type==1) {
        [self.button setImage:[UIImage imageNamed:@"signed_getcar_btn_normal"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"signed_getcar_btn_press"] forState:UIControlStateHighlighted];
    }else if (_type==12){
        [self.button setImage:[UIImage imageNamed:@"signed_pay_btn_normal"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"signed_pay_btn_press"] forState:UIControlStateHighlighted];
    }else if (_type==3 || _type==2){
//        [self.button setImage:[UIImage imageNamed:@"signed_complet_btn_normal"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"signed_complet_btn_press"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"signed_complet_btn_press"] forState:UIControlStateHighlighted];
    }
}
- (void)layoutSubviews
{
    self.backgroundColor = [UIColor clearColor];
}
/**
 *  按钮事件
 *
 *  @param button
 */
- (void)clickButton:(UIButton*)button
{
    if (button.tag == 888) {
        if ([self.delegate respondsToSelector:@selector(signedCellClickToButton:)]) {
            [self.delegate signedCellClickToButton:self];
        }
//        if ([self type] ==1) {
//            self.type = 3;
//        }
        
    }else if (button.tag==222) {
        if ([self.delegate respondsToSelector:@selector(myselfSignedCell:ClickToAddressAtIndex:)]) {
            [self.delegate myselfSignedCell:self ClickToAddressAtIndex:222];
        }
        
    }else {
        MyselfApplysModel *model = [self.applysInfoArray objectAtIndex:button.tag];
        if ([self.delegate respondsToSelector:@selector(signedCellClickToButton:userName:userId:)]) {
            [self.delegate signedCellClickToButton:self userName:model.userName userId:model.userId];
        }
    }
}
- (void)setModel:(MapMyselfSignedModel *)model
{
    self.timeLabel.text = [model.startTime substringToIndex:[model.startTime length]-3];
    self.startLabel.text = model.routeStart;
    self.endLabel.text = model.routeEnd;
    self.type = [model.status intValue];
    
    self.scrollView.frame = CGRectMake(32, 25, 256, 0);
    if ([model.applys count]>0) {
        self.applysInfoArray = model.applys;
        [self initScrollView:model.applys];
        self.scrollView.frame = CGRectMake(32, 25, 256, 45);
    }
}
-(void)initScrollView:(NSMutableArray *)array
{
    float rows = (float)[array count]/5;
    int row = ceil(rows);
    self.scrollView.contentSize=CGSizeMake(256*row,45);
    for (UIButton *button in self.applsArray) {
        [button removeFromSuperview];
    }
    UIButton *button = nil;
    
    for (int i=0; i<[array count]; i++) {
        MyselfApplysModel *model = [array objectAtIndex:i];
        button = [[UIButton alloc] initWithFrame:CGRectMake(40*i+12*i, 0, 40, 40)];
        button.backgroundColor = [UIColor clearColor];
        [button setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, model.userPhoto] ] forState:UIControlStateNormal placeholderImage:PLACEHOLDER];
        button.tag = i;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [self.applsArray addObject:button];
    }
}
- (void)tapHandle:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(myselfSignedCell:ClickToAddressAtIndex:)]) {
        [self.delegate myselfSignedCell:self ClickToAddressAtIndex:tap.view.tag];
    }
}
@end
