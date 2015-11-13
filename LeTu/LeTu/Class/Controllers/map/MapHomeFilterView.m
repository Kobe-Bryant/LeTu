//
//  MapHomeFilterView.m
//  LeTu
//
//  Created by DT on 14-5-21.
//
//

#import "MapHomeFilterView.h"
#import "DTButton.h"
@interface MapHomeFilterView()
{
    CGRect _frame;
}
@property(nonatomic,strong)NSMutableArray *buttonArray;
@end
@implementation MapHomeFilterView

-(id)initWithFrame:(CGRect)frame block:(CallBack)block
{
    self = [super initWithFrame:frame];
    if (self) {
        callBack = block;
        
        _frame = CGRectMake(0, 269, frame.size.width, frame.size.height - 269);
        self.buttonArray = [[NSMutableArray alloc] init];
        DTButton *button = nil;
        
        button = [[DTButton alloc] initWithFrame:CGRectMake(7, 35, 91, 32)];
        button.normalImage = [UIImage imageNamed:@"selection_all_current"];
        button.pressImage = [UIImage imageNamed:@"selection_all_press"];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.isSelect = YES;
        button.indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        button = [[DTButton alloc] initWithFrame:CGRectMake(114, 35, 91, 32)];
        button.normalImage = [UIImage imageNamed:@"selection_male_current"];
        button.pressImage = [UIImage imageNamed:@"selection_male_press"];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.isSelect = NO;
        button.indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        button = [[DTButton alloc] initWithFrame:CGRectMake(221, 35, 91, 32)];
        button.normalImage = [UIImage imageNamed:@"selection_female_current"];
        button.pressImage = [UIImage imageNamed:@"selection_female_press"];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.isSelect = NO;
        button.indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        button = [[DTButton alloc] initWithFrame:CGRectMake(7, 104, 91, 32)];
        button.normalImage = [UIImage imageNamed:@"selection_unlimited_current"];
        button.pressImage = [UIImage imageNamed:@"selection_unlimited_press"];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.isSelect = YES;
        button.indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        button = [[DTButton alloc] initWithFrame:CGRectMake(114, 104, 91, 32)];
        button.normalImage = [UIImage imageNamed:@"selection_driver_current"];
        button.pressImage = [UIImage imageNamed:@"selection_driver_press"];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.isSelect = NO;
        button.indexPath = [NSIndexPath indexPathForRow:2 inSection:2];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        button = [[DTButton alloc] initWithFrame:CGRectMake(221, 104, 91, 32)];
        button.normalImage = [UIImage imageNamed:@"selection_passager_current"];
        button.pressImage = [UIImage imageNamed:@"selection_passager_passager"];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.isSelect = NO;
        button.indexPath = [NSIndexPath indexPathForRow:3 inSection:2];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        button = [[DTButton alloc] initWithFrame:CGRectMake(7,173, 91, 32)];
        button.normalImage = [UIImage imageNamed:@"selection_map_current"];
        button.pressImage = [UIImage imageNamed:@"selection_map_press"];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.isSelect = YES;
        button.indexPath = [NSIndexPath indexPathForRow:1 inSection:3];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        button = [[DTButton alloc] initWithFrame:CGRectMake(114, 173, 91, 32)];
        button.normalImage = [UIImage imageNamed:@"selection_list_current"];
        button.pressImage = [UIImage imageNamed:@"selection_list_press"];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.isSelect = NO;
        button.indexPath = [NSIndexPath indexPathForRow:2 inSection:3];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        button = [[DTButton alloc] initWithFrame:CGRectMake(221, 173, 91, 32)];
        button.normalImage = [UIImage imageNamed:@"selection_photo_current"];
        button.pressImage = [UIImage imageNamed:@"selection_photo_press"];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.isSelect = NO;
        button.indexPath = [NSIndexPath indexPathForRow:3 inSection:3];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        button = [[DTButton alloc] initWithFrame:CGRectMake(7, 220, 153, 45)];
        [button setImage:[UIImage imageNamed:@"selection_confirm_current"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"selection_confirm_press"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.indexPath = [NSIndexPath indexPathForRow:1 inSection:4];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        button = [[DTButton alloc] initWithFrame:CGRectMake(160, 220, 153, 45)];
        [button setImage:[UIImage imageNamed:@"selection_cancel_current"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"selection_cancel_press"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.indexPath = [NSIndexPath indexPathForRow:2 inSection:4];
        [self addSubview:button];
        [self.buttonArray addObject:button];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIImage *backgroundImage = [UIImage imageNamed:@"selection_bg"];
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point=[[touches anyObject] locationInView:self];//触摸点的位置
    if (CGRectContainsPoint(_frame, point)) {
        self.hidden = YES;
    }
}
/**
 *  按钮事件
 *
 *  @param button
 */
- (void)clickButton:(DTButton*)button
{
    NSIndexPath *indexPath = button.indexPath;
//    NSLog(@"indexPath.section:%i,indexPath.row:%i",indexPath.section,indexPath.row);
    if (indexPath.section ==4) {//确定取消按钮
        int oneRow = 0;
        int twoRow = 0;
        int threeRow = 0;
        for (int i=0; i< 3; i++) {
            DTButton *button = [self.buttonArray objectAtIndex:i];
            if ([button isSelect]) {
                oneRow = i+1;
            }
        }
        for (int i=3; i< 6; i++) {
            DTButton *button = [self.buttonArray objectAtIndex:i];
            if ([button isSelect]) {
                if (i==3) {
                    twoRow = 1;
                }else if (i==4){
                    twoRow = 2;
                }else if (i==5){
                    twoRow = 3;
                }
            }
        }
        for (int i=6; i< 9; i++) {
            DTButton *button = [self.buttonArray objectAtIndex:i];
            if ([button isSelect]) {
                if (i==6) {
                    threeRow = 1;
                }else if (i==7){
                    threeRow = 2;
                }else if (i==8){
                    threeRow = 3;
                }
            }
        }
        if (callBack) {
            callBack(oneRow,twoRow,threeRow,indexPath.row);
        }
        
    }else{
        button.isSelect = ![button isSelect];
        DTButton *btn = nil;
        if (indexPath.section ==1) {//想看的用户
            if (indexPath.row==1) {
                btn = [self.buttonArray objectAtIndex:1];
                btn.isSelect = NO;
                btn = [self.buttonArray objectAtIndex:2];
                btn.isSelect = NO;
            }else if (indexPath.row==2){
                btn = [self.buttonArray objectAtIndex:0];
                btn.isSelect = NO;
                btn = [self.buttonArray objectAtIndex:2];
                btn.isSelect = NO;
            }else if (indexPath.row==3){
                btn = [self.buttonArray objectAtIndex:0];
                btn.isSelect = NO;
                btn = [self.buttonArray objectAtIndex:1];
                btn.isSelect = NO;
            }
        }else if (indexPath.section ==2) {//查看的类型
            if (indexPath.row==1) {
                btn = [self.buttonArray objectAtIndex:4];
                btn.isSelect = NO;
                btn = [self.buttonArray objectAtIndex:5];
                btn.isSelect = NO;
            }else if (indexPath.row==2){
                btn = [self.buttonArray objectAtIndex:3];
                btn.isSelect = NO;
                btn = [self.buttonArray objectAtIndex:5];
                btn.isSelect = NO;
            }else if (indexPath.row==3){
                btn = [self.buttonArray objectAtIndex:3];
                btn.isSelect = NO;
                btn = [self.buttonArray objectAtIndex:4];
                btn.isSelect = NO;
            }
        }else if (indexPath.section ==3) {//显示
            if (indexPath.row==1) {
                btn = [self.buttonArray objectAtIndex:7];
                btn.isSelect = NO;
                btn = [self.buttonArray objectAtIndex:8];
                btn.isSelect = NO;
            }else if (indexPath.row==2){
                btn = [self.buttonArray objectAtIndex:6];
                btn.isSelect = NO;
                btn = [self.buttonArray objectAtIndex:8];
                btn.isSelect = NO;
            }else if (indexPath.row==3){
                btn = [self.buttonArray objectAtIndex:6];
                btn.isSelect = NO;
                btn = [self.buttonArray objectAtIndex:7];
                btn.isSelect = NO;
            }
        }
    }
}
@end
