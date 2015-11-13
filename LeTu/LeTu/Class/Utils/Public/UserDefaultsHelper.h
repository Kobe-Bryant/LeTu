//
//  UserDefaultsHelper.h
//  CBD
//
//  Created by screate on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsHelper : NSObject
{
}
+(NSString*)getStringForKey:(NSString*)key;
+(NSInteger)getIntForkey:(NSString*)key;
+(NSDictionary*)getDictForKey:(NSString*)key;
+(NSArray*)getArrayForKey:(NSString*)key;
+(BOOL)getBoolForKey:(NSString*)key;
+(void)setStringForKey:(NSString*)value:(NSString*)key;
+(void)setIntForKey:(NSInteger)value:(NSString*)key;
+(void)setDictForKey:(NSDictionary*)value:(NSString*)key;
+(void)setArrayForKey:(NSArray*)value:(NSString*)key;
+(void)setBoolForKey:(BOOL)value:(NSString*)key;

@end
