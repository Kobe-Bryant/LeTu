//
//  MapCarpoolBoxViewController.m
//  LeTu
//
//  Created by DT on 14-6-2.
//
//

#import "MapCarpoolBoxViewController.h"

#define INTNUM @"0123456789"
#define FLOATNUM @"0123456789."

@interface MapCarpoolBoxViewController ()<UITextFieldDelegate>
{
    BOOL isHasRadixPoint;
}
@property(nonatomic,strong)UITextField *textField;

@property(nonatomic,strong)NSString *content;
@property(nonatomic,assign)int type;
@end

@implementation MapCarpoolBoxViewController

-(id)initWithType:(int)type content:(NSString*)content block:(MapCarpoolBoxBlock)block;
{
    self = [super init];
    if (self) {
        self.content = content;
        self.type = type;
        boxBlock = block;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    if (self.type==1) {
        [self setTitle:@"输入人数" andShowButton:YES];
    }else if (self.type==2){
        [self setTitle:@"输入金额" andShowButton:YES];
    }
    [self initRightBarButtonItem:@"确定"];
    [self initTextField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    if (self.type==1) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }else if (self.type==2) {
        self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}
#pragma mark UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.type==1) {
        if ([string length]>0) {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if (single == '0') {
                //                        NSLog(@"第一个数字不能为0");
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:INTNUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];
        return canChange;
    }else if (self.type==2){//只能输入大于0的两位小数
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            isHasRadixPoint=NO;
        }
        if ([string length]>0){
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if ((single >='0' && single<='9') || single=='.'){//数据格式正确
                //首字母不能为0和小数点
                if([textField.text length]==0){
                    if(single == '.'){
//                        NSLog(@"亲，第一个数字不能为小数点");
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                    if (single == '0') {
//                        NSLog(@"第一个数字不能为0");
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                if (single=='.'){
                    if(!isHasRadixPoint){//text中还没有小数点
                        isHasRadixPoint=YES;
                        return YES;
                    }else{
//                        NSLog(@"已经输入过小数点了");
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (isHasRadixPoint){//存在小数点
                        //判断小数点的位数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt=range.location-ran.location;
                        if (tt <= 2){
                            return YES;
                        }else{
//                            NSLog(@"最多输入两位小数");
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
//                NSLog(@"输入的格式不正确");
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else{
            return YES;
        }
    }
    return YES;
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
@end
