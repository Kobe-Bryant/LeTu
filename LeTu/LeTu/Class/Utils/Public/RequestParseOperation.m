//
//  RequestParseOperation.m
//  PGCBD
//
//  Created by screate on 13-5-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "RequestParseOperation.h"
#import "CacheSql.h"
#import "CacheModel.h"
#import "JSONKit.h"


@implementation RequestParseOperation

@synthesize data;
@synthesize url;
@synthesize params;
@synthesize status;
@synthesize RequestTag;
@synthesize isCache;


- ( id )initWithURLString:( NSString *) urlStr delegate:( id )obj{
    self = [ super init ];
    if ( self != nil) {
        url =[[ NSURL alloc ] initWithString : urlStr ];
        delegate =obj;
        
    }
    return self ;
}
- ( id )initWithURLAndPostParams:( NSString *) urlStr delegate:( id )obj params:(NSDictionary *)_params
{
    self = [ super init ];
    if ( self != nil) {
        url =[[ NSURL alloc ] initWithString : urlStr ];
        params = _params;
        delegate =obj;
        status = 1;
        
    }
    return self ;

}

-( void )setProgressDelegate:( id )progress{
    progressDelegate =progress;
}

- ( void )start {
    NSLog ( @"operation start!" );
    if(![Utility connectedToNetwork])
    {
        if ( delegate != nil ) {
            if ([delegate respondsToSelector:@selector(responseNotify:)]) {
                [delegate responseNotify:self];
            }
        }
        
//        ISCONNECT;
//        SHOWLOGINVIEW;
    }
//    if (! [Utility isEnableWIFI])
//    {
//        NSLog(@"没有连接wifi");
//        if (isCache)
//            [self getCacheData];
//    }
    else {
        
        if (![ self isCancelled ]) {
            if (status==1) {
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
                [request setRequestMethod:@"POST"];
                [request addRequestHeader:@"Content-Type" value:@"application/xml;charset=UTF-8;"];
                BOOL setUserName=NO,setUserId=NO;
                
                for (NSString *key in params.keyEnumerator)
                {
                    if ([key isEqualToString:@"username"])
                        setUserName = YES;
                    if ([key isEqualToString:@"userid"])
                        setUserId = YES;
                    [request setPostValue:[params valueForKey:key] forKey:key];
                }
                if (setUserName == NO && [UserDefaultsHelper getStringForKey:@"userName"] != nil) {
                    [request setPostValue:[UserDefaultsHelper getStringForKey:@"userName"] forKey:@"username"];
                }
                if (setUserId == NO && [UserDefaultsHelper getStringForKey:@"userid"] != nil) {
                    [request setPostValue:[UserDefaultsHelper getStringForKey:@"userid"] forKey:@"userid"];
                }
                
                 [request setTimeOutSeconds:120];
                 [request setDelegate:self];
                 [request startAsynchronous ];
            }
            else {
                ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL : url ] ;
                // [request setUseCookiePersistence:NO];
                // 设置进度代理
                if ( progressDelegate != nil ) {
                    [request setDownloadProgressDelegate : progressDelegate ];
                }
                [request setTimeOutSeconds:120];
                [request setDelegate:self];
                [request startAsynchronous ];

            }
        }
    }
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"---cc---%@--------",responseString);
    //[responseString objectFromJSONString];
    // NSData *responseData = [request responseData];
    
    NSDictionary *responseData = [responseString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    
    
    NSLog(@"%@",responseData);
    
    
    [self setData:responseData];
    if ( delegate != nil ) {
        if ([delegate respondsToSelector:@selector(responseNotify:)]) {
            [delegate responseNotify:self];
        }
    }
    
    if (isCache)
        [self saveCacheData:responseString];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{

   [[[[iToast makeText:@"无法连接服务器,请检查您的网络或稍后重试"] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
}

- (void)getCacheData
{
    NSString *userId = [UserDefaultsHelper getStringForKey:@"userName"];
    CacheSql *cacheSql = [[CacheSql alloc] init];
    CacheModel *cacheModel = (CacheModel *)[cacheSql getByKey:[NSString stringWithFormat:@"%@-%@", userId, [Utility md5:[url absoluteString]]]];
    
    NSDictionary *responseData = [cacheModel.content objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    [self setData:responseData];
    if ( delegate != nil ) {
        [delegate responseNotify:self];
    }
}

- (void)saveCacheData:(NSString *)content
{
    NSString *userId = [UserDefaultsHelper getStringForKey:@"userName"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    CacheModel *cacheModel = [[CacheModel alloc] init];
    cacheModel.key = [NSString stringWithFormat:@"%@-%@", userId, [Utility md5:[url absoluteString]]];
    cacheModel.url = [url path];
    cacheModel.content = content;
    cacheModel.time = [dateFormatter stringFromDate:[NSDate date]];
                              
    CacheSql *cacheSql = [[CacheSql alloc] init];
    [cacheSql addOrUpadte:cacheModel];
}

// 停止线程
- ( void )cancel
{
    [ super cancel ];
}

@end
