//
//  MySelfPhotoCell.m
//  LeTu
//
//  Created by mafeng on 14-9-23.
//
//

#import "MySelfPhotoCell.h"


@implementation MySelfPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.titlelabel = [[UILabel alloc]init];
        self.titlelabel.frame = CGRectMake(15.0, 15.0, 60.0, 20.0);
        self.titlelabel.font = [UIFont systemFontOfSize:15];
        self.titlelabel.text = @"头像";
        [self.contentView addSubview:self.titlelabel];
        
        
        UIImage* image = [UIImage imageNamed:@"meDefaultPhoto60x60.png"];
        self.avatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.avatorButton.frame = CGRectMake(230.0, (self.frame.size.height - image.size.height)/2.0, 50.0, 50.0);
        [self.avatorButton setImage:image forState:UIControlStateNormal];
        self.avatorButton.userInteractionEnabled = YES;
        self.avatorButton.layer.masksToBounds = NO;
        self.avatorButton.clipsToBounds = YES;
        self.avatorButton.layer.cornerRadius = 25.0;
        [self.contentView addSubview:self.avatorButton];
    
        UIImage* arrImage = [UIImage imageNamed:@"me_headphoto_copy_icon"];
        self.arrowImageView = [[UIImageView alloc]init];
        self.arrowImageView.frame = CGRectMake(CGRectGetMaxX(self.avatorButton.frame), (self.frame.size.height -arrImage.size.height)/2.0, arrImage.size.width, arrImage.size.height);
        self.arrowImageView.image = arrImage;
        [self.contentView addSubview:self.arrowImageView];
        
        
    
    }
    return self;
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
