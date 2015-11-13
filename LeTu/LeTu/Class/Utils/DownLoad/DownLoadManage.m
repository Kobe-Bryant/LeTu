//
//  DownLoadManage.m
//
//  Created by zc on 13-1-5.
//  Copyright (c) 2013年 cyberway. All rights reserved.
//  下载管理

#import "DownLoadManage.h"
#import "DownLoadRequest.h"
#import "FileUtil.h"
#import "DownLoadSql.h"
#import "UserDefaultsHelper.h"
#import "Utility.h"

static DownLoadManage *downLoadManage = nil;

@implementation DownLoadManage

@synthesize delegate;

- (id)init
{
    if (self = [super init])
    {
        reqDict = [[NSMutableDictionary alloc] initWithCapacity:4];
        [self getLoadings];
        [self getFinsheds];
        
        
    }
    
    return self;
}

+ (id)getInstance
{
    @synchronized(self)
    {
        if (downLoadManage == nil)
        {
            downLoadManage = [[self alloc] init];
        }
    }
    return downLoadManage;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (downLoadManage == nil)
        {
            downLoadManage = [super allocWithZone:zone];
            return  downLoadManage;
        }
    }
    return nil;
}

- (NSMutableArray *)getLoadings
{
    DownLoadSql *downLoadSql = [[DownLoadSql alloc] init];
    loadings = [downLoadSql getDownLoading];
    
    if (loadings == nil)
    {
        loadings = [[NSMutableArray alloc] initWithCapacity:3];
    }
    else
    {
        if (getManageCount == 0)
        {
            for (DownLoadModel *model in loadings)
            {
                model.state = PAUSE;
            }
            [downLoadSql upDownLoadModelPause];
        }
    }
    getManageCount++;
    return loadings;
}

- (NSMutableArray *)getFinsheds
{
    DownLoadSql *downLoadSql = [[DownLoadSql alloc] init];
    finsheds = [downLoadSql getDownLoadFinished];
    if (finsheds == nil)
    {
        finsheds = [[NSMutableArray alloc] initWithCapacity:3];
    }
    
    return finsheds;
}

- (NSMutableArray *)getAll
{
    NSMutableArray *all = [[NSMutableArray alloc] initWithCapacity:3];
    [all addObjectsFromArray:[self getLoadings]];
    [all addObjectsFromArray:[self getFinsheds]];
    
    return all;
}

- (int)addWithUrl:(NSString *)url title:(NSString *)title
{
    DownLoadModel *model = nil;
    
    for (int i = 0; i < finsheds.count; i++)
    {
        model = [finsheds objectAtIndex:i];
//        if ([model.url isEqualToString:url])
        if ([model.key isEqualToString:[NSString stringWithFormat:@"%@-%@", [UserDefaultsHelper getStringForKey:@"userid"], [Utility md5:url]]])
        {
            return -1;
        }
    }
    
    for (int i = 0; i < loadings.count; i++)
    {
        model = [loadings objectAtIndex:i];
//        if ([model.url isEqualToString:url])
        if ([model.key isEqualToString:[NSString stringWithFormat:@"%@-%@", [UserDefaultsHelper getStringForKey:@"userid"], [Utility md5:url]]])
        {
            return  i;
        }
    }
    
    if ((finsheds.count + loadings.count) == DOWNLOADMAX)
    {
        return -2;
    }
    
    model = [[DownLoadModel alloc] init];
    model.key = [NSString stringWithFormat:@"%@-%@", [UserDefaultsHelper getStringForKey:@"userid"], [Utility md5:url]];
    model.title = title;
    model.url = url;
    model.name = [[url componentsSeparatedByString:@"/"].lastObject
                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    model.time = [dateFormatter stringFromDate:[NSDate date]];
    
    DownLoadSql *downLoadSql = [[DownLoadSql alloc] init];
    [downLoadSql addModel:model];
    
    // 因为新加的记录全部加到数组的第一个 所以返回0
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:loadings.count + 1];
    [arr addObject:model];
    [arr addObjectsFromArray:loadings];
    loadings = arr;
    
    return 0;
}

- (void)start:(int)index
{
    NSLog(@"nowDownLoadCount:%d", reqDict.count);
    if (reqDict.count == 4)
    {
        return;
        
    }
    
    if (index >= 0)
    {
        DownLoadModel *model = [loadings objectAtIndex:index];
        if (model.state == FINISHED)
        {
            [self finsh:model index:index];
            return;
        }
        
//        nowDownLoadCount++;
        
        DownLoadRequest *downLoadRequest = [reqDict valueForKey:model.key];
        if (downLoadRequest)
        {
            [downLoadRequest cancelLoad];
            downLoadRequest = nil;
        }
        
        model.state = DOWNLOADING;
        downLoadRequest = [[DownLoadRequest alloc] initWithIndex:index];
        [downLoadRequest startLoadFile:model];
//        model.request = downLoadRequest;
        [reqDict setValue:downLoadRequest forKey:model.key];
    }
}


- (void)pauseWithIndex:(int)index
{
    if (loadings.count <= index)
    {
        return;
    }
    
    DownLoadModel *model = [loadings objectAtIndex:index];
    if (model)
    {
        DownLoadRequest *downLoadRequest = [reqDict valueForKey:model.key];
//        if (model.request)
        if (downLoadRequest)
        {
            [reqDict removeObjectForKey:model.key];
            [downLoadRequest cancelLoad];
            
            model.state = PAUSE;
            DownLoadSql *downLoadSql = [[DownLoadSql alloc] init];
            [downLoadSql upDateModel:model];
        }
        else
        {
            model.state = PAUSE;
            [self pause:model index:index];
        }
    }
    
//    nowDownLoadCount--;
    
    [self loadNext];
}

