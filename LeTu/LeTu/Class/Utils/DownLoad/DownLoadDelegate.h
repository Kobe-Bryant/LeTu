//
//  DownLoadDelegate.h
//  DownLoad
//
//  Created by cyberway on 13-1-8.
//  Copyright (c) 2013年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownLoadModel;

@protocol DownLoadDelegate <NSObject>

- (void)beginLoad:(DownLoadModel *)model;

- (void)upDateLoad:(DownLoadModel *)model;

- (void)pauseLoad:(DownLoadModel *)model;

- (void)loadFail:(DownLoadModel *)model errMsg:(NSString *)errMsg ;

- (void)finshLoad:(DownLoadModel *)model;

@end
