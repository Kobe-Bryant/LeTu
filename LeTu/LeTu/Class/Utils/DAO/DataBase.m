//
//  DataBase.m
//  BookManage
//
//  Created by WangChao on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataBase.h"
#import <PlausibleDatabase/PlausibleDatabase.h>

static PLSqliteDatabase * dbPointer;

@implementation DataBase

//单例

+ (PLSqliteDatabase *) setup
{
	if (dbPointer) {
		return dbPointer;
	}
	
	NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
	NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *realPath = [documentPath stringByAppendingPathComponent:@"LeTu.sqlite"];
	
//	NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"DownLoad" ofType:@"sqlite"];
    NSString *sourcePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"LeTu.sqlite"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:realPath]) {
		NSError *error;
		if (![fileManager copyItemAtPath:sourcePath toPath:realPath error:&error]) {
			NSLog(@"%@",[error localizedDescription]);
		}
	}
	
	NSLog(@"复制DownLoad到路径：%@成功。",realPath);
	
	//把dbpointer地址修改为可修改的realPath。
	dbPointer = [[PLSqliteDatabase alloc] initWithPath:realPath];
	
	[dbPointer open];
	
	return dbPointer;
}

+(void) close
{
	if (dbPointer) {
		[dbPointer close];
		dbPointer = NULL;
	}
}

@end
