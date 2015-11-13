//
//  FaceView.m
//  AHAOrdering
//
//  Created by cyberway on 14-4-3.
//
//

#import "FaceView.h"
#import "Utility.h"
#import "AppDelegate.h"

@implementation FaceView

@synthesize faceDelegate;
@synthesize isShow;

- (id)init
{
    if (self = [super init])
    {
        [self initialize];
    }
    
    return self;
}

/** 初始化 */
- (void)initialize
{
    int height = [UIScreen mainScreen].bounds.size.height;
    self.frame = CGRectMake(0, height - 216, 320, 216);
    
    self.backgroundColor = [Utility colorWithHexString:@"#F9F9F9"];
    self.delegate = self;
    self.pagingEnabled = YES;
    
    int row = 4;
    int count = 7;
    float width = 320.0f / count;
    int lastPageCount = 105 % (row * count);
    int pageCount = 105 / (row * count) + (lastPageCount > 0 ? 1 : 0);
    
    UIView *itemView = nil;
    UIButton *button = nil;
    int x = 0;
    int y = 0;
    int currRow = row;
    int currCount = count;
    for (int i = 0; i < pageCount; i++)
    {
        if (i == pageCount - 1 && lastPageCount > 0)
        {
            currRow = lastPageCount / count + (lastPageCount % count > 0 ? 1 : 0);
        }
        itemView = [[UIView alloc] initWithFrame:CGRectMake(i * 320, 5, 320, 206)];
        for (int m = 0; m < currRow; m++)
        {
            if (i == pageCount - 1 && m == currRow - 1 && lastPageCount % count > 0)
            {
                currCount = lastPageCount % count;
            }
            for (int n = 0; n < currCount; n++)
            {
                button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = i * row * count + m * count + n;
                button.frame = CGRectMake(x, y, width, width);
                [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d", button.tag]] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonEvents:) forControlEvents:UIControlEventTouchUpInside];
                [itemView addSubview:button];
                
                x += width;
            }
            
            x = 0;
            y += width;
        }
        [self addSubview:itemView];
        x = 0;
        y = 0;
    }
    
    self.contentSize = CGSizeMake(320 * pageCount, 216);
}

/** 按钮事件 */
- (void)buttonEvents:(UIButton *)button
{
    if (self.faceDelegate)
    {
        [self.faceDelegate faceView:self faceIndex:button.tag];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)show
{
    if (! self.isShow)
    {
        UIWindow *keyWindow = [UIApplication sharedApplication].windows.lastObject;
        [keyWindow addSubview:self];
    }
    self.isShow = YES;
}

- (void)dismiss
{
    if (self.isShow)
    {
        [self removeFromSuperview];
    }
    self.isShow = NO;
}

@end
