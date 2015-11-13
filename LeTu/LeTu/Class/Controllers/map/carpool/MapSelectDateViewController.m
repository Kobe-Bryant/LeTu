//
//  MapSelectDateViewController.m
//  LeTu
//
//  Created by DT on 14-5-28.
//
//

#import "MapSelectDateViewController.h"
#import "RBCustomDatePickerView.h"

@interface MapSelectDateViewController ()

@end

@implementation MapSelectDateViewController

-(id)initWithBlock:(CallBack)block
{
    self = [super init];
    if (self) {
        callBack = block;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    RBCustomDatePickerView *pickerView = [[RBCustomDatePickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 1340) block:^(NSString *date) {
        if (callBack) {
            callBack(date);
        }
    }];
    pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pickerView];
    
    [self setTitle:@"选择时间" andShowButton:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
