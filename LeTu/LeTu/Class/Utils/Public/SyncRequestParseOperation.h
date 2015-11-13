//
//  SyncRequestParseOperation.h
//  CBD
//
//  Created by Roland on 12-7-3.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseXmlParser.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"

@protocol ActivityDelegate <NSObject>

@optional
-(void)startLoading;
-(void)stopLoading;
@end


enum kRequestStatus {
    kRequestStatusFinished ,
    kRequestStatusFailed ,
    kRequestStatusDataReceived
};
@interface SyncRequestParseOperation : NSOperation
{
    //NSURL * _url ;
   // NSDictionary * _data ;
    // 构建 gb2312 的 encoding
    NSStringEncoding enc ;
    //Xml 解析器指针
    xmlParserCtxtPtr _parserContext ;
    BaseXmlParser * baseParser ;
    id delegate , progressDelegate;
    
   // int status ;
}
@property ( nonatomic , retain ) NSDictionary *data;
@property ( nonatomic , retain ) NSURL *url;
@property ( assign ) int status;
@property NSInteger RequestTag;
@property(nonatomic,retain) NSString *model;

- ( id )initWithURLString:( NSString *) url xmlParser:( BaseXmlParser *) parser delegate:( id )obj;
-( void )setProgressDelegate:( id )progress;
-( void )statusChangedNotify;
@end