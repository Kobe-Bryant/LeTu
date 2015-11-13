//
//  MyCarViewController.m
//  LeTu
//
//  Created by DT on 14-7-7.
//
//

#import "MyCarViewController.h"
#import "MyCarEditViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface MyCarViewController ()
{
    NSOperationQueue *queue;
}
@property(nonatomic,strong)UILabel *modelsKeyLabel;
@property(nonatomic,strong)UILabel *modelsValueLabel;
@property(nonatomic,strong)UILabel *seatingKeyLabel;
@property(nonatomic,strong)UILabel *seatingValueLabel;
@property(nonatomic,strong)UILabel *plateKeyLabel;
@property(nonatomic,strong)UILabel *plateValueLabel;
@property(nonatomic,strong)UILabel *kindKeyLabel;
@property(nonatomic,strong)UILabel *kindValueLabel;
@property(nonatomic,strong)UILabel *photoKeyLabel;
@property(nonatomic,strong)UIImageView *photoImage;

@property(nonatomic,strong)NSDictionary *dict;
@property(nonatomic,strong)NSMutableArray *valueArray;
@property(nonatomic,copy)NSString *brandId;
@end

@implementation MyCarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    [self setTitle:@"我的车库" andShowButton:YES];
    [self initRightBarButtonItem:[UIImage imageNamed:@"edit_carinformation_edit_normal"]
                highlightedImage:[UIImage imageNamed:@"edit_carinformation_edit_press"]];
    self.valueArray = [[NSMutableArray alloc] init];
    [self getCarDetail];
//    [self initViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)clickRightButton:(UIButton *)button
{
//    MyCarEditViewController *editVC = [[MyCarEditViewController alloc] init];
    MyCarEditViewController *editVC = [[MyCarEditViewController alloc] initWithDictionary:self.dict array:self.valueArray];
    [editVC setCallBack:^{
        [self getCarDetail];
    }];
    editVC.brandId = self.brandId;
    [self.navigationController pushViewController:editVC animated:YES];
}
/**
 *  初始化界面
 */
