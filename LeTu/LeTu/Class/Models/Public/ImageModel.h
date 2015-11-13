//
//  ImageModel.h
//  AHAOrdering
//
//  Created by cyberway on 14-3-18.
//
//

#import "BaseModel.h"

@interface ImageModel : BaseModel

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageWidth;
@property (nonatomic, strong) NSString *imageHeight;

@property (nonatomic, strong) NSString *imgWidth;
@property (nonatomic, strong) NSString *imgHeight;
@property (nonatomic, strong) NSString *imgUrl;

@end
