//
//  BaseSql.m
//  FMDBDemo
//
//  Created by yemaozhe on 12-10-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseSql.h"
#import "UserDefaultsHelper.h"
#import <objc/message.h>

@implementation BaseSql

@synthesize dataBase;
@synthesize tableName;

/************************基本方法******************/

- (id)init
{
    if (self = [super init])
    {
        dataBase = [DataBase setup];
    }
    
    return self;
}

////获取某个表全部字段
//-(id<PLResultSet>) getAllFromTable:(NSString*)tablename
//{
//	id<PLResultSet> rs;
//    NSString *findSql = [NSString stringWithFormat:@"select * from %@",tablename];
//    rs = [dataBase executeQuery:findSql];
//	return rs;
//}
//
//// 执行传参sql返回操作对象,executeQuery用于select查询语句
//-(id<PLResultSet>) executeQuerySql:(NSString*)Sql
//{
//    id<PLResultSet> rs;
//    rs = [dataBase executeQuery:Sql];
//    return rs;
//}
//
//// 执行传参sql返回Bool对象，executeUpdate用于insert,delete,update语句
//-(BOOL)executeOperateSql:(NSString*)Sql
//{
//    BOOL result = [dataBase executeUpdate: Sql];
//    return result;
//}
//
////查询数目的方法
//- (int) countFromTable:(NSString*)tablename
//{
//    int Count = 0;
//
//    id<PLResultSet>rs;
//    NSString *findSql = [NSString stringWithFormat:@"select count(*) as count from %@",tablename];
//    rs = [dataBase executeQuery:findSql];
//    if ([rs next]) 
//    {
//    Count = [[rs objectForColumn:@"count"] intValue];
//    }
//    [rs close];
//    return Count;
//
//}
/************************基本方法******************/


/*******************业务方法**************/

//- (void)open
//{
//    dataBase = [DataBase setup];
//}

//获取全部全部
-(NSMutableArray *)getAll
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@", tableName];
	id<PLResultSet> rs = [dataBase executeQuery:sql];
	
    NSMutableArray *arrays = [[NSMutableArray alloc]initWithCapacity:1];
    
	//把rs中的数据库信息遍历到数组
	while ([rs next])
    {
        [arrays addObject:[self getModel:rs]];
	}
	//关闭数据库
	[rs close];
	return arrays;
}

-(BaseDBModel *)getByKey:(NSString *)key
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where key", tableName];
	id<PLResultSet> rs = [dataBase executeQuery:sql];
    
    if ([rs next])
    {
        return [self getModel:rs];
    }
    
    return nil;
}

//新增记录
-(BOOL)addModel:(BaseDBModel *)model
{
    NSDictionary *dict = [self setModel:model];
    NSEnumerator *keys = dict.keyEnumerator;
    
    NSMutableString *names = [[NSMutableString alloc] initWithCapacity:10];
    NSMutableString *values = [[NSMutableString alloc] initWithCapacity:10];
    
    id value = nil;
    for (NSString *key in keys)
    {
        if ([names length] > 0)
        {
            [names appendString:@","];
            [values appendString:@","];
        }
        [names appendString:key];
        
        value = [dict valueForKey:key];
        if ([value isKindOfClass:[NSString class]])
        {
            [values appendFormat:@"'%@'", value];
        }
        else if ([value isKindOfClass:[NSNumber class]])
        {
            const char * pObjCType = [((NSNumber*)value) objCType];
            if (strcmp(pObjCType, @encode(int))  == 0)
            {
                [values appendFormat:@"%d", [value intValue]];
            }
            else if (strcmp(pObjCType, @encode(float)) == 0)
            {
                [values appendFormat:@"%f", [value floatValue]];
            }
            else if (strcmp(pObjCType, @encode(double))  == 0)
            {
                [values appendFormat:@"%f", [value doubleValue]];
            }
            else if (strcmp(pObjCType, @encode(BOOL)) == 0)
            {
                [values appendFormat:@"%i", [value boolValue]];
            }
            else if (strcmp(pObjCType, @encode(long)) == 0)
            {
                [values appendFormat:@"%li", [value longValue]];
            }
            else if (strcmp(pObjCType, @encode(long long)) == 0) {
                [values appendFormat:@"%lld", [value longLongValue]];
            }
        }
    }
    
    NSString *sql=[NSString stringWithFormat:@"insert into %@ (%@) values(%@)", tableName, names, values];
    
    return [dataBase executeUpdate:sql];
}

