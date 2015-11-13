//
//  BaseSql.h
//  FMDBDemo
//
//  Created by yemaozhe on 12-10-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSql.h"
#import "BaseModel.h"
#import "DownLoadModel.h"

@interface DownLoadSql : BaseSql

-(NSMutableArray *)getDownLoading;
-(NSMutableArray *)getDownLoadFinished;
-(BOOL)upDownLoadModelPause;
-(BOOL)isExistDownLoadModel:(NSString *)key;

@end
