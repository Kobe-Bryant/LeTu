//
//  CacheModel.h
//  E-learning
//
//  Created by cyberway on 13-9-25.
//
//

#import "BaseDBModel.h"

@interface CacheModel : BaseDBModel

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *time;

@end