//删除记录
-(BOOL)delModel:(BaseDBModel *)model
{
    NSString *sql=[NSString stringWithFormat:@"delete from %@ where key='%@'", tableName, model.key];
    
    return [dataBase executeUpdate:sql];
}

//更新记录
-(BOOL)upDateModel:(BaseDBModel *)model
{
    NSDictionary *dict = [self setModel:model];
    NSEnumerator *keys = dict.keyEnumerator;
    
    NSMutableString *names = [[NSMutableString alloc] initWithCapacity:10];
    
    id value = nil;
    for (NSString *key in keys)
    {
        if ([names length] > 0)
        {
            [names appendString:@","];
        }
        [names appendFormat:@"%@=", key];
        
        value = [dict valueForKey:key];
        if ([value isKindOfClass:[NSString class]])
        {
            [names appendFormat:@"'%@'", value];
        }
        else if ([value isKindOfClass:[NSNumber class]])
        {
            const char * pObjCType = [((NSNumber*)value) objCType];
            if (strcmp(pObjCType, @encode(int))  == 0)
            {
                [names appendFormat:@"%d", [value intValue]];
            }
            else if (strcmp(pObjCType, @encode(float)) == 0)
            {
                [names appendFormat:@"%f", [value floatValue]];
            }
            else if (strcmp(pObjCType, @encode(double))  == 0)
            {
                [names appendFormat:@"%f", [value doubleValue]];
            }
            else if (strcmp(pObjCType, @encode(BOOL)) == 0)
            {
                [names appendFormat:@"%i", [value boolValue]];
            }
            else if (strcmp(pObjCType, @encode(long)) == 0)
            {
                [names appendFormat:@"%li", [value longValue]];
            }
            else if (strcmp(pObjCType, @encode(long long)) == 0) {
                [names appendFormat:@"%lld", [value longLongValue]];
            }
        }
    }
    
    NSString *sql=[NSString stringWithFormat:@"update %@ set %@ where key='%@'", tableName, names, model.key];
    return [dataBase executeUpdate:sql];
}

- (BOOL)addOrUpadte:(BaseDBModel *)model
{
    if ([self isExist:model.key])
    {
        return [self addModel:model];
    }
    
    return [self upDateModel:model];
}

-(BOOL)isExist:(NSString *)key
{
    int count = 0;
    
    id<PLResultSet>rs;
    NSString *findSql = [NSString stringWithFormat:@"select count(*) as count from %@ where key='%@'", tableName, key];
    rs = [dataBase executeQuery:findSql];
    if ([rs next])
    {
        count = [[rs objectForColumn:@"count"] intValue];
    }
    [rs close];
    
    return count > 0 ? YES : NO;
   
}

- (int)count
{
    int count = 0;
    
    id<PLResultSet>rs;
    NSString *findSql = [NSString stringWithFormat:@"select count(*) as count from %@", tableName];
    rs = [dataBase executeQuery:findSql];
    if ([rs next])
    {
        count = [[rs objectForColumn:@"count"] intValue];
    }
    [rs close];
    return count;
}

//- (void)close
//{
//    [dataBase close];
//    dataBase = nil;
//}

/*******************业务方法**************/

- (NSDictionary *)setModel:(BaseDBModel *)model
{
    return nil;
}

- (BaseDBModel *)getModel:(id<PLResultSet>)rs
{
    return nil;
}

@end
