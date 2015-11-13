//
//  CarTypeCell.m
//  LeTu
//
//  Created by mafeng on 14-9-25.
//
//

#import "CarTypeCell.h"
#import "CarButton.h"
#import "BrandCar.h"


@interface CarTypeCell()
@property(nonatomic,assign) BOOL isViewWillAppear;



@end

@implementation CarTypeCell
@synthesize carImageButton,lineheadImageView,linebottomImageView,englishLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
        
        NSLog(@"%@",NSStringFromCGRect(self.frame));
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.contentView.frame = CGRectMake(15.0, 10.0, 290.0,self.frame.size.height);
        self.contentView.backgroundColor = RGBCOLOR(238.0, 238.0, 238.0);
        
        self.lineheadImageView = [[UIImageView alloc]init];
        self.lineheadImageView.frame = CGRectMake(0.0, 0.0, 290.0, 1);
        self.lineheadImageView.backgroundColor = RGBCOLOR(126.0, 204, 200);
        [self.contentView addSubview:self.lineheadImageView];
        
        
        self.englishLabel = [[UILabel alloc]init];
        self.englishLabel.frame = CGRectMake(5.0, 4.0, 10, 10);
        self.englishLabel.font = [UIFont systemFontOfSize:15.0];
        self.englishLabel.textColor = RGBCOLOR(54.0, 54.0, 54.0);
        [self.contentView addSubview:self.englishLabel];
        
    }
    return self;
}
- (UIButton*)createButton
{
    UIButton* bt = [CarButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0.0, 0.0, 66.0, 66.0);
    return bt;
}
- (void)setCellInfomation:(NSArray*)array title:(NSString*)title
{
  
   
    self.englishLabel.text = title;
    CGFloat orginX = 0.0;
    CGFloat orginY = 18.0;
    CGFloat spaceX = 6.0;
    CGFloat heightY = 6.0;
    NSInteger m = 0.0;
    NSInteger row = 1;
    
    for (int i = 0; i < array.count; i++) {
        BrandCar* car =(BrandCar*)[array objectAtIndex:i];
        
        if (i /4==1 && i%4==0) {
            m =0;
            row = 2;
        } else if (i/4==2 && i%4==0){
            m=0;
            row = 3;
        }else if (i/4==3 && i%4==0){
            m=0;
            row =4;
        }
        
        self.carButton = [CarButton buttonWithType:UIButtonTypeCustom];
        self.carButton.frame =CGRectMake(orginX+66*m+spaceX*m, orginY+(row-1)*heightY+66*(row-1), 66.0, 66.0);
        NSLog(@"%@",NSStringFromCGRect(self.carButton.frame));
        
        
        self.carButton.backgroundColor = [UIColor whiteColor];
        self.carButton.layer.borderWidth = 2.0;
        self.carButton.layer.borderColor =  RGBCOLOR(238.0, 238.0, 238.0).CGColor;
        [self.carButton addTarget:self action:@selector(clickChoseButton:) forControlEvents:UIControlEventTouchUpInside];
        self.carButton.brandCar =car;

        [self.contentView addSubview:self.carButton];
        
        
        UIButton* button = (CarButton*)[self createButton];
        button .frame = CGRectMake(12.0,5.0, 40.0, 40.0);
        NSString* string = [NSString stringWithFormat:@"%@%@",SERVERimageURL,car.carlogo];
        
        [button setImageWithURL:[NSURL URLWithString:string] forState:UIControlStateNormal placeholderImage:nil];
        [self.carButton addSubview:button];
        
        UILabel* carnameLabel = [[UILabel alloc]init];
        carnameLabel.frame = CGRectMake(0.0, CGRectGetMaxY(button.frame), 62, 20);
        carnameLabel.font = [UIFont systemFontOfSize:8.0];
        carnameLabel.textColor = RGBCOLOR(54, 54, 54);
        carnameLabel.textAlignment = NSTextAlignmentCenter;
        carnameLabel.text = car.carname;
        [self.carButton addSubview:carnameLabel];
        m++;
      
    }
}

- (void)clickChoseButton:(CarButton*)bt
{
    if (self.carDelegate && [self.carDelegate respondsToSelector:@selector(clickCar:)]) {
        
        [self.carDelegate clickCar:bt.brandCar];
    }
}

+ (CGFloat)getCellHeight:(NSArray*)array
{
    
    NSLog(@"%d",array.count);
    
    if (array.count<4) {
        return 100.0;
        
    }
    
    
    CGFloat x = (CGFloat)array.count/4;
    if (array.count % 4 ==0 && x==1) {
        
        return 100.0;
        
    }else if (x >1.0 && x <=2.0)
    {
        return 66*2+20+12+20-6;
        
        
    }else if (x > 2.0 && x<=3.0){
    
        return 66*3+20+18+20-6;
        
        
    }else if (x > 3.0 && x <=4.0){
    
        return 66*4+20+24+20-6;
        
        
    }else if (x > 4.0 && x <=5.0){
    
        
        return 66*4+20+30+20-6;
        
        
    } else if (x >5.0 && x<=6.0){
    
        return 66*5+20+36+20-6;
        
    }
}
- (void)drawRect:(CGRect)rect
{
    return;
    [self.subviews[0] setBackgroundColor:[UIColor clearColor]];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线，
    CGContextSetStrokeColorWithColor(context, RGBCOLOR(126.0, 204, 200).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, -3, rect.size.width - 10, 2));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context,  RGBCOLOR(126.0, 204, 200).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width - 10, 2));
    
    CGContextSaveGState(context);
    
}

@end
