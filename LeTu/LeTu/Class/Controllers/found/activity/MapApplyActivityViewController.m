//
//  MapApplyActivityViewController.m
//  LeTu
//
//  Created by DT on 14-6-19.
//
//

#import "MapApplyActivityViewController.h"

@interface MapApplyActivityViewController ()
{
    NSOperationQueue *queue;
}
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
-(void)clickRightButton:(UIButton *)button
{
    [self.textView resignFirstResponder];
    if (![self.textView.text isEqualToString:@""]) {
        [self addComment:self.activityId message:self.textView.text longitude:self.appDelegate.currentLocation.longitude latitude:self.appDelegate.currentLocation.latitude];
    }
}
/**
 *  创建评论
 *
 *  @param activityId 活动id
 *  @param message    评论内容
 *  @param longitude  经度
 *  @param latitude   纬度
 */
-(void)addComment:(NSString*)activityId message:(NSString*)message longitude:(float)longitude latitude:(float)latitude
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@activity/activityService.jws?addComment", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:5];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:activityId forKey:@"activityId"];
    [paramDict setObject:message forKey:@"message"];
    [paramDict setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    [paramDict setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (tag==1) {
        if (self.callBack) {
            self.callBack();
        }
        [self messageToast:@"评论活动成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (tag==2) {
        
    }
}
@end
