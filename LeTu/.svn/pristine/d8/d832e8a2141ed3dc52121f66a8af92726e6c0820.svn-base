//
//  FileUtil.h
//  PGCBD
//
//  Created by cyberway on 13-5-22.
//
//  文件处理工具类库

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject

/*
 * 得到实际文件存储文件夹的路径
 *
 */
+ (NSString *)getDocumentPath;

/*
 * 得到临时文件存储文件夹的路径
 *
 */
+ (NSString *)getTempFolderPath;

/*
 * 创建文件目录
 *
 */
+ (BOOL)createDir:(NSString *)dirName;

/*
 * 检查文件名是否存在
 *
 */
+ (BOOL)isExistFile:(NSString *)filePath;

/*
 * 删除文件
 *
 */
+ (BOOL)deleteFile:(NSString *)filePath;

/*
 * 文件大小文字转换（M、K、B）
 *
 */
+ (NSString *)getFileSizeString:(NSString *)fileSize;

/**
 * 磁盘剩余空间大小
 */
+ (long long)getFreeDiskspace;

@end
