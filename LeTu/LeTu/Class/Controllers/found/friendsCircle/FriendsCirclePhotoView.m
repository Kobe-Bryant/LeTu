//
//  FriendsCirclePhotoView.m
//  LeTu
//
//  Created by DT on 14-5-27.
//
//

#import "FriendsCirclePhotoView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@implementation FriendsCirclePhotoView
@synthesize photoArray = _photoArray;
- (id)initWithFrame:(CGRect)frame width:(CGFloat)width;
{
    self = [super initWithFrame:frame];
    if (self) {
        _height = 0;
        _width = width;
        self.imageViewArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setPhotoArray:(NSArray *)photoArray
{
    _photoArray = photoArray;
    
    self.frame = CGRectMake(0, 0, _width, _height);
    /*
    if ([photoArray count] == 1) {
        ImageModel *imageModel = [photoArray objectAtIndex:0];
        float imgHeight = [imageModel.imgHeight floatValue];
        float imgWidth = [imageModel.imgWidth floatValue];
        float height = _width*imgHeight/imgWidth;
        EGOImageView *image = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, _width, height)];
        image.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        image.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, imageModel.imgUrl]];
        image.clipsToBounds = YES;
        image.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:image];
        _height = height+5;
    }else{
     //*/
    
        CGFloat x = 0;
        CGFloat y = 0;
        int index = 0;//计数
        int numberOfColumn = 2;//行
        NSInteger rows = [photoArray count] / numberOfColumn;//列
        NSInteger remainder = [photoArray count] % numberOfColumn;
        if (remainder>0) {
            rows++;
        }
        for (int i=0; i<rows; i++) {
            for (int j=0; j<numberOfColumn; j++) {
                if (index <[photoArray count]) {
                    ImageModel *imageModel = [photoArray objectAtIndex:index];
                    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, _width/2-3, _width/2-3)];
                    image.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
//                    image.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, imageModel.imgUrl]];
                    [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERImageURL, imageModel.imgUrl]] placeholderImage:PLACEHOLDER];
                    image.clipsToBounds = YES;
                    image.contentMode = UIViewContentModeScaleAspectFill;
                    [self addSubview:image];
                    if (_width == 292) {
//                    if (YES) {
                        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
                        image.userInteractionEnabled = YES;
                        [image addGestureRecognizer:gesture];
                    }
                    image.tag = index;
                    [self.imageViewArray addObject:image];
                    index++;
                    x += _width/2+2;
                }
            }
            x = 0;
            y+=_width/2+2;
        }
        _height = y;
//    }
    self.frame = CGRectMake(0, 0, _width, _height);
}
-(NSInteger)height
{
    return _height;
}
- (void)tapHandle:(UITapGestureRecognizer *)tap
{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity: [_photoArray count] ];
    for (int i = 0; i < [_photoArray count]; i++) {
        ImageModel *imageModel = [_photoArray objectAtIndex:i];
        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", SERVERImageURL, imageModel.imgUrl] ]; // 图片路径
        UIImageView * imageView = [self.imageViewArray objectAtIndex:i];
        photo.srcImageView = imageView;
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = photos; // 设置所有的图片
    browser.currentPhotoIndex =  tap.view.tag; // 弹出相册时显示的第一张图片是？
    [browser show];
}
@end
