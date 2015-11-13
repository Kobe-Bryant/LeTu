//
//  Paging.h
//  CBD
//
//  Created by screate on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Paging : NSObject{

int pageSize;//每页多少条
long rowCount;//总记录数

long current;//当前页
long page_Count;//总页数
BOOL isEnd;

}

@property(nonatomic,retain) NSString *TotalCount;
@property(nonatomic,retain) NSString *PageCount;

@property(nonatomic) int pageSize;
@property(nonatomic) long rowCount;//总记录数
@property(nonatomic) long current;//当前页
@property(nonatomic) long page_Count;//总页数
@property(nonatomic) BOOL isEnd;

@end
