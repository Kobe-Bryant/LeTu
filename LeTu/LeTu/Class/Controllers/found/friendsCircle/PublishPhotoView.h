//
//  PublishPhotoView.h
//  LeTu
//
//  Created by DT on 14-5-19.
//
//

#import <UIKit/UIKit.h>

@class PublishPhotoView;

@protocol PublishPhotoViewDelegate <NSObject>
@optional
- (void)photoView:(PublishPhotoView*)photoView index:(int)index isAddImage:(BOOL)isAddImage;
@end

/**
 *  发布图片View
 */
@interface PublishPhotoView : UIView

@property(nonatomic,assign)id<PublishPhotoViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *parameter;
@property (nonatomic, assign) BOOL isAddImage;

@end
