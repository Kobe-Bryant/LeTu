//
//  BaseSql.h
//  FMDBDemo
//
//  Created by yemaozhe on 12-10-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBase.h"
#import "BaseDBModel.h"

@interface BaseSql : NSObject

@property (nonatomic, readonly) PLSqliteDatabase *dataBase;
@property (nonatomic, strong) NSString *tableName;

/************************基本方法******************/
//- (id<PLResultSet>)getAllFromTable:(NSString*)tablename;
//- (id<PLResultSet>)executeQuerySql:(NSString*)Sql;
//- (int)countFromTable:(NSString*)tablename;

/*******************业务方法**************/
//- (void)open;

- (NSMutableArray *)getAll;
- (BaseDBModel *)getByKey:(NSString *)key;
- (BOOL)addModel:(BaseDBModel *)model;
- (BOOL)delModel:(BaseDBModel *)model;
- (BOOL)upDateModel: (BaseDBModel *)model;
- (BOOL)addOrUpadte:(BaseDBModel *)model;
- (BOOL)isExist:(NSString *)key;

//- (void)close;

- (NSDictionary *)setModel:(BaseDBModel *)model;

- (BaseDBModel *)getModel:(id<PLResultSet>)rs;

@end
