//
//  SyncRequestParseOperation.m
//  CBD
//
//  Created by Roland on 12-7-3.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SyncRequestParseOperation.h"


@implementation SyncRequestParseOperation

@synthesize data;
@synthesize url;
@synthesize status;
@synthesize RequestTag;
@synthesize model;

- ( id )initWithURLString:( NSString *) urlStr xmlParser:( BaseXmlParser *)parser delegate:( id )obj{
    self = [ super init ];
    if ( self != nil) {
        url =[[ NSURL alloc ] initWithString : urlStr ];
        delegate =obj;
        baseParser =parser;
        // 构建 gb2312 的 encoding
        //enc = CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingGB_18030_2000 );
        enc = CFStringConvertEncodingToNSStringEncoding ( NSUTF8StringEncoding );
        
    }
    return self ;
}

-( void )setProgressDelegate:( id )progress{
    progressDelegate =progress;
}

static void startElementHandler(
                                void * ctx,
                                const xmlChar * localname,
                                const xmlChar * prefix,
                                const xmlChar * URI,
                                int nb_namespaces,
                                const xmlChar ** namespaces,
                                int nb_attributes,
                                int nb_defaulted,
                                const xmlChar ** attributes)
{
    [(__bridge BaseXmlParser *)ctx
     startElementLocalName :localname
     prefix :prefix URI :URI
     nb_namespaces :nb_namespaces
     namespaces :namespaces
     nb_attributes :nb_attributes
     nb_defaulted :nb_defaulted
     attributes :attributes];
    
       
    
}

static void endElementHandler(
                              void * ctx,
                              const xmlChar * localname,
                              const xmlChar * prefix,
                              const xmlChar * URI)
{
    [(__bridge BaseXmlParser *)ctx
     endElementLocalName :localname
     prefix :prefix
     URI :URI];
}

static void charactersFoundHandler(
                                   void * ctx,
                                   const xmlChar * ch,
                                   int len)
{
    [(__bridge BaseXmlParser *)ctx
     charactersFound :ch len :len];
}

static xmlSAXHandler _saxHandlerStruct = {
    NULL ,              /* internalSubset */
    NULL ,            /* isStandalone   */
    NULL ,            /* hasInternalSubset */
    NULL ,            /* hasExternalSubset */
    NULL ,            /* resolveEntity */
    NULL ,            /* getEntity */
    NULL ,            /* entityDecl */
    NULL ,            /* notationDecl */
    NULL ,            /* attributeDecl */
    NULL ,            /* elementDecl */
    NULL ,            /* unparsedEntityDecl */
    NULL ,            /* setDocumentLocator */
    NULL ,            /* startDocument */
    NULL ,            /* endDocument */
    NULL ,            /* startElement*/
    NULL ,            /* endElement */
    NULL ,            /* reference */
    charactersFoundHandler, /* characters */
    NULL ,              /* ignorableWhitespace */
    NULL ,            /* processingInstruction */
    NULL ,            /* comment */
    NULL ,             /* warning */
    NULL ,            /* error */
    NULL ,              /* fatalError //: unused error() get all the errors */
    NULL ,              /* getParameterEntity */
    NULL ,            /* cdataBlock */
    NULL ,            /* externalSubset */
    XML_SAX2_MAGIC ,  /* initialized 特殊常量，照写 */
    NULL ,            /* private */
    startElementHandler,    /* startElementNs */
    endElementHandler,      /* endElementNs */
    NULL ,              /* serror */
};

