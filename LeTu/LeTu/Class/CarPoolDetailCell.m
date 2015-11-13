//
//  CarPoolDetailCell.m
//  LeTu
//
//  Created by mafeng on 14-9-22.
//
//

#import "CarPoolDetailCell.h"
#import "CarManagerModel.h"
#import "AppDelegate.h"
#import "LeTuRouteModel.h"

#import "ApplyPersonModel.h"
#import "ActionButton.h"

#define ACCEPTBUTTON_TAG 100
#define CANCELBUTTON_TAG 101
#define JOINBUTTON_TAG 102
#define CHATBUTTON_TAG 103

#define BOTTOM_LINE_TAG 0301
#define SHADOW_VIEW_TAG 0302

@interface CarPoolDetailCell()

@property(nonatomic,readwrite) CarPoolTableViewCellStyle carPoolStyle;
@property(nonatomic,strong) UILabel* titletypeLabel;//确定是乘客或者是车主
@property(nonatomic,strong) UIButton* chatButton;//聊天按钮
//@property(nonatomic,strong) UIButton* joinButton;//加入按钮
@property(nonatomic,strong) UILabel* stateLabel;//状态标示

//若是车主进入显示乘客的信息。。。。。。。。。。。。。。。。。。。。。。。。。
@property(nonatomic,strong) UIImageView* avatorImageView;//头像
@property(nonatomic,strong) UIImageView* backImageView;
@property(nonatomic,strong) UIImageView* typeImageView;//确定是乘客还是车主图片
@property(nonatomic,strong) UIImageView* sexImageView;//性别图片
@property(nonatomic,strong) UILabel* ageLabel;//年龄
@property(nonatomic,strong) UILabel* nickNameLabel;//昵称
//若是乘客进入显示车主的信息。。。。。。。。。。。。。。。。。。。。。。。。。
@property(nonatomic,strong) UIImageView* carImageView;//车的图片
@property(nonatomic,strong) UILabel* carSeriousNameLabel;//车的名字
@property(nonatomic,strong) UILabel* carNumberLabel;//车牌号

@property(nonatomic,assign) BOOL selectedRow;
@property(nonatomic,strong) ApplyPersonModel* selectModel;





@end


@implementation CarPoolDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)systemCellStyle customCellStyle:(CarPoolTableViewCellStyle)carPoolTableViewCellStyle
{
    self = [super initWithStyle:systemCellStyle reuseIdentifier:nil];
    if (self) {
    
        self.selectedRow = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.carPoolStyle = carPoolTableViewCellStyle;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.layer.zPosition = 1001.0;
        self.contentView.frame = CGRectMake(10.0, 10.0, self.frame.size.width- 10*2, self.frame.size.height);
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        if (self.carPoolStyle == CarPoolDetailTableViewFirstCell) {
         
            UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(4.0, 4.0)];
            CAShapeLayer* maskLayer = [[CAShapeLayer alloc]init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            self.contentView.layer.mask = maskLayer;
            
            UIView *bottomLine = [[UIView alloc] init];
            bottomLine.frame = CGRectMake(0.0,
                                          self.contentView.frame.size.height - 2,
                                          self.contentView.frame.size.width,
                                         2);
            bottomLine.backgroundColor = RGBCOLOR(238.0, 238.0, 238.0);
            bottomLine.tag = BOTTOM_LINE_TAG;
       //     [self.contentView addSubview:bottomLine];
            
            
            
        }else if (self.carPoolStyle == CarPoolDetailTableViewMiddleCell){
        
            UIView *bottomLine = [[UIView alloc] init];
            bottomLine.frame = CGRectMake(0.0,
                                          self.contentView.frame.size.height - 2,
                                          self.contentView.frame.size.width,
                                          2);
            bottomLine.backgroundColor = RGBCOLOR(238.0, 238.0, 238.0);
            bottomLine.tag = BOTTOM_LINE_TAG;
         //   [self.contentView addSubview:bottomLine];
        }
        
     }
    return self;
    
}

