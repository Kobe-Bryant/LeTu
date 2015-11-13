//
//  BaseModel.h
//  SBD
//
//  Created by ewit song on 12-11-6.
//
//

#import <Foundation/Foundation.h>
#import "BaseDBModel.h"

@interface DownLoadModel : BaseDBModel

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *suffix;
@property long long currSize;
@property long long totalSize;
@property int state;
@property NSString *time;

@end
