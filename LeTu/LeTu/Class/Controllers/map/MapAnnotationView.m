//
//  MapAnnotationView.m
//  LeTu
//
//  Created by DT on 14-6-17.
//
//

#import "MapAnnotationView.h"
#import "DTImage+Category.h"
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"
#import "objc/runtime.h"

static char operationKey;

@interface MapAnnotationView()

//@property(nonatomic,strong)UIImage *basemapImage;
@property(nonatomic,strong)UIImage *roundImage;

@end

@implementation MapAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setFacePath:(NSString*)facePath
{
//    self.basemapImage = self.image;
    [self cancelCurrentImageLoad];
    
    if (facePath) {
        __weak MapAnnotationView *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:[NSURL URLWithString:facePath] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image) {
                    wself.roundImage = [image imageAsCircle:YES withDiamter:50.f borderColor:nil borderWidth:0.0 shadowOffSet:CGSizeZero];
                    wself.image = [wself.image imageWithWaterMask:wself.roundImage inRect:CGRectMake(1.5, 1.5, 28.5, 28.5)];
                    [wself setNeedsDisplay];
                }
            });
        }];
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
- (void)cancelCurrentImageLoad {
    // Cancel in progress downloader from queue
    id <SDWebImageOperation> operation = objc_getAssociatedObject(self, &operationKey);
    if (operation) {
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
@end
