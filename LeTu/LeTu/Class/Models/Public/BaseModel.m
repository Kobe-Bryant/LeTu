//
//  BaseModel.m
//  PGCBD
//
//  Created by screate on 13-5-16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel


- (id)initWithString:(NSString *)string
{
    if (self == [super init])
    {
        NSError *jsonParsingError;
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        [self initData:dataDict];
    }
    
    return self;
}

- (id)initWithData:(NSData *)data
{
    if (self == [super init])
    {
        NSError *jsonParsingError;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        [self initData:dataDict];
    }
    
    return self;
}

- (id)initWithDataDict:(NSDictionary *)dataDict
{
    if (self == [super init])
    {
        [self initData:dataDict];
    }
    
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"----------接口字段---%@------未发现----",key);
}

- (void)initData:(NSDictionary *)dataDict
{
    for (NSString *key in dataDict.keyEnumerator)
    {
        NSObject *value = [dataDict valueForKey:key];
        if (! [value isKindOfClass:[NSNull class]])
        {
           
            if ([key isEqualToString:@"id"])
            {
                [self setValue:[NSString stringWithFormat:@"%@",[dataDict valueForKey:key]] forKey:@"mId"];
            }
            else
            {
                [self setValue:[NSString stringWithFormat:@"%@",[dataDict valueForKey:key]] forKey:key];
            }
            //[self setValue:[dataDict valueForKey:key] forKey:key];
        }
    }
}

@end
