//
//  FileUtil.m
//  PGCBD
//
//  Created by cyberway on 13-5-22.
//
//  文件处理工具类库

#import "FileUtil.h"

@implementation FileUtil

+ (NSString *)getDocumentPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+ (NSString *)getTempFolderPath
{
    return [[self getDocumentPath] stringByAppendingPathComponent:@"Temp"];
}

+ (BOOL)createDir:(NSString *)dirName
{
    return [[NSFileManager defaultManager] createDirectoryAtPath:dirName
                                     withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (BOOL)isExistFile:(NSString *)filePath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (BOOL)deleteFile:(NSString *)filePath
{
    if (! [self isExistFile:filePath])
    {
        return NO;
    }
    
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

-(void)getFileAttributes:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
    NSLog(@"@@");
    if (fileAttributes != nil)
    {
        NSNumber *fileSize;
        NSString *fileOwner, *creationDate;
        NSDate *fileModDate;
        //NSString *NSFileCreationDate
        //文件大小
        fileSize = [fileAttributes objectForKey:NSFileSize];
        //        [fileAttributes fileSize];
        NSLog(@"File size: %qin", [fileSize unsignedLongLongValue]);
        //文件创建日期
        creationDate = [fileAttributes objectForKey:NSFileCreationDate];
        NSLog(@"File creationDate: %@\n", creationDate);
        //文件所有者
        fileOwner = [fileAttributes objectForKey:NSFileOwnerAccountName];
        NSLog(@"Owner: %@\n", fileOwner);
        //文件修改日期
        fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
        NSLog(@"Modification date: %@\n", fileModDate);
    }
    else
    {
        NSLog(@"Path (%@) is invalid.", filePath);
    }
}

+ (NSString *)getFileSizeString:(NSString *)fileSize
{
    if([fileSize floatValue] >= 1024 * 1024)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%.2fM", [fileSize floatValue] / (1024 * 1024)];
    }
    else if([fileSize floatValue] >= 1024 && [fileSize floatValue] < 1024 * 1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%.2fK", [fileSize floatValue] / 1024];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%.2fB", [fileSize floatValue]];
    }
}

+ (long long)getFreeDiskspace
{
    //    long long totalSpace;
    long long totalFreeSpace;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary)
    {
        //        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        //        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes longLongValue];
    }
    
    return totalFreeSpace;
}

@end