- (void)setCellInfomation:(ApplyPersonModel*)applyModel
{
    
    NSLog(@"%@",applyModel);
    self.contentView.frame = CGRectMake(10.0,
                                        10.0,
                                        self.frame.size.width - 10.0 * 2.0,
                                        self.frame.size.height);
    
    if (self.carPoolStyle == CarPoolDetailTableViewFirstCell)
    {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds
                                                       byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                             cornerRadii:CGSizeMake(4.0, 4.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.contentView.layer.mask = maskLayer;
        
        UIView *bottomLine = [self viewWithTag:BOTTOM_LINE_TAG];
        bottomLine.frame = CGRectMake(0.0,
                                      self.contentView.frame.size.height - 2,
                                      self.contentView.frame.size.width,
                                      2);
        self.titletypeLabel = [[UILabel alloc]init];
        self.titletypeLabel.frame = CGRectMake((self.contentView.frame.size.width -20.0)/2.0-2, 12.0, 60.0, 20.0);
        self.titletypeLabel.font = [UIFont systemFontOfSize:16.0];
        self.titletypeLabel.textColor = RGBCOLOR(9, 189, 178);
        if (self.model.userType ==1) {
            
            self.titletypeLabel.text = @"乘客";
            
        }else if (self.model.userType ==2){
            
            self.titletypeLabel.text = @"车主";
        }
        [self.contentView addSubview:self.titletypeLabel];
        
        
        UIImage* chatImage = [UIImage imageNamed:@"meBtContactPre.png"];
        self.chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.chatButton.frame = CGRectMake(self.contentView.frame.size.width -15-chatImage.size.width, 8.0, chatImage.size.width, chatImage.size.height);
        self.chatButton.tag = JOINBUTTON_TAG;
        [self.chatButton setImage:chatImage forState:UIControlStateNormal];
        [self.chatButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.chatButton];
        
        }
    else
    {

        AppDelegate* appDelegate = [AppDelegate sharedAppDelegate];
        NSLog(@"%@",appDelegate.userModel);
        
        if (self.model.userType ==1) {
            
            //证明是由车主发起的拼车
            if ([appDelegate.userModel.userId isEqualToString:self.model.userId])
            {
                
                //头像👦
                self.avatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 8, 40, 40)];
                UIImage* defaultImage = [UIImage imageNamed:@"meDefaultPhoto60x60.png"];
                NSString* url = [NSString stringWithFormat:@"%@%@",SERVERimageURL,applyModel.userPhoto];
                [self.avatorImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:defaultImage];
                self.avatorImageView.userInteractionEnabled = YES;
                self.avatorImageView.layer.masksToBounds = NO;
                self.avatorImageView.clipsToBounds = YES;
                self.avatorImageView.layer.cornerRadius =20.0;
                [self.contentView addSubview:self.avatorImageView];
                
                UIImage* backImage = [UIImage imageNamed:@"meBgblue.png"];
                self.backImageView = [[UIImageView alloc]init];
                self.backImageView.frame = CGRectMake(CGRectGetMinX(self.avatorImageView.frame)+5, CGRectGetMaxY(self.avatorImageView.frame)-7, backImage.size.width, backImage.size.height);
                self.backImageView.image = backImage;
                [self.contentView addSubview:self.backImageView];
                
                
                UIImage* personImage = [UIImage imageNamed:@"meIconPassengerBlue.png"];
                self.typeImageView = [[UIImageView alloc]init];
                self.typeImageView.frame = CGRectMake(2.0, 1.0, 10, 8);
                self.typeImageView.image = personImage;
                [self.backImageView addSubview:self.typeImageView];
                
                UIImage* manImage = [UIImage imageNamed:@"meIconBoyBlue.png"];
                UIImage* womanImage = [UIImage imageNamed:@"meIconGirlRed.png"];
                
                self.sexImageView = [[UIImageView alloc]init];
                self.sexImageView.frame = CGRectMake(CGRectGetMaxX(self.typeImageView.frame)+1, 2.0, manImage.size.width-5, manImage.size.height-5);
                if (self.model.userGender ==1) {
                    
                    self.sexImageView.image = manImage;
                }else {
                    
                    self.sexImageView.image = womanImage;
                    
                }
                [self.backImageView addSubview:self.sexImageView];
                
                self.ageLabel = [[UILabel alloc]init];
                self.ageLabel.frame = CGRectMake(CGRectGetMaxX(self.sexImageView.frame)+3, 0.5, 20.0, 10.0);
                self.ageLabel.text = [NSString stringWithFormat:@"%d",applyModel.userAge];
                self.ageLabel.textColor = [UIColor whiteColor];
                self.ageLabel.font = [UIFont systemFontOfSize:8.0];
                [self.backImageView addSubview:self.ageLabel];
                
                self.nickNameLabel = [[UILabel alloc]init];
                self.nickNameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatorImageView.frame)+15, 11, 100, 20.0);
                self.nickNameLabel.font = [UIFont systemFontOfSize:12];
                self.nickNameLabel.textColor = RGBCOLOR(70.0, 70.0, 70.0);
                self.nickNameLabel.text = [NSString stringWithFormat:@"%@",applyModel.userName];
                [self.contentView addSubview:self.nickNameLabel];
                
                UIImage* acceptImage = [UIImage imageNamed:@"meBtAcceptPre.png"];
                UIImage* cancelImage = [UIImage imageNamed:@"meBtCancel.png"];
                
                if (applyModel.status ==0)
                {
                    
                    self.acceptButton = [ActionButton buttonWithType:UIButtonTypeCustom];
                    self.acceptButton.frame = CGRectMake(185, (self.contentView.frame.size.height -acceptImage.size.height)/2.0+5,acceptImage.size.width ,acceptImage.size.height);
                    [self.acceptButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                    self.acceptButton.tag = ACCEPTBUTTON_TAG;
                    [self.acceptButton setImage:acceptImage forState:UIControlStateNormal];
                    self.acceptButton.applyModel = applyModel;
                    [self.contentView addSubview:self.acceptButton];
                    
                    self.cancelButton = [ActionButton buttonWithType:UIButtonTypeCustom];
                    self.cancelButton.frame = CGRectMake(CGRectGetMaxX(self.acceptButton.frame)+3.0, (self.contentView.frame.size.height -cancelImage.size.height)/2.0+5,cancelImage.size.width ,cancelImage.size.height);
                    [self.cancelButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                    self.cancelButton.applyModel = applyModel;
                    self.cancelButton.tag = CANCELBUTTON_TAG;
                    [self.cancelButton setImage:cancelImage forState:UIControlStateNormal];
                    [self.contentView addSubview:self.cancelButton];
                }else if (applyModel.status ==1){
                    
                    
                    UIImage* joinImage = [UIImage imageNamed:@"meBtJoin.png"];
                    self.joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    self.joinButton.frame = CGRectMake(185.0, (self.contentView.frame.size.height - joinImage.size.height)/2.0+5, joinImage.size.width, joinImage.size.height);
                    [self.joinButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                    self.joinButton.tag = JOINBUTTON_TAG;
                    [self.joinButton setImage:joinImage forState:UIControlStateNormal];
                    self.joinButton.userInteractionEnabled = NO;
                    
                    [self.contentView addSubview:self.joinButton];
                }
                
                
                
                
            } else  //证明是由车主参与的线路
            {
                //头像👦
                self.avatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 8, 40, 40)];
                UIImage* defaultImage = [UIImage imageNamed:@"meDefaultPhoto60x60.png"];
                NSString* url = [NSString stringWithFormat:@"%@%@",SERVERimageURL,applyModel.userPhoto];
                [self.avatorImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:defaultImage];                self.avatorImageView.userInteractionEnabled = YES;
                self.avatorImageView.layer.masksToBounds = NO;
                self.avatorImageView.clipsToBounds = YES;
                self.avatorImageView.layer.cornerRadius =20.0;
                [self.contentView addSubview:self.avatorImageView];
                
                UIImage* backImage = [UIImage imageNamed:@"meBgblue.png"];
                self.backImageView = [[UIImageView alloc]init];
                self.backImageView.frame = CGRectMake(CGRectGetMinX(self.avatorImageView.frame)+5, CGRectGetMaxY(self.avatorImageView.frame)-7, backImage.size.width, backImage.size.height);
                self.backImageView.image = backImage;
                [self.contentView addSubview:self.backImageView];
                
                
                UIImage* personImage = [UIImage imageNamed:@"meIconPassengerBlue.png"];
                self.typeImageView = [[UIImageView alloc]init];
                self.typeImageView.frame = CGRectMake(2.0, 1.0, 10, 8);
                self.typeImageView.image = personImage;
                [self.backImageView addSubview:self.typeImageView];
                
                UIImage* manImage = [UIImage imageNamed:@"meIconBoyBlue.png"];
                UIImage* womanImage = [UIImage imageNamed:@"meIconGirlRed.png"];
                
                self.sexImageView = [[UIImageView alloc]init];
                self.sexImageView.frame = CGRectMake(CGRectGetMaxX(self.typeImageView.frame)+1, 2.0, manImage.size.width-5, manImage.size.height-5);
                if (self.model.userGender ==1) {
                    
                    self.sexImageView.image = manImage;
                }else {
                    
                    self.sexImageView.image = womanImage;
                    
                }
                [self.backImageView addSubview:self.sexImageView];
                
                self.ageLabel = [[UILabel alloc]init];
                self.ageLabel.frame = CGRectMake(CGRectGetMaxX(self.sexImageView.frame)+3, 0.5, 20.0, 10.0);
                self.ageLabel.text = [NSString stringWithFormat:@"%d",applyModel.userAge];
                self.ageLabel.textColor = [UIColor whiteColor];
                self.ageLabel.font = [UIFont systemFontOfSize:8.0];
                [self.backImageView addSubview:self.ageLabel];
                
                self.nickNameLabel = [[UILabel alloc]init];
                self.nickNameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatorImageView.frame)+15, 11, 100, 20.0);
                self.nickNameLabel.font = [UIFont systemFontOfSize:12];
                self.nickNameLabel.textColor = RGBCOLOR(70.0, 70.0, 70.0);
                self.nickNameLabel.text = [NSString stringWithFormat:@"%@",applyModel.userName];
                [self.contentView addSubview:self.nickNameLabel];
                
                
                self.stateLabel = [[UILabel alloc]init];
                self.stateLabel.frame = CGRectMake(180.0, 10.0, 60, 20.0);
                self.stateLabel.font = [UIFont systemFontOfSize:14];
                self.stateLabel.textColor = RGBCOLOR(254, 139, 12);
                [self.contentView addSubview:self.stateLabel];
                AppDelegate* appDelegate = [AppDelegate sharedAppDelegate];
                NSLog(@"%@",appDelegate.userModel);
                
                if ([applyModel.userId isEqualToString:appDelegate.userModel.userId])
                {
                    
                    
                    if (applyModel.status ==0) {
                        self.stateLabel.text = @"等待确认";
                        
                        
                    }else if (applyModel.status ==1){
                        
                        self.stateLabel.text = @"加入拼车";
                        
                        
                    }else if (applyModel.status ==-1){
                        
                        self.stateLabel.text = @"被拒绝";
                        
                    }else if (applyModel.status ==2){
                        
                        self.stateLabel.text = @"以上车";
                        
                    }else if (applyModel.status ==3){
                        
                        self.stateLabel.text = @"以支付";
                    }
                    
                    UIImage* cancelImage = [UIImage imageNamed:@"meBtCancel.png"];
                    self.cancelButton = [ActionButton buttonWithType:UIButtonTypeCustom];
                    self.cancelButton.frame = CGRectMake(CGRectGetMaxX(self.stateLabel.frame), (self.contentView.frame.size.height -cancelImage.size.height)/2.0+5,cancelImage.size.width ,cancelImage.size.height);
                    [self.cancelButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                    self.cancelButton.tag = CANCELBUTTON_TAG;
                    [self.cancelButton setImage:cancelImage forState:UIControlStateNormal];
                    self.cancelButton.applyModel = applyModel;
                    [self.contentView addSubview:self.cancelButton];
                }else {
                
                    NSLog(@"others");
                    
                
                }
                
        }
 
        }else if (self.model.userType ==2){
        
            AppDelegate* appDelegate = [AppDelegate sharedAppDelegate];
            NSLog(@"%@",appDelegate.userModel);
            
            //证明是乘客发起的拼车
            if ([appDelegate.userModel.userId isEqualToString:self.model.userId])
            {
                //头像👦
                self.avatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 8, 40, 40)];
                UIImage* defaultImage = [UIImage imageNamed:@"meDefaultPhoto60x60.png"];
                NSString* url = [NSString stringWithFormat:@"%@%@",SERVERimageURL,applyModel.userPhoto];
                [self.avatorImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:defaultImage];                self.avatorImageView.userInteractionEnabled = YES;
                self.avatorImageView.layer.masksToBounds = NO;
                self.avatorImageView.clipsToBounds = YES;
                self.avatorImageView.layer.cornerRadius =20.0;
                [self.contentView addSubview:self.avatorImageView];
                
                UIImage* backImage = [UIImage imageNamed:@"meBgblue.png"];
                self.backImageView = [[UIImageView alloc]init];
                self.backImageView.frame = CGRectMake(CGRectGetMinX(self.avatorImageView.frame)+5, CGRectGetMaxY(self.avatorImageView.frame)-7, backImage.size.width, backImage.size.height);
                self.backImageView.image = backImage;
                [self.contentView addSubview:self.backImageView];
                
                
                UIImage* personImage = [UIImage imageNamed:@"meIconPassengerBlue.png"];
                self.typeImageView = [[UIImageView alloc]init];
                self.typeImageView.frame = CGRectMake(2.0, 1.0, 10, 8);
                self.typeImageView.image = personImage;
                [self.backImageView addSubview:self.typeImageView];
                
                UIImage* manImage = [UIImage imageNamed:@"meIconBoyBlue.png"];
                UIImage* womanImage = [UIImage imageNamed:@"meIconGirlRed.png"];
                
                self.sexImageView = [[UIImageView alloc]init];
                self.sexImageView.frame = CGRectMake(CGRectGetMaxX(self.typeImageView.frame)+1, 2.0, manImage.size.width-5, manImage.size.height-5);
                if (self.model.userGender ==1) {
                    
                    self.sexImageView.image = manImage;
                }else {
                    
                    self.sexImageView.image = womanImage;
                    
                }
                [self.backImageView addSubview:self.sexImageView];
                
                self.ageLabel = [[UILabel alloc]init];
                self.ageLabel.frame = CGRectMake(CGRectGetMaxX(self.sexImageView.frame)+3, 0.5, 20.0, 10.0);
                self.ageLabel.text =[NSString stringWithFormat:@"%d",applyModel.userAge];
                self.ageLabel.textColor = [UIColor whiteColor];
                self.ageLabel.font = [UIFont systemFontOfSize:8.0];
                [self.backImageView addSubview:self.ageLabel];
                
                self.nickNameLabel = [[UILabel alloc]init];
                self.nickNameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatorImageView.frame)+15, 11, 100, 20.0);
                self.nickNameLabel.font = [UIFont systemFontOfSize:12];
                self.nickNameLabel.textColor = RGBCOLOR(70.0, 70.0, 70.0);
                self.nickNameLabel.text = [NSString stringWithFormat:@"%@",applyModel.userName];
                [self.contentView addSubview:self.nickNameLabel];
                
                
                //车的图片，只有车主才显示
                self.carImageView = [[UIImageView alloc]init];
                UIImage* carimagetwo = [UIImage imageNamed:@"meIconDriverBlue.png"];
                self.carImageView.frame = CGRectMake(CGRectGetMinX(self.nickNameLabel.frame), CGRectGetMaxY(self.nickNameLabel.frame)+7.0, carimagetwo.size.width, carimagetwo.size.height);
                self.carImageView.image = carimagetwo;
                NSString* carImageurl = [NSString stringWithFormat:@"%@%@",SERVERimageURL,applyModel.carBrandLogo];
                [self.carImageView setImageWithURL:[NSURL URLWithString:carImageurl] placeholderImage:carimagetwo];
                [self.contentView addSubview:self.carImageView];
                
                //车的名字 只有车主才显示
                self.carSeriousNameLabel = [[UILabel alloc]init];
                self.carSeriousNameLabel.frame = CGRectMake(CGRectGetMaxX(self.carImageView.frame)+7.0,CGRectGetMaxY(self.nickNameLabel.frame)+5.0 , 100.0,20.0);
                self.carSeriousNameLabel.font = [UIFont systemFontOfSize:10.0];
                self.carSeriousNameLabel.textColor = RGBCOLOR(160.0, 160.0,160.0);
                self.carSeriousNameLabel.text = [NSString stringWithFormat:@"%@",applyModel.carSeriesName];
                [self.contentView addSubview:self.carSeriousNameLabel];
                
                //车牌号 只有车主才显示
                self.carNumberLabel = [[UILabel alloc]init];
                self.carNumberLabel.frame = CGRectMake(CGRectGetMaxX(self.carSeriousNameLabel.frame)-75, self.carSeriousNameLabel.frame.origin.y, 180.0,20.0);
                self.carNumberLabel.font = [UIFont systemFontOfSize:10.0];
                self.carNumberLabel.textColor = RGBCOLOR(160.0, 160.0,160.0);
                self.carNumberLabel.text = [NSString stringWithFormat:@"%@ %@",applyModel.carLocation,applyModel.carNumber];
                [self.contentView addSubview:self.carNumberLabel];
                
                UIImage* acceptImage = [UIImage imageNamed:@"meBtAcceptPre.png"];
                UIImage* cancelImage = [UIImage imageNamed:@"meBtCancel.png"];
                UIImage* acceptimage = [UIImage imageNamed:@"meBtAccept.png"];
               
                NSLog(@"%@",self.selectModel);
                NSLog(@"%@",appDelegate.applyModel);
                
                self.selectModel =appDelegate.applyModel;
                
                
                if (self.selectModel ==appDelegate.applyModel &&self.selectModel)
                {
               
                    NSLog(@"staus = %d",applyModel.status);
                    
                    
                    if (applyModel.status ==1 )
                    {
                        
                        UIImage* joinImage = [UIImage imageNamed:@"meBtJoin.png"];
                        self.joinButton = [ActionButton buttonWithType:UIButtonTypeCustom];
                        self.joinButton.frame = CGRectMake(185.0, (self.contentView.frame.size.height - joinImage.size.height)/2.0+5, joinImage.size.width, joinImage.size.height);
                        [self.joinButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                        self.joinButton.tag = JOINBUTTON_TAG;
                        [self.joinButton setImage:joinImage forState:UIControlStateNormal];
                        self.joinButton.userInteractionEnabled = NO;
                        [self.contentView addSubview:self.joinButton];
                        
                    }else if (applyModel.status ==0){
                    
                        self.acceptButton = [ActionButton buttonWithType:UIButtonTypeCustom];
                        self.acceptButton.frame = CGRectMake(185, (self.contentView.frame.size.height -acceptimage.size.height)/2.0+5,acceptimage.size.width ,acceptimage.size.height);
                        [self.acceptButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                        self.acceptButton.tag = ACCEPTBUTTON_TAG;
                        [self.acceptButton setImage:acceptimage forState:UIControlStateNormal];
                        self.acceptButton.userInteractionEnabled = NO;
                        self.acceptButton.applyModel = applyModel;
                        [self.contentView addSubview:self.acceptButton];
                        
                        self.cancelButton = [ActionButton buttonWithType:UIButtonTypeCustom];
                        self.cancelButton.frame = CGRectMake(CGRectGetMaxX(self.acceptButton.frame)+3.0, (self.contentView.frame.size.height -cancelImage.size.height)/2.0+5,cancelImage.size.width ,cancelImage.size.height);
                        [self.cancelButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                        self.cancelButton.applyModel = applyModel;
                        self.cancelButton.tag = CANCELBUTTON_TAG;
                        [self.cancelButton setImage:cancelImage forState:UIControlStateNormal];
                        [self.contentView addSubview:self.cancelButton];
                }
                  
                }else {
                
                
                    if (applyModel.status ==1)
                    {
                        
                        
                        UIImage* joinImage = [UIImage imageNamed:@"meBtJoin.png"];
                        self.joinButton = [ActionButton buttonWithType:UIButtonTypeCustom];
                        self.joinButton.frame = CGRectMake(185.0, (self.contentView.frame.size.height - joinImage.size.height)/2.0+5, joinImage.size.width, joinImage.size.height);
                        [self.joinButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                        self.joinButton.tag = JOINBUTTON_TAG;
                        [self.joinButton setImage:joinImage forState:UIControlStateNormal];
                        self.joinButton.userInteractionEnabled = NO;
                        [self.contentView addSubview:self.joinButton];
                        
                    }
  
                    if (applyModel.status ==0)
                    {
                        
                        
                        self.acceptButton = [ActionButton buttonWithType:UIButtonTypeCustom];
                        self.acceptButton.frame = CGRectMake(185, (self.contentView.frame.size.height -acceptImage.size.height)/2.0+5,acceptImage.size.width ,acceptImage.size.height);
                        [self.acceptButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                        self.acceptButton.tag = ACCEPTBUTTON_TAG;
                        [self.acceptButton setImage:acceptImage forState:UIControlStateNormal];
                        self.acceptButton.applyModel = applyModel;
                        [self.contentView addSubview:self.acceptButton];
                        
                        self.cancelButton = [ActionButton buttonWithType:UIButtonTypeCustom];
                        self.cancelButton.frame = CGRectMake(CGRectGetMaxX(self.acceptButton.frame)+3.0, (self.contentView.frame.size.height -cancelImage.size.height)/2.0+5,cancelImage.size.width ,cancelImage.size.height);
                        [self.cancelButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                        self.cancelButton.applyModel = applyModel;
                        self.cancelButton.tag = CANCELBUTTON_TAG;
                        [self.cancelButton setImage:cancelImage forState:UIControlStateNormal];
                        [self.contentView addSubview:self.cancelButton];
                    }
                }
                
                
                
             
                
         //证明是乘客参与的拼车
            }else  {
                //头像👦
                self.avatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 8, 40, 40)];
                UIImage* defaultImage = [UIImage imageNamed:@"meDefaultPhoto60x60.png"];
                NSString* url = [NSString stringWithFormat:@"%@%@",SERVERimageURL,applyModel.userPhoto];
                [self.avatorImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:defaultImage];
                self.avatorImageView.userInteractionEnabled = YES;
                self.avatorImageView.layer.masksToBounds = NO;
                self.avatorImageView.clipsToBounds = YES;
                self.avatorImageView.layer.cornerRadius =20.0;
                [self.contentView addSubview:self.avatorImageView];
                
                UIImage* backImage = [UIImage imageNamed:@"meBgblue.png"];
                self.backImageView = [[UIImageView alloc]init];
                self.backImageView.frame = CGRectMake(CGRectGetMinX(self.avatorImageView.frame)+5, CGRectGetMaxY(self.avatorImageView.frame)-7, backImage.size.width, backImage.size.height);
                self.backImageView.image = backImage;
                [self.contentView addSubview:self.backImageView];
                
                
                UIImage* personImage = [UIImage imageNamed:@"meIconPassengerBlue.png"];
                self.typeImageView = [[UIImageView alloc]init];
                self.typeImageView.frame = CGRectMake(2.0, 1.0, 10, 8);
                self.typeImageView.image = personImage;
                [self.backImageView addSubview:self.typeImageView];
                
                UIImage* manImage = [UIImage imageNamed:@"meIconBoyBlue.png"];
                UIImage* womanImage = [UIImage imageNamed:@"meIconGirlRed.png"];
                
                self.sexImageView = [[UIImageView alloc]init];
                self.sexImageView.frame = CGRectMake(CGRectGetMaxX(self.typeImageView.frame)+1, 2.0, manImage.size.width-5, manImage.size.height-5);
                if (self.model.userGender ==1) {
                    
                    self.sexImageView.image = manImage;
                }else {
                    
                    self.sexImageView.image = womanImage;
                    
                }
                [self.backImageView addSubview:self.sexImageView];
                
                self.ageLabel = [[UILabel alloc]init];
                self.ageLabel.frame = CGRectMake(CGRectGetMaxX(self.sexImageView.frame)+3, 0.5, 20.0, 10.0);
                self.ageLabel.text = [NSString stringWithFormat:@"%d",applyModel.userAge];
                self.ageLabel.textColor = [UIColor whiteColor];
                self.ageLabel.font = [UIFont systemFontOfSize:8.0];
                [self.backImageView addSubview:self.ageLabel];
                
                self.nickNameLabel = [[UILabel alloc]init];
                self.nickNameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatorImageView.frame)+15, 11, 100, 20.0);
                self.nickNameLabel.font = [UIFont systemFontOfSize:12];
                self.nickNameLabel.textColor = RGBCOLOR(70.0, 70.0, 70.0);
                self.nickNameLabel.text =[NSString stringWithFormat:@"%@",applyModel.userName];
                [self.contentView addSubview:self.nickNameLabel];
                
                
                self.stateLabel = [[UILabel alloc]init];
                self.stateLabel.frame = CGRectMake(180.0, 10.0, 60, 20.0);
                self.stateLabel.font = [UIFont systemFontOfSize:14];
                self.stateLabel.textColor = RGBCOLOR(254, 139, 12);
                self.stateLabel.text = @"等待确认";
                [self.contentView addSubview:self.stateLabel];
                
                AppDelegate* appDelegate = [AppDelegate sharedAppDelegate];
                NSLog(@"%@",appDelegate.userModel);
                
                if ([applyModel.userId isEqualToString:appDelegate.userModel.userId])
                {
                    
                    
                    if (applyModel.status ==0) {
                        self.stateLabel.text = @"等待确认";
                        
                        
                    }else if (applyModel.status ==1){
                        
                        self.stateLabel.text = @"加入拼车";
                        
                        
                    }else if (applyModel.status ==-1){
                        
                        self.stateLabel.text = @"被拒绝";
                        
                    }else if (applyModel.status ==2){
                        
                        self.stateLabel.text = @"以上车";
                        
                    }else if (applyModel.status ==3){
                        
                        self.stateLabel.text = @"以支付";
                    }
                    
                    UIImage* cancelImage = [UIImage imageNamed:@"meBtCancel.png"];
                    self.cancelButton = [ActionButton buttonWithType:UIButtonTypeCustom];
                    self.cancelButton.frame = CGRectMake(CGRectGetMaxX(self.stateLabel.frame), (self.contentView.frame.size.height -cancelImage.size.height)/2.0+5,cancelImage.size.width ,cancelImage.size.height);
                    [self.cancelButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                    self.cancelButton.tag = CANCELBUTTON_TAG;
                    [self.cancelButton setImage:cancelImage forState:UIControlStateNormal];
                    self.cancelButton.applyModel = applyModel;
                    [self.contentView addSubview:self.cancelButton];
                }else {
                    
                NSLog(@"others");
                    
                    
                }
                
            }
        }
    }
    
 
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    if (self.hasCoustomApply ==YES) {
//        
//        if (self.clickButtonDelegate && [self.clickButtonDelegate respondsToSelector:@selector(refreshTableViewCell)]) {
//            [self.clickButtonDelegate refreshTableViewCell];
//            
//        }
//    }
    
    self.contentView.frame = CGRectMake(10.0, 10.0, self.frame.size.width- 10*2, self.frame.size.height);
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (self.carPoolStyle == CarPoolDetailTableViewFirstCell) {
        
        UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(4.0, 4.0)];
        CAShapeLayer* maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.contentView.layer.mask = maskLayer;
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.frame = CGRectMake(0.0,
                                      self.contentView.frame.size.height - 2,
                                      self.contentView.frame.size.width,
                                      2);
        bottomLine.backgroundColor = RGBCOLOR(238.0, 238.0, 238.0);
        bottomLine.tag = BOTTOM_LINE_TAG;
        [self.contentView addSubview:bottomLine];
        
        }else if (self.carPoolStyle == CarPoolDetailTableViewMiddleCell){
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.frame = CGRectMake(0.0,
                                      self.contentView.frame.size.height - 2,
                                      self.contentView.frame.size.width,
                                     2);
        bottomLine.backgroundColor = RGBCOLOR(238.0, 238.0, 238.0);
        bottomLine.tag = BOTTOM_LINE_TAG;
        [self.contentView addSubview:bottomLine];
    }
}

