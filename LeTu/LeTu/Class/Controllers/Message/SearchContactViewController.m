//
//  SearchContactViewController.m
//  LeTu
//
//  Created by mac on 14-6-18.
//
//

#import "SearchContactViewController.h"
#import "SearchContactResultViewController.h"
#import "SearchResultModel.h"
#import "MyselfDetailViewController.h"
@interface SearchContactViewController ()

@end

@implementation SearchContactViewController

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
    
    [self setTitle:@"添加联系人" andShowButton:YES];
    [self initViews];
    
}
- (void)initViews
{
#ifndef IMPORT_LETUIM_H
    UILabel *textlb=[[UILabel alloc]initWithFrame:CGRectMake(11, 65, 200, 30)];
    textlb.text=@"搜索乐途号或手机号添加朋友";
    textlb.backgroundColor = [UIColor clearColor];
    textlb.font = [UIFont systemFontOfSize:18.0f];
    textlb.textColor = [Utility colorWithHexString:@"#666666"];
    [self.view addSubview:textlb];
    
    
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(11, 105, 243.5, 30.5)];
    
    bgView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Add contacts_blank"]];
    [self.view addSubview:bgView];
    
    
    UIImageView *logoView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 112, 18, 18)];
    
    logoView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Add contacts_search"]];
    [self.view addSubview:logoView];
#endif
    
    //搜索
    UIButton *searchBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(261, 105, 48, 30.5);
    [searchBtn setImage:[UIImage imageNamed:@"Add contacts_btn_search_normal"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"Add contacts_btn_search_press"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(buttonEvents:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.tag=1;
#ifndef IMPORT_LETUIM_H
    [self.view addSubview:searchBtn];
#endif
    
    searchFriendTf = [[UITextField alloc] initWithFrame:CGRectMake(40, 108, 210, 25)];
    searchFriendTf.delegate = self;
    searchFriendTf.placeholder=@"请输入乐途号";
    searchFriendTf.returnKeyType =UIReturnKeyDone;
    searchFriendTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchFriendTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchFriendTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
#ifndef IMPORT_LETUIM_H
    [self.view addSubview:searchFriendTf];
#endif
    
    
#ifdef IMPORT_LETUIM_H
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-2, 64, 324, 44)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = [[UIColor colorWithWhite:210/255.f alpha:1.f] CGColor];
    view.layer.borderWidth = .5;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 7, 30, 30)];
    [view addSubview:imageView];
    imageView.image =[UIImage imageNamed:@"Add contacts_icon_letu"];
    
    [view addSubview:searchFriendTf];
    searchFriendTf.frame = CGRectMake(52, 7, 210, 30);
    
    [view addSubview:searchBtn];
    searchBtn.frame = CGRectMake(263, 7, 48, 30.5);
#endif
    
}
-(void)buttonEvents:(UIButton*)btn
{
    switch (btn.tag) {
        case 1:
        {
            
            if (!searchFriendTf||[searchFriendTf.text isEqualToString:@""])
            {
                [self messageShow:@"输入乐途号~"];
            }
            else
            {
                [self searchPerson];
            }
           
        }
        break;
            
        default:
            break;
    }
 
}
-(void)searchPerson
{
    NSLog(@"%@ ?= %@", searchFriendTf.text, self.appDelegate.userModel.loginName);
    if ([searchFriendTf.text isEqualToString:self.appDelegate.userModel.loginName]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"不能添加自己为好友" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
        return;
    }

    
    //192.168.0.234:8891/ms/friendService.jws?searchByLoginName&&loginName=&l_key=

    NSString *requestURL = [NSString stringWithFormat:
                            @"%@ms/friendService.jws?searchByLoginName&&loginName=%@&l_key=%@",SERVERAPIURL,searchFriendTf.text,[UserDefaultsHelper getStringForKey:@"key"]];
    
    NSLog(@"APIUrl---%@",requestURL);
    
    if (queue == nil ){
        queue = [[ NSOperationQueue alloc ] init ];
    }
    
    RequestParseOperation * operation=[[RequestParseOperation alloc] initWithURLString:requestURL delegate:self ];
    operation.RequestTag = 111;
    
    [queue addOperation :operation]; // 开始处理

}

-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    switch (tag)
    {
            
            
        case 111:
        {
            NSDictionary *errDict = [data objectForKey:@"error"];
            int errCode = [[errDict objectForKey:@"err_code"] intValue];
            NSString *errMsg=[errDict objectForKey:@"err_msg"];
            if (errCode == 0 || errCode == 1)
            {
                SearchResultModel *model = [[SearchResultModel alloc] initWithDataDict:[data objectForKey:@"obj"]];
                if ([model.isFriend boolValue]) //已经是好友跳去好友个人资料页
                {
                    MyselfDetailViewController *detailVC = [[MyselfDetailViewController alloc] initWithTitle:model.userName userId:model.userId userKey:@""];
                    [self.navigationController pushViewController:detailVC animated:YES];
                }
                else
                {
                    SearchContactResultViewController *vc = [[SearchContactResultViewController alloc]init];
                    vc.searchResultModel=model;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            else
            {
                [self messageShow:errMsg];
                
            }
            break;
        }
            
        default:
            break;
    }
    
    
    
}





-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
