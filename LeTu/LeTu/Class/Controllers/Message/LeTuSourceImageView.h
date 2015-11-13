//
//  LeTuUserHeadImageView.h
//  LeTu
//
//  Created by Jason on 2014/7/14.
//
//

#import "EGOImageView.h"

@protocol LeTuSourceImageViewPhotoBrowserDataSource <NSObject>
/** photo path s */
- (NSArray *)photoPathStrings;
@end

@interface LeTuSourceImageView : EGOImageView

@property(strong, nonatomic)NSString *sourceImagePath;
- (id)initWithPhotoPath:(NSString *)photoPath placeholderImage:(UIImage*)anImage;

@end
