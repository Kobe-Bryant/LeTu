//
//  HttpUtils.h
//  Hayate
//
//  Created by cyberway on 13-1-6.
//  Copyright (c) 2013年 山东海天软件学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "DownLoadDelegate.h"
@class DownLoadManage;

@class DownLoadModel;

@interface DownLoadRequest : NSObject <ASIHTTPRequestDelegate, ASIProgressDelegate>
{
    ASIHTTPRequest *mRequest;
    DownLoadModel *mModel;
    int mIndex;
    DownLoadManage *downLoadManage;
}

- (id)initWithIndex:(int)index;

- (void)startLoadFile:(DownLoadModel *)model;

- (int)cancelLoad;

@end
