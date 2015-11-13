//
//  BaseSql.m
//  FMDBDemo
//
//  Created by yemaozhe on 12-10-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DownLoadSql.h"
#import "DownLoadModel.h"
#import "UserDefaultsHelper.h"
#import "DownLoadModel.h"

@implementation DownLoadSql

- (id)init
{
    if (self = [super init])
    {
        self.tableName = @"curriculum_download";
    }
    
    return self;
}

//获取未完成的下载(倒序)
-(NSMutableArray *)getDownLoading
{
	id<PLResultSet> rs;
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where Key like '%@-%%' and state != 3 order by time desc",
                     self.tableName, [UserDefaultsHelper getStringForKey:@"userid"]];
	rs = [self.dataBase executeQuery:sql];
	
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

//获取完成的下载(倒序)
-(NSMutableArray *)getDownLoadFinished
{
	id<PLResultSet> rs;
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where Key like '%@-%%' and State = 3 order by time desc",
                     self.tableName, [UserDefaultsHelper getStringForKey:@"userid"]];
	rs = [self.dataBase executeQuery:sql];
    
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

//全部正在下载改为暂停
-(BOOL)upDownLoadModelPause
{
    NSString *sql=[NSString stringWithFormat:@"update %@ set State=2 where state!=3", self.tableName];
    return [self.dataBase executeUpdate:sql];
}

-(BOOL)isExistDownLoadModel:(NSString *)key
{
    int Count = 0;
    
    id<PLResultSet>rs;
    NSString *findSql = [NSString stringWithFormat:@"select count(*) as count from %@ where key=%@", self.tableName, key];
    rs = [self.dataBase executeQuery:findSql];
    if ([rs next])
    {
        Count = [[rs objectForColumn:@"count"] intValue];
    }
    [rs close];
    
    return Count > 1 ? YES : NO;
   
}

- (NSDictionary *)setModel:(DownLoadModel *)model
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dict setObject:model.key forKey:@"key"];
    [dict setObject:model.title forKey:@"title"];
    [dict setObject:model.name forKey:@"name"];
    [dict setObject:[NSNumber numberWithLongLong:model.currSize] forKey:@"currSize"];
    [dict setObject:[NSNumber numberWithLongLong:model.totalSize] forKey:@"totalSize"];
    [dict setObject:model.url forKey:@"url"];
    [dict setObject:[NSNumber numberWithInt:model.state] forKey:@"state"];
    [dict setObject:model.time forKey:@"time"];
    
    return dict;
}

- (DownLoadModel *)getModel:(id<PLResultSet>)rs
{
    DownLoadModel *model = [[DownLoadModel alloc]init];
    model.key = [rs objectForColumn:@"key"];
    model.title = [rs objectForColumn:@"title"];
    model.name = [rs objectForColumn:@"name"];
    model.currSize = [rs intForColumn:@"currSize"];
    model.totalSize = [rs intForColumn:@"totalSize"];
    model.url = [rs objectForColumn:@"url"];
    model.state = [rs intForColumn:@"state"];
    model.time = [rs objectForColumn:@"time"];
    
    return model;
}

@end
