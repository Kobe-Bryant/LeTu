//
//  MapActivityCell.m
//  LeTu
//
//  Created by DT on 14-6-13.
//
//

#import "MapActivityCell.h"

@interface MapActivityCell()
@property(nonatomic,strong)UIImageView *activityImage;
@property(nonatomic,strong)UILabel *activityTitle;
@property(nonatomic,strong)UILabel *activityTime;
@property(nonatomic,strong)UILabel *activityContent;
@property(nonatomic,strong)UIImageView *tagImage;
@property(nonatomic,strong)UIButton *updateButton;
@property(nonatomic,strong)UIButton *deleteButton;
@end

@implementation MapActivityCell
@synthesize isMyActivity = _isMyActivity;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.activityImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 116, 116)];
        self.activityImage.image = PLACEHOLDER;
        [self addSubview:self.activityImage];
        
        self.activityTitle = [[UILabel alloc] initWithFrame:CGRectMake(125, 5, 186, 25)];
        self.activityTitle.backgroundColor = [UIColor clearColor];
        self.activityTitle.font = [UIFont systemFontOfSize:16.0f];
        self.activityTitle.text = @"法国爵士音乐鬼才三重奏";
        [self addSubview:self.activityTitle];
        
        self.activityTime = [[UILabel alloc] initWithFrame:CGRectMake(125, 30, 186, 20)];
        self.activityTime.backgroundColor = [UIColor clearColor];
        self.activityTime.font = [UIFont systemFontOfSize:14.0f];
        self.activityTime.textColor = [UIColor grayColor];
        self.activityTime.text = @"06-08 周日 20:30-21:30";
        [self addSubview:self.activityTime];
        
        self.activityContent = [[UILabel alloc] initWithFrame:CGRectMake(125, 50, 186, 40)];
        self.activityContent.backgroundColor = [UIColor clearColor];
        self.activityContent.font = [UIFont systemFontOfSize:14.0f];
        self.activityContent.textColor = [UIColor grayColor];
        self.activityContent.numberOfLines = 2;
        self.activityContent.text = @"法国爵士音乐鬼才三重奏.法国爵士音乐鬼才三重奏.法国爵士音乐鬼才三重奏.";
        [self addSubview:self.activityContent];
        
        self.tagImage = [[UIImageView alloc] initWithFrame:CGRectMake(125, 90, 28, 14)];
        self.tagImage.image = [UIImage imageNamed:@"activity_hot"];
        self.tagImage.hidden = YES;
        [self addSubview:self.tagImage];
        
        self.updateButton = [[UIButton alloc] initWithFrame:CGRectMake(255, 85, 25, 25)];
        [self.updateButton setImage:[UIImage imageNamed:@"Creatingevents_btn_edit_normal"] forState:UIControlStateNormal];
        [self.updateButton setImage:[UIImage imageNamed:@"Creatingevents_btn_edit_press"] forState:UIControlStateHighlighted];
        self.updateButton.tag = 1;
        [self.updateButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.updateButton];
        
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(285, 85, 25, 25)];
        [self.deleteButton setImage:[UIImage imageNamed:@"Creatingevents_btn_delete_normal"] forState:UIControlStateNormal];
        [self.deleteButton setImage:[UIImage imageNamed:@"Creatingevents_btn_delete_press"] forState:UIControlStateHighlighted];
        self.deleteButton.tag = 2;
        [self.deleteButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(void)drawRect:(CGRect)rect
{
    UIImage *backgroundImage = [UIImage imageNamed:@"activity_everyone_bg"];
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
}

-(void)setModel:(MapActivityModel *)model
{
    self.activityTime.text = [model.startTime substringToIndex:[model.startTime length]-3];
    self.activityTitle.text = model.subject;
    self.activityContent.text = model.address;
    [self.activityImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL,model.logPath]] placeholderImage:PLACEHOLDER];
}
-(void)setIsMyActivity:(BOOL)isMyActivity
{
    _isMyActivity = isMyActivity;
    if (_isMyActivity) {
        self.updateButton.hidden = YES;
        self.deleteButton.hidden = NO;
    }else {
        self.updateButton.hidden = YES;
        self.deleteButton.hidden = YES;
    }
}
-(void)clickButton:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(activityCell:clickButtonAtIndex:)]) {
        [self.delegate activityCell:self clickButtonAtIndex:button.tag];
    }
}
@end
