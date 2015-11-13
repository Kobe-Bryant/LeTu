//
//  FaceView.h
//  AHAOrdering
//
//  Created by cyberway on 14-4-3.
//
//

#import <UIKit/UIKit.h>

@class FaceView;

@protocol FaceViewDelegate <NSObject>

- (void)faceView:(FaceView *)faceView faceIndex:(int)faceIndex;

@end

@interface FaceView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) id<FaceViewDelegate> faceDelegate;
@property BOOL isShow;

- (void)show;

- (void)dismiss;

@end
