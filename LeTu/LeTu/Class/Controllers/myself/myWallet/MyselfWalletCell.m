//
//  MyselfWalletCell.m
//  LeTu
//
//  Created by DT on 14-5-20.
//
//

#import "MyselfWalletCell.h"

@interface MyselfWalletCell()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *mobileLabel;
@property(nonatomic,strong)UIImageView *lineImage;
@end

@implementation MyselfWalletCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 25)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        self.titleLabel.text = @"收到红包";
        [self addSubview:self.titleLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 100, 20)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.font = [UIFont systemFontOfSize:14.0f];
        self.timeLabel.textColor = [UIColor grayColor];
        self.timeLabel.text = @"11-29 14:25";
        [self addSubview:self.timeLabel];
        
        self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 5, 100, 25)];
        self.moneyLabel.backgroundColor = [UIColor clearColor];
        self.moneyLabel.font = [UIFont systemFontOfSize:18.0f];
        self.moneyLabel.textColor = RGBCOLOR(15, 84, 150);
        self.moneyLabel.textAlignment = UITextAlignmentRight;
        self.moneyLabel.text = @"+105";
        [self addSubview:self.moneyLabel];
        
        self.mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 35, 75, 20)];
        self.mobileLabel.backgroundColor = [UIColor clearColor];
        self.mobileLabel.font = [UIFont systemFontOfSize:14.0f];
        self.mobileLabel.textColor = [UIColor grayColor];
        self.mobileLabel.textAlignment = UITextAlignmentRight;
        self.mobileLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.mobileLabel.text = @"15012345678";
        [self addSubview:self.mobileLabel];
        
        self.lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 61, 310, 1)];
        self.lineImage.image = [UIImage imageNamed:@"posting_line"];
        self.lineImage.alpha = 0.8;
        [self addSubview:self.lineImage];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
