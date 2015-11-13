//
//  AboutUsViewController.m
//  Monitor
//
//  Created by Mac Air on 13-9-9.
//
//

#import "AboutUsViewController.h"
#import "Utility.h"
#import "WebViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"about_title"];
    [self setTitleImage:image andShowButton:YES];
    [self drawView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma drawView
- (void) drawView
{
    UIImage *titleImage = [UIImage imageNamed:@"about_banner"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:titleImage];
    imageView.frame = CGRectMake(28, 60, titleImage.size.width, titleImage.size.height);
    [self.view addSubview:imageView];
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"官方网址:",@"官方微博:",@"咨询热线:", @"服务热线:", @"地址:", nil];
    NSArray *contentArray = [NSArray arrayWithObjects:@"www.cyberway.net.cn",
                             @"http://e.weibo.com/cyberwaygroup",
                             @"4008-066-100",
                             @"020-22106820",
                             @"广州科学城彩频路11号广东软件科学园F栋12-13楼", nil];
    
    for (int i = 0; i < 5; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 140 + i * 50, 250, 20)];
        titleLabel.text = [titleArray objectAtIndex:i];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [self.view addSubview:titleLabel];
        
        if (i != 4) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.font = [UIFont systemFontOfSize:15];
            [button setTitle:[contentArray objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [button setTitleColor:[Utility colorWithHexString:@"#68A8E1"] forState:UIControlStateNormal];
            [self.view addSubview: button];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            if (i == 0) {
                button.frame = CGRectMake(30, 160 + i * 50, 150, 20);
            }else if(i == 1){
                button.frame = CGRectMake(30, 160 + i * 50, 240, 20);
            }else if(i == 2){
                button.frame = CGRectMake(30, 160 + i * 50, 100, 20);
            }else if(i == 3){
                button.frame = CGRectMake(30, 160 + i * 50, 100, 20);
            }
        }else{
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 160 + i * 50, 250, 40)];
            label.text = [contentArray objectAtIndex:i];
            label.numberOfLines = 0;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [Utility colorWithHexString:@"#68A8E1"];
            label.font = [UIFont systemFontOfSize:15];
            [self.view addSubview: label];
        }
    }
}

- (void) buttonPressed:(id) sender
{
    UIButton *button = (UIButton *) sender;
    switch (button.tag) {
        case 0:
        {
            WebViewController *webVC = [[WebViewController alloc] initWithOpenURL:@"http://www.cyberway.net.cn"];
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 1:
        {
            WebViewController *webVC = [[WebViewController alloc] initWithOpenURL:@"http://e.weibo.com/cyberwaygroup"];
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 2:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", @"4008066100"]]];
        }
            break;
        case 3:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", @"02022106820"]]];
        }
            break;
            
        default:
            break;
    }
    
     
}

@end
