//
//  MyselfCollectViewController.m
//  LeTu
//
//  Created by DT on 14-6-10.
//
//

#import "MyselfCollectViewController.h"
#import "DTGridTableView.h"
#import "MapPhotoView.h"
#import "MapCarSharingModel.h"
#import "MapCarShareDetailViewController.h"

@interface MyselfCollectViewController ()<DTGridTableViewDatasource,DTGridTableViewDelegate>
{
    NSOperationQueue *queue;
}
@property(nonatomic,strong)DTGridTableView *gridTableView;
@property(nonatomic,assign)int type;
@property(nonatomic,strong)NSMutableArray *itemsArray;
@end

@implementation MyselfCollectViewController

-(id)initWithType:(int)type
{
    self = [super init];
    if (self) {
        self.type = type;
        self.itemsArray = [[NSMutableArray alloc] init];
        self.view.backgroundColor = RGBCOLOR(239, 238, 244);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.type == 1) {
        [self setTitle:@"我发起的" andShowButton:YES];
    }else if (self.type ==2){
        [self setTitle:@"我收藏的" andShowButton:YES];
    }
    [self initGridTableView];
    [self fillData:self.type];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  初始化照片墙View
 */
-(void)initGridTableView
{
    int height = [UIScreen mainScreen].bounds.size.height-STATUSBAR_HEIGHT-NAVBAR_HEIGHT;
    if (self.gridTableView) {
        self.gridTableView.hidden = NO;
    }else{
        self.gridTableView = [[DTGridTableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, FRAME_WIDTH, height)];
        self.gridTableView.backgroundColor = [UIColor whiteColor];
//        self.gridTableView.backgroundColor = RGBCOLOR(239, 238, 244);
        self.gridTableView.datasource = self;
        self.gridTableView.delegate = self;
        [self.view addSubview:self.gridTableView];
    }
}

#pragma mark DTGridTableViewDatasource;
- (NSInteger)numberOfGridsInRow
{
    return 3;
}
- (NSInteger)numberOfGrids
{
    return [self.itemsArray count];
}
- (UIView*)viewAtIndex:(NSInteger)index size:(CGSize)size
{
    MapPhotoView *view = [[MapPhotoView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)
                                                       block:^(int index) {
                                                           MapCarSharingModel *model = [self.itemsArray objectAtIndex:index];
                                                           MapCarShareDetailViewController *detailVC = [[MapCarShareDetailViewController alloc] initWithModel:model];
                                                           detailVC.status = 2;
                                                           [self.navigationController pushViewController:detailVC animated:YES];
                                                       }];
    view.layer.borderColor = [UIColor grayColor].CGColor;
    view.layer.borderWidth = 0.2;
    return view;
}
#pragma mark DTGridTableViewDelegate;
- (void)gridView:(UIView*)gridView gridViewForRowAtIndexPath:(int)index;
{
    MapPhotoView *grid = (MapPhotoView*)gridView;
    if (index < [self.itemsArray count]) {
        MapCarSharingModel *model = [self.itemsArray objectAtIndex:index];
        grid.index = index;
        grid.model = model;
        grid.distanceLabel.text = model.userName;
    }

}
/**
 *  查询收藏、发起数据
 *
 *  @param type 类型 1:我发起的 2:我收藏的
 */
-(void)fillData:(int)type
{
    [self startLoading];
    self.gridTableView.hidden = YES;
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@carsharing/carSharingService.jws?myList", SERVERAPIURL];
    if (queue == nil)
    {
        queue = [[ NSOperationQueue alloc ] init];
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:[UserDefaultsHelper getStringForKey:@"key"] forKey:@"l_key"];
    [paramDict setObject:[NSString stringWithFormat:@"%i",type] forKey:@"type"];
    
    RequestParseOperation *operation = [[RequestParseOperation alloc] initWithURLAndPostParams:requestUrl delegate:self params:paramDict];
    operation.RequestTag = 1;
    [queue addOperation :operation];
}
-(void)reponseDatas:(NSDictionary *)data operationTag:(NSInteger)tag
{
    if (tag ==1) {//黑名单列表
        MapCarSharingModel *model = nil;
        NSDictionary *objDict = [data objectForKey:@"list"];
        for (NSDictionary *dict in objDict) {
            model = [[MapCarSharingModel alloc] initWithDataDict:dict];
            [self.itemsArray addObject:model];
        }
        [self stopLoading];
        self.gridTableView.hidden = NO;
        [self.gridTableView reloadData];
    }
}
@end
