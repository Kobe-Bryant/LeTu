//
//  MapActivityBoxViewController.m
//  LeTu
//
//  Created by DT on 14-6-19.
//
//

#import "MapActivityBoxViewController.h"

#define INTNUM @"0123456789"

@interface MapActivityBoxViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *textField;

@property(nonatomic,assign)int type;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,strong)NSArray *titleArray;
@end

@implementation MapActivityBoxViewController

- (id)initWithType:(int)type content:(NSString *)content block:(MapActivityBoxBlock)block
{
    self = [super init];
    if (self) {
        boxBlock = block;
        self.type = type;
        self.content = content;
        self.titleArray = [[NSArray alloc] initWithObjects:@"修改活动主题",@"修改活动时间",@"修改活动地点",@"修改活动人数",nil];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:[self.titleArray objectAtIndex:self.type] andShowButton:YES];
    [self initRightBarButtonItem:@"确定"];
    [self initTextField];
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

-(void)clickRightButton:(UIButton *)button
{
    [self.textField resignFirstResponder];
    if (![self.textField.text isEqualToString:@""]) {
        if (boxBlock) {
            boxBlock(self.textField.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

/**
 *  初始化文本框
 */
- (void)initTextField
{
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, 60, 322, 41)];
    backgroundView.image =[UIImage imageNamed:@"myinformation_table"];
    [self.view addSubview:backgroundView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, 305, 41)];
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.text = self.content;
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    if (self.type==3) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
}

/**
 *  按下回车键事件
 *
 *  @param textField
 *
 *  @return
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    if (![self.textField.text isEqualToString:@""]) {
        if (boxBlock) {
            boxBlock(self.textField.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    return YES;
}
#pragma mark UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.type==3) {
        if ([textField.text length]==0) {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if (single == '0') {
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:INTNUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];        BOOL canChange = [string isEqualToString:filtered];
        return canChange;
    }
    return YES;
}
@end