-(void)initViews
{
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 58, 300, 159)];
    backgroundImage.image = [UIImage imageNamed:@"edit_carinformation_bg"];
    backgroundImage.userInteractionEnabled = YES;
    [self.view addSubview:backgroundImage];
    
    self.modelsKeyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, 60, 25)];
    self.modelsKeyLabel.backgroundColor = [UIColor clearColor];
    self.modelsKeyLabel.textColor = [UIColor grayColor];
    self.modelsKeyLabel.font = [UIFont systemFontOfSize:15.0f];
    self.modelsKeyLabel.text = @"车型:";
    [backgroundImage addSubview:self.modelsKeyLabel];
    
    self.modelsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 60, 25)];
    self.modelsValueLabel.backgroundColor = [UIColor clearColor];
    self.modelsValueLabel.textColor = [UIColor blackColor];
    self.modelsValueLabel.font = [UIFont systemFontOfSize:15.0f];
    self.modelsValueLabel.text = [self.dict objectForKey:@"name"];
    [backgroundImage addSubview:self.modelsValueLabel];
    
    self.seatingKeyLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 60, 25)];
    self.seatingKeyLabel.backgroundColor = [UIColor clearColor];
    self.seatingKeyLabel.textColor = [UIColor grayColor];
    self.seatingKeyLabel.font = [UIFont systemFontOfSize:15.0f];
    self.seatingKeyLabel.text = @"座位数:";
    [backgroundImage addSubview:self.seatingKeyLabel];
    
    self.seatingValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 5, 60, 25)];
    self.seatingValueLabel.backgroundColor = [UIColor clearColor];
    self.seatingValueLabel.textColor = [UIColor blackColor];
    self.seatingValueLabel.font = [UIFont systemFontOfSize:15.0f];
    if ([self.valueArray count]==6 || [self.valueArray count]==5) {
        self.seatingValueLabel.text = [self.valueArray objectAtIndex:2];
    }
    [backgroundImage addSubview:self.seatingValueLabel];
    
    self.plateKeyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 40, 60, 25)];
    self.plateKeyLabel.backgroundColor = [UIColor clearColor];
    self.plateKeyLabel.textColor = [UIColor grayColor];
    self.plateKeyLabel.font = [UIFont systemFontOfSize:15.0f];
    self.plateKeyLabel.text = @"车牌:";
    [backgroundImage addSubview:self.plateKeyLabel];
    
    self.plateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 40, 100, 25)];
    self.plateValueLabel.backgroundColor = [UIColor clearColor];
    self.plateValueLabel.textColor = [UIColor blackColor];
    self.plateValueLabel.font = [UIFont systemFontOfSize:15.0f];
    if ([self.valueArray count]==6 || [self.valueArray count]==5) {
        self.plateValueLabel.text = [NSString stringWithFormat:@"%@%@",[self.valueArray objectAtIndex:0],[self.valueArray objectAtIndex:1]];
    }
    [backgroundImage addSubview:self.plateValueLabel];
    
    self.kindKeyLabel = [[UILabel alloc] initWithFrame:CGRectMake(172, 40, 60, 25)];
    self.kindKeyLabel.backgroundColor = [UIColor clearColor];
    self.kindKeyLabel.textColor = [UIColor grayColor];
    self.kindKeyLabel.font = [UIFont systemFontOfSize:15.0f];
    self.kindKeyLabel.text = @"车种:";
    [backgroundImage addSubview:self.kindKeyLabel];
    
    self.kindValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 40, 100, 25)];
    self.kindValueLabel.backgroundColor = [UIColor clearColor];
    self.kindValueLabel.textColor = [UIColor blackColor];
    self.kindValueLabel.font = [UIFont systemFontOfSize:15.0f];
    if ([self.valueArray count]==6 || [self.valueArray count]==5) {
        self.kindValueLabel.text = [self.valueArray objectAtIndex:3];
    }
    [backgroundImage addSubview:self.kindValueLabel];
    
    self.photoKeyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 75, 60, 25)];
    self.photoKeyLabel.backgroundColor = [UIColor clearColor];
    self.photoKeyLabel.textColor = [UIColor grayColor];
    self.photoKeyLabel.font = [UIFont systemFontOfSize:15.0f];
    self.photoKeyLabel.text = @"照片:";
    [backgroundImage addSubview:self.photoKeyLabel];
    
    self.photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(55, 75, 70, 70)];
//    self.photoImage.image = PLACEHOLDER;
    [self.photoImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, [self.dict objectForKey:@"photo"]]] placeholderImage:PLACEHOLDER];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    self.photoImage.userInteractionEnabled = YES;
    [self.photoImage addGestureRecognizer:gesture];
    [backgroundImage addSubview:self.photoImage];
}
/**
 *  获取汽车详情
 */
-(void)getCarDetail
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
    [self startLoading];
    NSString *requestUrl = [NSString stringWithFormat:@"%@myCar/myCarService.jws?carDetail", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    [self stopLoading];
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
    if (tag==1) {
        self.dict = [data objectForKey:@"obj"];
        self.brandId = [self.dict objectForKey:@"brandId"];
        NSString *content = [self.dict objectForKey:@"content"];
        NSArray *array = [content componentsSeparatedByString:@","];
        [self.valueArray removeAllObjects];
        for (NSString *string in array) {
            [self.valueArray addObject:string];
        }
        [self.valueArray addObject:[self.dict objectForKey:@"name"]];
        [self initViews];
    }
}
-(void)reponseFaild:(NSInteger)tag
{
    if (iOS_7_Above) {
        CGRect frame = self.view.frame;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }
    [self stopLoading];
}

- (void)tapHandle:(UITapGestureRecognizer *)tap
{
    [self showBigImage:[NSString stringWithFormat:@"%@%@", SERVERImageURL,[self.dict objectForKey:@"photo"]] imageView:self.photoImage];
}
/**
 *  显示大图
 *
 *  @param urlString 图片路径
 *  @param imageView 图片imageView
 */
-(void)showBigImage:(NSString*)urlString imageView:(UIImageView*)imageView
{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:urlString]; // 图片路径
    //    UIImageView * imageView = self.headImgView;
    photo.srcImageView = imageView;
    [photos addObject:photo];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = photos; // 设置所有的图片
    browser.currentPhotoIndex =  0; // 弹出相册时显示的第一张图片是？
    [browser show];
}
@end