- ( void )start {
    NSLog ( @"operation start!" );
   
    if(![Utility connectedToNetwork])
    {
        
        ISCONNECT;
        SHOWLOGINVIEW;
    }
    else {

    if (![ self isCancelled ]) {
        
        if (delegate && [delegate respondsToSelector:@selector(startLoading)]) {
           // [delegate stopLoading];
            [delegate startLoading];
        }

       
        // 创建 XML 解析器指针
        _parserContext = xmlCreatePushParserCtxt (&_saxHandlerStruct , (__bridge void *)baseParser , NULL , 0 , NULL );
        // 以异步方式处理事件，并设置代理块
          ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL : url ] ;
       // __block ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL : url ];
      // [request setUseCookiePersistence:NO];
        // 设置进度代理
        if ( progressDelegate != nil ) {
            [request setDownloadProgressDelegate : progressDelegate ];
        }
        /**
        // 使用 complete 块，在下载完时做一些事情
        [request setCompletionBlock :^( void ){
             NSLog(@"--aa---%@-----",[request responseString]);
            [ self setStatus : kRequestStatusFinished ];
            NSLog ( @"request completed!" );
            // 添加解析数据（结束），注意最后一个参数 terminate
            xmlParseChunk ( _parserContext , NULL , 0 , 1 );
            // 添加解析数据（结束），
            if ( baseParser != nil ){
                [ self setData :[[ baseParser getResult ] copy ]];
            } else {
                NSLog ( @"baseparser is nil" );
            }
            
            // 释放 XML 解析器
            if ( _parserContext ) {
                xmlFreeParserCtxt ( _parserContext ), _parserContext = NULL ;
            }
            [ self statusChangedNotify ];
        }];
        // 使用 failed 块，在下载失败时做一些事情
        [request setFailedBlock :^( void ){
            [ self setStatus : kRequestStatusFailed ];
            NSLog ( @"request failed !" );
            // 释放 XML 解析器指针
            if ( _parserContext ) {
                xmlFreeParserCtxt ( _parserContext ), _parserContext = NULL ;
            }
            [ self statusChangedNotify ];
        }];
        // 使用 received 块，在接受到数据时做一些事情
        [request setDataReceivedBlock :^( NSData * body ){
            
           // NSString *result = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]; 
            
            NSLog(@"---bb--%@-----",[request responseString]);
            
                      
            
            [ self setStatus : kRequestStatusDataReceived ];
            NSLog ( @"received data:%d" , [body length] );
            // 添加解析数据（结束），注意最后一个参数 terminate
            if ( baseParser != nil && baseParser != NULL ){
                [ self setData :[[ baseParser getResult ] copy ]];
            } else {
                NSLog ( @"baseparser is nil" );
            }
            // 使用 libxml 解析器进行 xml 解析
           // NSLog(@"xmlParseChunk--------%@",[ body bytes]);
            xmlParseChunk ( _parserContext , ( const char *)[ body bytes], [ body length ], 0 );
            [ self statusChangedNotify ];
        }];
         **/
         [request setTimeOutSeconds:120];
         [request setDelegate:self];
        [request startAsynchronous ];
    }
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (delegate && [delegate respondsToSelector:@selector(stopLoading)]) {
        [delegate stopLoading];
    }
    

    NSString *responseString = [request responseString];
    NSLog(@"---cc---%@--------",responseString);
     NSData *responseData = [request responseData];
    [ self setStatus : kRequestStatusFinished ];
      // 使用 libxml 解析器进行 xml 解析
    xmlParseChunk ( _parserContext , ( const char *)[ responseData bytes], [ responseData length ], 0 );
    // 添加解析数据（结束）
    xmlParseChunk ( _parserContext , NULL , 0 , 1 );
    if ( baseParser != nil && baseParser != NULL ){
        [ self setData :[[ baseParser getResult ] copy ]];
    } else {
        NSLog ( @"baseparser is nil" );
    }
    // 释放 XML 解析器
    if ( _parserContext ) {
        xmlFreeParserCtxt ( _parserContext ), _parserContext = NULL ;
    }
   
    [ self statusChangedNotify ];
    
    
   
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    if (delegate && [delegate respondsToSelector:@selector(stopLoading)]) {
        [delegate stopLoading];
    }
   // NSError *error = [request error];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Notice" message:@"Network is busy now, please try it later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
       //NSLog(@"---error code---%d--------",[error code]);
   
}


// 停止线程
- ( void )cancel
{
    [ super cancel ];
}
// status 状态变化通知
-( void )statusChangedNotify{
    if ( delegate != nil ) {
        SEL sel= NSSelectorFromString ( @"syncRequestParseStatusNofity:" );
        if ([ delegate respondsToSelector :sel]){
            [ delegate performSelector :sel withObject : self ]; // 注意冒号说明带 1 个参数
        } 
      
       
    }
}

@end
