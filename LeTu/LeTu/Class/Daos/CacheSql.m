//
//  CacheSql.m
//  E-learning
//
//  Created by cyberway on 13-9-25.
//
//

#import "CacheSql.h"
#import "CacheModel.h"

@implementation CacheSql

- (id)init
{
    if (self = [super init])
    {
        self.tableName = @"cache";
    }
    
    return self;
}

- (NSDictionary *)setModel:(CacheModel *)model
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dict setObject:model.key forKey:@"key"];
    [dict setObject:model.url forKey:@"url"];
    [dict setObject:model.content forKey:@"content"];
    [dict setObject:model.time forKey:@"time"];
    
    return dict;
}

- (CacheModel *)getModel:(id<PLResultSet>)rs
{
    CacheModel *model = [[CacheModel alloc]init];
    model.key = [rs objectForColumn:@"key"];
    model.url = [rs objectForColumn:@"url"];
    model.content = [rs objectForColumn:@"content"];
    model.time = [rs objectForColumn:@"time"];
    
    return model;
}


/************************基本方法******************/

//获取某个表全部字段
-(id<PLResultSet>) getAllFromTable:(NSString*)tablename
{
	PLSqliteDatabase *dataBase = [DataBase setup];
	
	id<PLResultSet> rs;
    NSString *findSql = [NSString stringWithFormat:@"select * from %@",tablename];
    rs = [dataBase executeQuery:findSql];
	return rs;
}
// 执行传参sql返回操作对象,executeQuery用于select查询语句
-(id<PLResultSet>) executeQuerySql:(NSString*)Sql
{
    PLSqliteDatabase *dataBase = [DataBase setup];
    id<PLResultSet> rs;
    rs = [dataBase executeQuery:Sql];
    return rs;
}
// 执行传参sql返回Bool对象，executeUpdate用于insert,delete,update语句
-(BOOL)executeOperateSql:(NSString*)Sql
{
    PLSqliteDatabase *dataBase = [DataBase setup];
    BOOL result = [dataBase executeUpdate: Sql];
    return result;
}
//查询数目的方法
- (int) countFromTable:(NSString*)tablename
{
    
    PLSqliteDatabase *dataBase = [DataBase setup];
    int Count = 0;
    
    id<PLResultSet>rs;
    NSString *findSql = [NSString stringWithFormat:@"select count(*) as Count from %@",tablename];
    rs = [dataBase executeQuery:findSql];
    while ([rs next])
    {
        Count = [[rs objectForColumn:@"Count"] intValue];
    }
    [rs close];
    return Count;
    
}
/************************基本方法******************/


//删除新消息数据
-(BOOL)DelAllNewMessage
{
    NSString *sql=[NSString stringWithFormat:@"delete from [NewMessageCache]"];
    return [self executeOperateSql:sql];
}


//新增新消息数据
-(BOOL)AddNewMessage:(NSString *)json
{
    NSString *sql=[NSString stringWithFormat:@"insert into [NewMessageCache](JsonStr)values('%@')",json];
    return [self executeOperateSql:sql];
    
}


//查询新消息数据
- (NSString*)getNewMessageJson
{
    
    PLSqliteDatabase *dataBase = [DataBase setup];
    NSString *jsonString;
    id<PLResultSet>rs;
    NSString *findSql = [NSString stringWithFormat:@"select * from [NewMessageCache]"];
    rs = [dataBase executeQuery:findSql];
    while ([rs next])
    {
        jsonString = [rs stringForColumn:@"JsonStr"] ;
    }
    [rs close];
    return jsonString;
}


//新增联系人对话消息数据
-(BOOL)itemAdd:(MessageModel *)messageModel
{
    NSLog(@"%@",messageModel.mId);
    NSString *sql=[NSString stringWithFormat:@"insert into [MessageHistory](mId,content,createdDate,mediaFile,msgType,targetId,targetName, targetType,userPhoto,userId,userName)values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",messageModel.mId,messageModel.content,messageModel.createdDate,messageModel.mediaFile,messageModel.msgType,messageModel.targetId,messageModel.targetName,messageModel.targetType,messageModel.userPhoto,messageModel.userId,messageModel.userName];
    
    return [self executeOperateSql:sql];
    
    
}


