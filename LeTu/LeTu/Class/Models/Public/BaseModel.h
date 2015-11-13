//
//  BaseModel.h
//  PGCBD
//
//  Created by screate on 13-5-16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

- (id)initWithString:(NSString *)string;
- (id)initWithData:(NSData *)data;
- (id)initWithDataDict:(NSDictionary *)dataDict;

@end
