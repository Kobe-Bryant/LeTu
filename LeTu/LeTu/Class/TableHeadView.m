//
//  TableHeadView.m
//  LeTu
//
//  Created by mafeng on 14-9-18.
//
//

#import "TableHeadView.h"
#import "UserDetailModel.h"



@implementation TableHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UIImage* leftImage = [UIImage imageNamed:@"meBtReturn.png"];
        UIImage* rightImage = [UIImage imageNamed:@"meBtModify.png"];
        UIImage* avatorImage = [UIImage imageNamed:@"meDefaultPhoto60x60.png"];
        UIImage* manImage = [UIImage imageNamed:@"meIconBoyBlue.png"];
        UIImage* womanImage = [UIImage imageNamed:@"meIconGirlRed.png"];
        
        self.leftBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBackButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 38,leftImage.size.width,leftImage.size.height)];
        self.leftBackButton.backgroundColor = [UIColor clearColor];
        self.leftBackButton.tag = 1;
        [self.leftBackButton setImage:leftImage forState:UIControlStateNormal];
        [self.leftBackButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.leftBackButton];
        
        NSLog(@"%f",self.frame.size.width);
        
        self.rightEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightEditButton = [[UIButton alloc] initWithFrame:CGRectMake(320.0-8-rightImage.size.width, 38,rightImage.size.width,rightImage.size.height)];
        self.rightEditButton.backgroundColor = [UIColor clearColor];
        self.rightEditButton.tag = 2;
        [self.rightEditButton setImage:rightImage forState:UIControlStateNormal];
        [self.rightEditButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightEditButton];
        
        
        UIImage* defaultImage = [UIImage imageNamed:@"meDefaultPhoto60x60.png"];
         self.avatorButton = [[UIButton alloc] initWithFrame:CGRectMake((320.0-defaultImage.size.width)/2.0, 26, 50, 50)];
        [self.avatorButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        self.avatorButton.userInteractionEnabled = YES;
        [self.avatorButton setImage:defaultImage forState:UIControlStateNormal];
        self.avatorButton.layer.masksToBounds = NO;
        self.avatorButton.clipsToBounds = YES;
        self.avatorButton.layer.cornerRadius =25.0;
        [self addSubview:self.avatorButton];
        
        
        self.nickNameLabel = [[UILabel alloc]init];
        self.nickNameLabel.frame = CGRectMake(55.0, CGRectGetMaxY(self.avatorButton.frame)+13, 200, 20);
        self.nickNameLabel.textAlignment = NSTextAlignmentCenter;
        self.nickNameLabel.font = [UIFont systemFontOfSize:13.0];
        self.nickNameLabel.textColor =[UIColor whiteColor];
        [self addSubview:self.nickNameLabel];
        
        
        self.genderImageView = [[UIImageView alloc]init];
        self.genderImageView.frame = CGRectMake(120, CGRectGetMaxY(self.nickNameLabel.frame)+9, manImage.size.width, manImage.size.height);
        [self addSubview:self.genderImageView];
        
        self.ageLabel = [[UILabel alloc]init];
        self.ageLabel.frame = CGRectMake(CGRectGetMaxX(self.genderImageView.frame)+5,CGRectGetMinY(self.genderImageView.frame) -5.0, 50.0, 20.0);
        self.ageLabel.font = [UIFont systemFontOfSize:13.0];
        self.ageLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.ageLabel];
        
        self.typeLabel = [[UILabel alloc]init];
        self.typeLabel.frame = CGRectMake(CGRectGetMaxX(self.ageLabel.frame)-30.0,CGRectGetMinY(self.genderImageView.frame) -5.0, 100.0, 20.0);
        self.typeLabel.font = [UIFont systemFontOfSize:13.0];
        self.typeLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.typeLabel];
    }
    return self;
}
- (void)setBackGroundImage:(UIImage*)backImage
{
        
     self.backgroundColor = [UIColor colorWithPatternImage:backImage];
        
 }

- (void)setInfomation:(UserDetailModel*)model
{
  //复制
    
    
    
    NSString* imageUrl = [NSString stringWithFormat:@"%@%@",SERVERimageURL,model.userPhoto];
    [self.avatorButton setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:PLACEHOLDER];
    self.nickNameLabel.text = model.fullName;
    UIImage* manImage = [UIImage imageNamed:@"meIconBoyBlue.png"];
    UIImage* womanImage = [UIImage imageNamed:@"meIconGirlRed.png"];
    if (model.gender==1) {
        
        self.genderImageView.image = manImage;

    }else {
    
        self.genderImageView.image = womanImage;

    }
    NSString* age = [[NSNumber numberWithInteger:model.age] stringValue];
    
    self.ageLabel.text = age;

    NSString* constellation =@"";
    
    switch (model.constellation) {
        case 1:
        constellation= @"双鱼座";
        break;
        case 2:
            constellation= @"白羊座";
    
            break;
        case 3:
            constellation= @"金牛座";
   
            break;
        case 4:
            constellation= @"双子座";
   
            break;
        case 5:
            constellation= @"巨蟹座";
  
            break;
        case 6:
            constellation= @"狮子座";
 
            break;
        case 7:
            constellation= @"处女座";
 
            break;
        case 8:
            constellation= @"天秤座";
  
            break;
        case 9:
            constellation= @"天蝎座";
 
            break;
        case 10:
            constellation= @"射手座";

            break;
        case 11:
            constellation= @"水瓶座";

            break;
        case 12:
            constellation= @"摩蝎座";

            break;
        default:
            break;
    }
    
    self.typeLabel.text = constellation;
    
    
    
}

- (void)clickButton:(UIButton*)bt
{
 
    if (self.headDelegate &&[self.headDelegate respondsToSelector:@selector(clickAvatorButton:)]) {
        
        [self.headDelegate clickAvatorButton:bt.tag];
    }
}

@end
