//
//  CarInfomationCell.m
//  LeTu
//
//  Created by mafeng on 14-9-26.
//
//

#import "CarInfomationCell.h"

@implementation CarInfomationCell
@synthesize carImageView,carNameLabel,titlelabel,arrowImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.titlelabel = [[UILabel alloc]init];
        self.titlelabel.frame = CGRectMake(15.0, 10.0, 100, 20);
        self.titlelabel.font = [UIFont systemFontOfSize:17];
        self.titlelabel.textColor = RGBCOLOR(54, 54, 54);
        [self.contentView addSubview:self.titlelabel];
        
        
        self.carImageView = [[UIImageView alloc]init];
        self.carImageView.frame = CGRectMake(0.0, 0.0, 30.0, 30.0);
        [self.contentView addSubview:self.carImageView];
        
        
        self.carNameLabel = [[UILabel alloc]init];
        self.carNameLabel.frame = CGRectMake(0.0, 0.0, 100, 20.0);
        self.carNameLabel.font = [UIFont systemFontOfSize:17.0];
        self.carNameLabel.textColor = RGBCOLOR(160.0, 160.0, 160.0);
        [self.contentView addSubview:self.carNameLabel];
        
        
        self.arrowImageView = [[UIImageView alloc]init];
        self.arrowImageView.frame = CGRectMake(0.0, 0.0, 30.0, 30.0);
        [self.contentView addSubview:self.arrowImageView];
    }
    return self;
}
- (void)setcellInfomation:(NSString*)carnameWidth carlogo:(NSString*)carlogo
{

    if (carnameWidth && carlogo)
    {
        
        UIImage* arrImage = [UIImage imageNamed:@"me_headphoto_copy_icon"];
        self.arrowImageView.frame = CGRectMake(296.0, 15, arrImage.size.width, arrImage.size.height);
        self.arrowImageView.image =arrImage;
        CGSize size = [carnameWidth sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)];
        NSLog(@"%f",size.width);
        
        self.carNameLabel.frame = CGRectMake(296.0 - size.width-5, 12.0, size.width, 20);
        self.carNameLabel.text = carnameWidth;
        NSString* string = [NSString stringWithFormat:@"%@%@",SERVERimageURL,carlogo];
        self.carImageView.frame = CGRectMake(296.0 - size.width-5 -30.0, (self.frame.size.height - 30)/2.0, 30, 30);
        [self.carImageView setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
        
        
    }
}

@end