- (void)clickButton:(ActionButton*)bt
{
    NSString* userId = [AppDelegate sharedAppDelegate].userModel.userId;
    //车主
    if (self.model.userType ==1)
    {  //车主发起的线路点击的按钮动作
            if ([self.model.userId isEqualToString:userId])
            {
                if (bt.tag ==ACCEPTBUTTON_TAG)
                {
                 if (self.model.seatLeftCount >0)
                 {
                    if (self.clickButtonDelegate && [self.clickButtonDelegate respondsToSelector:@selector(refreshTableViewHeadView: acceptType:)])
                    {
                        
                        [self.clickButtonDelegate refreshTableViewHeadView:bt.applyModel acceptType:1];
                    }
                  }
               }
                
            }else //乘客参与的线路

           {
               
              if (self.clickButtonDelegate && [self.clickButtonDelegate respondsToSelector:@selector(cancelTableViewHeadView:cancelType:)])
               {
                   
                   [self.clickButtonDelegate coustomCancelTableViewHeadView:bt.applyModel cancelType:-2];
                   
               }
               
            }
            
   
//        发起者：同意1，取消-1
//        申请者：取消-2
    if (bt.tag ==CANCELBUTTON_TAG) {
            
      //车主对取消按钮的动作。
        if ([self.model.userId isEqualToString:userId])
        {
        //车主发起的活动，并对取消的动作
            if (self.clickButtonDelegate && [self.clickButtonDelegate respondsToSelector:@selector(cancelTableViewHeadView:cancelType:)])
            {
                
                [self.clickButtonDelegate cancelTableViewHeadView:bt.applyModel cancelType:-1];
                
            }
            
            
        }
        
    }
        
        
    }else  //乘客
    {
       
  
        if (bt.tag == CANCELBUTTON_TAG) {
            
            if ([self.model.userId isEqualToString:userId]) {
                
        if (self.clickButtonDelegate && [self.clickButtonDelegate respondsToSelector:@selector(coustomFAqiCancelTableViewHeadView:cancelType:)]) {
         
            [self.clickButtonDelegate coustomFAqiCancelTableViewHeadView:bt.applyModel cancelType:-1];
            
                    
                    
                }
                
                
                
            }else {
            
               //取消调用的方法 //车主参与取消方法
                if (self.clickButtonDelegate && [self.clickButtonDelegate respondsToSelector:@selector(cheZhuCancelTableViewHeadView:cancelType:)]) {
                    
                    [self.clickButtonDelegate cheZhuCancelTableViewHeadView:bt.applyModel cancelType:-2];
                    
                }
                
            
            }
            
        }
            
       //点击的当前行为乘客model ,乘客登录并点击接受按钮的动作
           
            if (bt.tag ==ACCEPTBUTTON_TAG)
            {
        
                if (self.clickButtonDelegate && [self.clickButtonDelegate respondsToSelector:@selector(coustomRefreshTableViewHeadView:coustomAcceptType:)])
                {
                    
                    [self.clickButtonDelegate coustomRefreshTableViewHeadView:bt.applyModel coustomAcceptType:1];
                    self.selectModel = bt.applyModel;
                    AppDelegate* delegate = [AppDelegate sharedAppDelegate];
                    delegate.applyModel = self.selectModel;
                    self.selectedRow = YES;
                }
         
            }
        
  }
}

- (void)chatMethod:(UIButton*)bt
{
    NSLog(@"chat begin");
    
    
}
@end
