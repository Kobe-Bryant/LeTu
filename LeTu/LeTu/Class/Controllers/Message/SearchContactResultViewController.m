//
//  SearchContactResultViewController.m
//  LeTu
//
//  Created by mac on 14-6-18.
//
//

#import "SearchContactResultViewController.h"
#import "EGOImageButton.h"
#import "MyselfDetailViewController.h"
@interface SearchContactResultViewController ()

@end

@implementation SearchContactResultViewController
@synthesize searchResultModel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"搜索联系人" andShowButton:YES];
    [self initViews];
    
}
- (void)initViews
{
    
    if (self.searchResultModel)
    {
        
        
        EGOImageButton  *headImageBtn = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@"weibo_moren"]];
        headImageBtn.frame=CGRectMake(21, 64, 50, 50);
        headImageBtn.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERImageURL,[self.searchResultModel userPhoto]]];
        
        [headImageBtn addTarget:self action:@selector(buttonEvents:) forControlEvents:UIControlEventTouchUpInside];
        headImageBtn.tag=1;
        [self.view addSubview:headImageBtn];
        
        
        
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(83, 72, 180, 30)];
        nameLab.text=self.searchResultModel.userName;
        nameLab.font = [UIFont systemFontOfSize:18.0f];
        nameLab.textColor = [Utility colorWithHexString:@"#333333"];
        [self.view addSubview:nameLab];
        
        
        UILabel *signLab=[[UILabel alloc]initWithFrame:CGRectMake(83, 100, 230, 25)];
        signLab.text=self.searchResultModel.sign;
        signLab.font = [UIFont systemFontOfSize:15.0f];
        signLab.textColor = [Utility colorWithHexString:@"#888888"];
        [self.view addSubview:signLab];
        
        
        //添加联系人按钮
        UIButton *addBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(46, 237/2+44, 457/2, 33);
        [addBtn setImage:[UIImage imageNamed:@"search_friend_btn_normal"] forState:UIControlStateNormal];
        [addBtn setImage:[UIImage imageNamed:@"search_friend_btn_press"] forState:UIControlStateHighlighted];
        [addBtn addTarget:self action:@selector(buttonEvents:) forControlEvents:UIControlEventTouchUpInside];
        addBtn.tag=2;
        [self.view addSubview:addBtn];
        
    }
    
    
    

}
-(void)buttonEvents:(UIButton*)btn
{
    switch (btn.tag) {
        case 1:
        {
            MyselfDetailViewController *detailVC = [[MyselfDetailViewController alloc] initWithTitle:self.searchResultModel.userName userId:self.searchResultModel.userId userKey:@""];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
        case 2:
        {
            [self showMessageAlertView];
        }
            break;
            
        default:
            break;
    }




}
-(void)showMessageAlertView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"验证消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex)
    {
        UITextField *messageTextField = [alertView textFieldAtIndex:0];
        if (messageTextField.text&&![messageTextField.text isEqualToString:@""])
        {
            [self sendFriendApply:messageTextField.text];
        }
        else
        {
            [self messageShow:@"请输入验证消息"];
        }
    
    }
}

- (void)sendFriendApply:(NSString *)message
{
   //192.168.0.234:8891/ms/friendService.jws?applyFriend&&l_key=&loginName=&message=
    
    NSString *requestURL = [NSString stringWithFormat:@"%@ms/friendService.jws?applyFriend&&",SERVERAPIURL];
    NSURL *url = [NSURL URLWithString:requestURL];
    NSLog(@"APIUrl---%@",url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [request setPostValue:self.searchResultModel.loginName forKey:@"loginName"];
    [request setPostValue:message forKey:@"message"];
    [request setTag:111];
    [request buildPostBody];
    [request setDelegate:self];
    [request setTimeOutSeconds:240];
    [request startAsynchronous];
    
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    
    NSLog(@"-responseString--%@-----",responseString);
    
    NSError *error = [request error];
    if (!error)
    {
        
        
        JSONDecoder *decoder=[JSONDecoder decoder];
        NSDictionary *dict=[decoder objectWithData:request.responseData];
        NSDictionary *errDict=[dict objectForKey:@"error"];
        int errCode=[[errDict objectForKey:@"err_code"] intValue];
        NSString *errMsg=[errDict objectForKey:@"err_msg"];
        switch (request.tag)
        {
                
                
            case 111:
            {
                if (errCode == 0 || errCode == 1)
                {
                    [self messageShow:@"已发送申请！"];
                }
                else
                {
                    [self messageShow:errMsg];
                    
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
}


@end
