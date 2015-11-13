//
//  DownLoadManage.h
//
//  Created by zc on 13-1-5.
//  Copyright (c) 2013年 cyberway. All rights reserved.
//  下载管理

#import <Foundation/Foundation.h>
#import "DownLoadModel.h"
#import "DownLoadDelegate.h"

typedef enum State
{
    DOWNLOADING = 1,
    PAUSE,
    FINISHED,
    ERR,
}State;

#define DOWNLOADMAX 20

@interface DownLoadManage : NSObject
{
    NSMutableArray *loadings;
    NSMutableArray *finsheds;
//    NSMutableArray *all;
//    int nowDownLoadCount;
    
    int getManageCount;
    
    NSMutableDictionary *reqDict;
}

@property (nonatomic, retain) id<DownLoadDelegate> delegate;

+ (id)getInstance;

- (NSMutableArray *)getLoadings;

- (NSMutableArray *)getFinsheds;

- (NSMutableArray *)getAll;

/**
 *  添加下载
 *  return -2.达到下载最大数 -1.下载过并完成 其他在loadings里的index (0 -n)
 */
- (int)addWithUrl:(NSString *)url title:(NSString *)title;

- (void)start:(int)index;

- (void)pauseWithIndex:(int)index;

- (void)removeWithIndex:(int)index isFinshed:(BOOL)isFinshed isDelFile:(BOOL)isDelFile;

- (void)removeWithModel:(DownLoadModel *)model isDelFile:(BOOL)isDelFile;

- (void)removeAll:(BOOL)isFinish;

- (DownLoadModel *)getDownLoadModelWithUrl:(NSString *)url;

- (BOOL)isDownLoad:(NSString *)url;

- (void)begin:(DownLoadModel *)model index:(int)index;

- (void)upDate:(DownLoadModel *)model index:(int)index;

- (void)pause:(DownLoadModel *)model index:(int)index;

- (void)finsh:(DownLoadModel *)model index:(int)index;

- (void)faild:(DownLoadModel *)model index:(int)index msg:(NSString *)msg;

@end
