//
//  HttpUtils.m
//  Hayate
//
//  Created by cyberway on 13-1-6.
//  Copyright (c) 2013年 cyberway. All rights reserved.
//

#import "DownLoadRequest.h"
#import "FileUtil.h"
#import "DownLoadManage.h"

@implementation DownLoadRequest

- (id)initWithIndex:(int)index
{
    if (self = [super init])
    {
        mIndex = index;
        downLoadManage = [DownLoadManage getInstance];
    }
    
    return self;
}

- (void)startLoadFile:(DownLoadModel *)model
{
    mModel = model;
    
    NSString *tempPath = [FileUtil getTempFolderPath];
    if (! [FileUtil isExistFile:tempPath])
    {
        [FileUtil createDir:tempPath];
    }
    
    NSString *url = [mModel.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    mRequest.tag = mIndex;
    mRequest.delegate=self;
    [mRequest setShowAccurateProgress:YES];
    [mRequest setDownloadDestinationPath:[tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",mModel.name]]];
    [mRequest setTemporaryFileDownloadPath:
        [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",mModel.name]]];
    [mRequest setDownloadProgressDelegate:self];
    [mRequest setAllowResumeForFileDownloads:YES];//支持断点续传
    [mRequest setTimeOutSeconds:60.0f];
    [mRequest startAsynchronous];
}

- (int)cancelLoad
{
    if (mRequest)
    {
        mIndex = -1;
        mRequest.tag = mIndex;
        if (!mRequest.isCancelled && !mRequest.complete)
        {
            [mRequest clearDelegatesAndCancel];
            [mRequest cancel];
            
            [downLoadManage pause:mModel index:mIndex];
            return 1;
        }
        mRequest = nil;
    }
    return 0;
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    [downLoadManage begin:mModel index:mIndex];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
//    if (error.code == ASIRequestTimedOutErrorType)
//    {
//        NSLog(@"下载超时！");
//        [self startLoadFile:mModel];
//    }
    NSLog(@"下载失败！ %@", [error description]);
    [downLoadManage faild:mModel index:mIndex msg:@"下载失败！"];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"downLoad over");
    [downLoadManage finsh:mModel index:mIndex];
}

- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
    mModel.totalSize = newLength;
    long long freeMemory = [FileUtil getFreeDiskspace];
    if (freeMemory < mModel.totalSize)
    {
        [downLoadManage faild:mModel index:mIndex msg:@"磁盘空间不足！"];
        [mRequest cancelAuthentication];
    }
}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    [downLoadManage upDate:mModel index:mIndex];
}

@end