- (void)removeWithIndex:(int)index isFinshed:(BOOL)isFinshed isDelFile:(BOOL)isDelFile
{
    DownLoadModel *model = nil;
    
    if (isFinshed)
    {
        model = [finsheds objectAtIndex:index];
        [finsheds removeObjectAtIndex:index];
    }
    else
    {
        model = [loadings objectAtIndex:index];
        if (model)
        {
            DownLoadRequest *downLoadRequest = [reqDict valueForKey:model.key];
            //        if (model.request)
            if (downLoadRequest)
            {
                [reqDict removeObjectForKey:model.key];
                [downLoadRequest cancelLoad];
//                nowDownLoadCount--;
            }
            [loadings removeObjectAtIndex:index];
            [self loadNext];
        }
    }
    
    if (model)
    {
        DownLoadSql *downLoadSql = [[DownLoadSql alloc] init];
        [downLoadSql delModel:model];
    }
    
    // 删除文件
    if (isDelFile)
    {
        if (model)
        {
            NSString *fileName;
            if (model.currSize < model.totalSize)
            {
                fileName = [NSString stringWithFormat:@"%@.temp",model.name];
            }
            else
            {
                fileName = model.name;
            }
            [FileUtil deleteFile:[[FileUtil getTempFolderPath] stringByAppendingPathComponent:fileName]];
        }
    }
}

- (void)removeWithModel:(DownLoadModel *)model isDelFile:(BOOL)isDelFile
{
    if (model)
    {
        DownLoadRequest *downLoadRequest = [reqDict valueForKey:model.key];
        //        if (model.request)
        if (downLoadRequest)
        {
            [downLoadRequest cancelLoad];
            [reqDict removeObjectForKey:model.key];
//            nowDownLoadCount -=[downLoadRequest cancelLoad];
        }
        
        DownLoadSql *downLoadSql = [[DownLoadSql alloc] init];
        [downLoadSql delModel:model];
    }
    
    // 删除文件
    if (isDelFile)
    {
        if (model)
        {
            NSString *fileName;
            if (model.currSize < model.totalSize)
            {
                fileName = [NSString stringWithFormat:@"%@.temp",model.name];
            }
            else
            {
                fileName = model.name;
            }
            [FileUtil deleteFile:[[FileUtil getTempFolderPath] stringByAppendingPathComponent:fileName]];
        }
    }
    
    [loadings removeObject:model];
    [finsheds removeObject:model];
}

- (void)removeAll:(BOOL)isFinish
{
    NSArray *arrs;
    if (isFinish)
    {
        arrs = finsheds;
    }
    else
    {
        arrs = loadings;
    }
    
    for (int i = 0; i < arrs.count; i++)
    {
        [self removeWithIndex:i isFinshed:isFinish isDelFile:YES];
    }
}

- (BOOL)isDownLoad:(NSString *)url
{
    for (DownLoadModel *model in loadings)
    {
        if ([model.url isEqualToString:url])
        {
            return YES;
        }
    }
    
    for (DownLoadModel *model in finsheds)
    {
        if ([model.url isEqualToString:url])
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)begin:(DownLoadModel *)model index:(int)index
{
    [delegate beginLoad:model];
}

- (void)upDate:(DownLoadModel *)model index:(int)index
{
    NSString *filePath = [[FileUtil getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",model.name]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    model.currSize = data.length;
    
    model.state = DOWNLOADING;
    DownLoadSql *downLoadSql = [[DownLoadSql alloc] init];
    [downLoadSql upDateModel:model];
    
    [delegate upDateLoad:model];
}

- (void)pause:(DownLoadModel *)model index:(int)index
{
    [reqDict removeObjectForKey:model.key];
    [delegate pauseLoad:model];
}

- (void)finsh:(DownLoadModel *)model index:(int)index
{
//    nowDownLoadCount--;
    
    if (index >= loadings.count)
        return;
    
    [loadings removeObject:model];
    [reqDict removeObjectForKey:model.key];
    
    model.state = FINISHED;
    
    if (model.currSize < model.totalSize)
    {
        model.currSize = model.totalSize;
    }
    
    DownLoadSql *downLoadSql = [[DownLoadSql alloc] init];
    
    [downLoadSql upDateModel:model];
    
    finsheds = [downLoadSql getDownLoadFinished];
    
    [delegate finshLoad:model];
    
    [self loadNext];
}

- (void)faild:(DownLoadModel *)model index:(int)index msg:(NSString *)msg
{
//    nowDownLoadCount--;
    [reqDict removeObjectForKey:model.key];
    
    if (index >= loadings.count)
        return;
    
//    DownLoadModel *model = [loadings objectAtIndex:index];
    
    model.state = ERR;
    
    [delegate loadFail:model errMsg:msg];
    
    [self loadNext];
    
    NSLog(@"ENTER:%@", model.name);
}

- (void)loadNext
{
    if (reqDict.count < 4)
    {
        for (int i = 0; i < loadings.count; i++)
        {
            DownLoadModel *model = [loadings objectAtIndex:i];
            if (model.state != DOWNLOADING && model.state != ERR && model.state != PAUSE)
            {
                [self start:i];
            }
        }
    }
}

- (DownLoadModel *)getDownLoadModelWithUrl:(NSString *)url
{
    for (DownLoadModel *model in [self getAll])
    {
        if ([url isEqualToString:model.url])
        {
            return model;
        }
    }
    
    return nil;
}

@end
