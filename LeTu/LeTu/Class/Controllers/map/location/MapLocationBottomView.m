//
//  MapLocationBottomView.m
//  LeTu
//
//  Created by DT on 14-7-2.
//
//

#import "MapLocationBottomView.h"

@interface MapLocationBottomView()
@end

@implementation MapLocationBottomView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.status = 1;
        
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.bgImageView.image = [[UIImage imageNamed:@"location_start_end@2x"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
        [self addSubview:self.bgImageView];
        
        self.startImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.startImageView.image = [UIImage imageNamed:@"star_blank"];
        self.startImageView.userInteractionEnabled = YES;
        [self addSubview:self.startImageView];
        
        self.startAddress = [[UILabel alloc] initWithFrame:CGRectZero];
        self.startAddress.backgroundColor = [UIColor clearColor];
        self.startAddress.font = [UIFont systemFontOfSize:13.0f];
        self.startAddress.textColor = [UIColor blackColor];
//        self.startAddress.text = @"深圳市南山区科技园中区科苑路15号科兴科学园";
        self.startAddress.textAlignment = NSTextAlignmentCenter;
        [self.startImageView addSubview:self.startAddress];
        
        self.startButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.startButton setImage:[UIImage imageNamed:@"location_search_normal"] forState:UIControlStateNormal];
        [self.startButton setImage:[UIImage imageNamed:@"location_search_press"] forState:UIControlStateHighlighted];
        self.startButton.tag = 1;
        [self.startButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
//        self.startButton.userInteractionEnabled = YES;
        [self.startImageView addSubview:self.startButton];
        
        self.endImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.endImageView.image = [UIImage imageNamed:@"end_blank"];
        self.endImageView.userInteractionEnabled = YES;
        [self addSubview:self.endImageView];
        
        self.endAddress = [[UILabel alloc] initWithFrame:CGRectZero];
        self.endAddress.backgroundColor = [UIColor clearColor];
        self.endAddress.font = [UIFont systemFontOfSize:13.0f];
        self.endAddress.textColor = [UIColor blackColor];
        //        self.startAddress.text = @"深圳市南山区科技园中区科苑路15号科兴科学园";
        self.endAddress.textAlignment = NSTextAlignmentCenter;
        [self.endImageView addSubview:self.endAddress];
        
        self.endButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.endButton setImage:[UIImage imageNamed:@"location_search_normal"] forState:UIControlStateNormal];
        [self.endButton setImage:[UIImage imageNamed:@"location_search_press"] forState:UIControlStateHighlighted];
        self.endButton.tag = 2;
        [self.endButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        //        self.startButton.userInteractionEnabled = YES;
        [self.endImageView addSubview:self.endButton];
        
        self.ensureButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.ensureButton setImage:[UIImage imageNamed:@"location_star_normal"] forState:UIControlStateNormal];
        [self.ensureButton setImage:[UIImage imageNamed:@"location_star_press"] forState:UIControlStateHighlighted];
        self.ensureButton.tag = 888;
        [self.ensureButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.ensureButton];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.userInteractionEnabled = YES;
    self.bgImageView.frame = CGRectMake(0, 0, 320, self.frame.size.height);
    
    self.startImageView.frame = CGRectMake(7.5, 7.5, 305, 34);
    self.startAddress.frame = CGRectMake(45, 0, 220, 34);
    self.startButton.frame = CGRectMake(270, 0, 39, 34);
    
    if (self.status==2) {
        self.endImageView.frame = CGRectMake(7.5, 7.5+34+7.5, 305, 34);
        self.endAddress.frame = CGRectMake(45, 0, 220, 34);
        self.endButton.frame = CGRectMake(270, 0, 39, 34);
    }
    
    self.ensureButton.frame = CGRectMake(7.5, self.frame.size.height-34-7.5, 305, 34);
}

-(void)clickButton:(UIButton*)button
{
    if (self.callBack) {
        self.callBack(button.tag);
    }
}
@end