//是否已经有此条记录
- (int)ifHasMessageID:(NSString*)mID
{
    
    PLSqliteDatabase *dataBase = [DataBase setup];
    int Count = 0;
    
    id<PLResultSet>rs;
    NSString *findSql = [NSString stringWithFormat:@"select count(*) as Count from [MessageHistory] where mId='%@'",mID];
    rs = [dataBase executeQuery:findSql];
    while ([rs next])
    {
        Count = [rs intForColumn:@"Count"] ;
    }
    [rs close];
    return Count;
}
//获取最新数目
-(NSMutableArray *)getNewMessage:(int)count
{
    PLSqliteDatabase *dataBase = [DataBase setup];
    NSString *queryStr = [NSString stringWithFormat:@"select  * from [MessageHistory] order by createddate desc,mid desc limit '%d'",count];
	id<PLResultSet> rs;
	rs = [dataBase executeQuery:queryStr];
    
    if (arrays!=nil) {
        arrays=nil;
    }
    arrays = [[NSMutableArray alloc]initWithCapacity:1];
    
	//把rs中的数据库信息遍历到数组
	while ([rs next])
    {
        MessageModel *model=[[MessageModel alloc]init];
        model.mId=[rs stringForColumn:@"mId"];
        model.content=[rs stringForColumn:@"content"];
        model.createdDate=[rs stringForColumn:@"createdDate"];
        model.msgType=[rs stringForColumn:@"msgType"];
        if (! [rs isNullForColumn:@"mediaFile"])
        {
            model.mediaFile=[rs stringForColumn:@"mediaFile"];
        }
        model.targetId=[rs stringForColumn:@"targetId"];
        model.targetName=[rs stringForColumn:@"targetName"];
        model.targetType=[rs stringForColumn:@"targetType"];
        model.userPhoto=[rs stringForColumn:@"userPhoto"];
        model.userId=[rs stringForColumn:@"userId"];
        model.userName=[rs stringForColumn:@"userName"];

        [arrays addObject:model];

	}
	//关闭数据库
	[rs close];
	return arrays;
}

//获取此id之前的消息记录
-(NSMutableArray *)getHisMessageByID:(NSString*)messageID
{
    PLSqliteDatabase *dataBase = [DataBase setup];
    NSString *queryStr = [NSString stringWithFormat:@"select  * from [MessageHistory] where createddate<= (select createddate from  [MessageHistory]  where mid='%@') and mid!='%@' order by createddate desc,mid desc limit 20",messageID,messageID];
	id<PLResultSet> rs;
	rs = [dataBase executeQuery:queryStr];
    
    if (arrays!=nil) {
        arrays=nil;
    }
    arrays = [[NSMutableArray alloc]initWithCapacity:1];
    
	//把rs中的数据库信息遍历到数组
	while ([rs next])
    {
        MessageModel *model=[[MessageModel alloc]init];
        model.mId=[rs stringForColumn:@"mId"];
        model.content=[rs stringForColumn:@"content"];
        model.createdDate=[rs stringForColumn:@"createdDate"];
        model.msgType=[rs stringForColumn:@"msgType"];
        if (! [rs isNullForColumn:@"mediaFile"])
        {
            model.mediaFile=[rs stringForColumn:@"mediaFile"];
        }
        model.targetId=[rs stringForColumn:@"targetId"];
        model.targetName=[rs stringForColumn:@"targetName"];
        model.targetType=[rs stringForColumn:@"targetType"];
        model.userPhoto=[rs stringForColumn:@"userPhoto"];
        model.userId=[rs stringForColumn:@"userId"];
        model.userName=[rs stringForColumn:@"userName"];
        
        [arrays addObject:model];
        
	}
	//关闭数据库
	[rs close];
	return arrays;
}

//删除此id数据
-(BOOL)DelMessageByMsgID:(NSString*)msgID
{
    NSString *sql=[NSString stringWithFormat:@"delete from [MessageHistory] where mid='%@'",msgID];
    return [self executeOperateSql:sql];
}





@end
