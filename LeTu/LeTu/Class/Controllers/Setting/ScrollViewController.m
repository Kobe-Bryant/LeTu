//
//  ScrollViewController.m
//  E-learning
//
//  Created by Mac Air on 13-7-26.
//
//

#import "ScrollViewController.h"

@interface ScrollViewController ()

@end

@implementation ScrollViewController


#pragma mark - lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initScrollView];
    [self drawBackground];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ScrollView
- (void) initScrollView
{
    scrollView = [[UIScrollView alloc] initWithFrame:
                  CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(960, self.view.bounds.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;//隐藏水平滚动条
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
}


#pragma mark - drawPicture
- (void) drawBackground
{
    NSMutableArray *array ;
    array = [NSMutableArray arrayWithObjects:
             @"one", @"two", @"three", nil];
    [self drawIntroducePicture:array];
}

- (void) drawIntroducePicture:(NSArray *)array
{
    UIImage *bg = [UIImage imageNamed:[array objectAtIndex:0]];

    for (int i = 0; i < array.count; i++) {
        
        UIImageView *bgIV = [[UIImageView alloc] initWithImage:bg];
        UIImage *introduce =[UIImage imageNamed:[array objectAtIndex:i]];
        UIImageView *introduceIV =[[UIImageView alloc] initWithImage:introduce];
        introduceIV.backgroundColor = [UIColor clearColor];
        
        bgIV.frame = CGRectMake(320 * i, 0, bg.size.width, bg.size.height);
        introduceIV.frame = CGRectMake(320 * i, 0, introduce.size.width, introduce.size.height);
        
        [scrollView addSubview:bgIV];
        [scrollView addSubview:introduceIV];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
//    CGFloat pagewidth = scrollView.frame.size.width;
//    int page = scrollView.contentOffset.x / pagewidth;
//    pageLabel.text = [NSString stringWithFormat:@"%d/%d", page+1, pageCout];
    
    if (scrollView.contentOffset.x == scrollView.contentSize.width - 320) {
        [self performSelector:@selector(exitScrollView) withObject:nil afterDelay:0.2f];
    }
}

- (void)exitScrollView
{

//    [self dismissModalViewControllerAnimated:YES];
    
    if (self.modelFrom == 0) {
        [UserDefaultsHelper setBoolForKey:YES :@"isNotFirst"];
        SHOWLOGINVIEW;
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}
@end
