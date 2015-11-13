//
//  MapApplyActivityViewController.m
//  LeTu
//
//  Created by DT on 14-6-19.
//
//

#import "MapApplyActivityViewController.h"

@interface MapApplyActivityViewController ()
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,copy)NSString *activityId;
@end

@implementation MapApplyActivityViewController

-(id)initWithActivityId:(NSString*)activityId
{
    self = [super init];
    if (self) {
        self.activityId = activityId;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"报名找人同去" andShowButton:YES];
    [self initRightBarButtonItem:[UIImage imageNamed:@"posting_headbar_icon_send_current"]
                highlightedImage:[UIImage imageNamed:@"posting_headbar_icon_send_press"]];
    [self initTextView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initTextView
{
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, FRAME_WIDTH, 100)];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.text = @"";
    self.textView.font = [UIFont systemFontOfSize:15.0f];
    [self.textView becomeFirstResponder];
    [self.view addSubview:self.textView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}
@end
