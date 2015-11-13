//
//  modifyPersonCell.m
//  LeTu
//
//  Created by mafeng on 14-9-18.
//
//

#import "modifyPersonCell.h"

@implementation modifyPersonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UILabel* avatorlabel =[[UILabel alloc]init];
        avatorlabel.frame = CGRectMake(15.0, 15.0, 50.0, 30.0);
        avatorlabel.font =[UIFont systemFontOfSize:15];
        avatorlabel.textColor = RGBCOLOR(54.0, 54.0, 54.0);
        avatorlabel.text = @"头像";
        [self.contentView addSubview:avatorlabel];
        
        UILabel* signlabel =[[UILabel alloc]init];
        signlabel.frame = CGRectMake(15.0, 15.0, 50.0, 30.0);
        signlabel.font =[UIFont systemFontOfSize:15];
        signlabel.textColor = RGBCOLOR(54.0, 54.0, 54.0);
        signlabel.text = @"个性签名";
        [self.contentView addSubview:signlabel];
        
        UILabel* nicknamelabel =[[UILabel alloc]init];
        nicknamelabel.frame = CGRectMake(15.0, 15.0, 50.0, 30.0);
        nicknamelabel.font =[UIFont systemFontOfSize:15];
        nicknamelabel.textColor = RGBCOLOR(54.0, 54.0, 54.0);
        nicknamelabel.text = @"昵称";
        [self.contentView addSubview:nicknamelabel];
        
        UILabel* sexlabel =[[UILabel alloc]init];
        sexlabel.frame = CGRectMake(15.0, 15.0, 50.0, 30.0);
        sexlabel.font =[UIFont systemFontOfSize:15];
        sexlabel.textColor = RGBCOLOR(54.0, 54.0, 54.0);
        sexlabel.text = @"性别";
        [self.contentView addSubview:sexlabel];
        
        
        self.avatorImageView = [[UIImageView alloc]init];
        self.avatorImageView.frame = CGRectMake(250.0, 5.0, 46.0, 46.0);
        [self.contentView addSubview:self.avatorImageView];
        
        
        UIImage* arrImage = [UIImage imageNamed:@"me_headphoto_copy_icon"];
        self.arrorImageView = [[UIImageView alloc]init];
        self.arrorImageView.frame = CGRectMake(300.0, 10.0,arrImage.size.width , arrImage.size.height);
        self.arrorImageView.image = arrImage;
        [self.contentView addSubview:self.arrorImageView];
        
        
        self.detailLabel = [[UILabel alloc]init];
        self.detailLabel.frame = CGRectMake(100.0, 10.0, 50.0, 30.0);
        self.detailLabel.textColor = RGBCOLOR(160.0, 160.0, 160.0);
        self.detailLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.detailLabel];
        
        
        
        
        
    }
    return self;
}
- (void)setcellInfomation:(UserModel*)model
{
  //读接口。
    
    




}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
