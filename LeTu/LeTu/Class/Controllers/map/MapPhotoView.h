//
//  MapPhotoView.h
//  LeTu
//
//  Created by DT on 14-5-23.
//
//

#import <UIKit/UIKit.h>
#import "MapCarSharingModel.h"

typedef void (^PhotoViewBack)(int index);

@interface MapPhotoView : UIView
{
    PhotoViewBack callBack;
}
@property(nonatomic,assign)int index;
@property(nonatomic,strong)UILabel *distanceLabel;

@property(nonatomic,strong)MapCarSharingModel *model;
- (id)initWithFrame:(CGRect)frame block:(PhotoViewBack)block;

@end
