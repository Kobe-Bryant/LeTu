//
//  BaseXmlParser.m
//  CBD
//
//  Created by Roland on 12-7-3.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseXmlParser.h"
//#import "MySchedule.h"

@implementation BaseXmlParser

// Property
-( id )init{
    self =[ super init ];
    
    if (self != nil ){
        // 构建 gb2312 的 encoding
        enc = CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingGB_18030_2000 );
        _root =[[ NSMutableDictionary alloc ] init ];
        loginSuccess = YES ;
        
    }
    return self ;
}




// 一个便利方法，用于获取元素的属性值
-( NSDictionary *)getAtributes:( const xmlChar **)attributes withSize:( int )nb_attributes{
    NSMutableDictionary * atts=[[ NSMutableDictionary alloc ] init ];
    NSString *key,*val;
    for ( int i= 0 ; i<nb_attributes; i++){
        key = [ NSString stringWithCString :( const char *)attributes[ 0 ] encoding : NSUTF8StringEncoding ];
        val = [[ NSString alloc ] initWithBytes :( const void *)attributes[ 3 ] length :(attributes[ 4 ] - attributes[ 3 ]) encoding : NSUTF8StringEncoding ];
        [atts setObject :val forKey :key];
        attributes += 5 ; // 指针移动 5 个字符串，到下一个属性
    }
    return atts;
}





//--------------------------------------------------------------//
#pragma mark -- libxml handler ，主要是 3 个回调方法 , 空方法，等待子类实现 --<items><userinfo><username></username></userinfo></items>
//--------------------------------------------------------------//
// 解析元素开始标记时触发 , 在这里取元素的属性值
- ( void )startElementLocalName:( const xmlChar *)localname
                         prefix:( const xmlChar *)prefix
                            URI:( const xmlChar *)URI
                  nb_namespaces:( int )nb_namespaces
                     namespaces:( const xmlChar **)namespaces
                  nb_attributes:( int )nb_attributes
                   nb_defaulted:( int )nb_defaultedslo
                     attributes:( const xmlChar **)attributes
{
    //  [currentString release];
    if (currentString != nil) {
        currentString = nil;
    }
    
    currentString=[[NSMutableString alloc]init];
    
    if ( loginSuccess ) {
        if(strncmp (( char *)localname, "items" , sizeof ( "items" )) == 0 )
        {
            items =[[ NSMutableArray alloc ] init ];
            
        }
        if ( strncmp (( char *)localname, "FY_UserInfo" , sizeof ( "FY_UserInfo" )) == 0 ) {
            item = [[UserModel alloc] init];
            return ;
        }
        else if( strncmp (( char *)localname, "Error" , sizeof ( "Error" )) == 0)
        {
            item = [[ErrorModel alloc] init];
            return;
            
        }
//        else if( strncmp (( char *)localname, "MySchedule" , sizeof ( "MySchedule" )) == 0)
//        {
//            item = [[MySchedule alloc] init];
//            return;
//            
//        }
    }
}
// 解析元素结束标记时触发
- ( void )endElementLocalName:( const xmlChar *)localname
                       prefix:( const xmlChar *)prefix URI:( const xmlChar *)URI
{
    if ( strncmp (( char *)localname, "Root" , sizeof ( "Root" )) == 0 ){ //root 结束时置  login_status 标志
        if ( loginSuccess ) {
            [ _root setObject : @"true" forKey : @"login_status" ];
        } else {
            [ _root setObject : @"false" forKey : @"login_status" ];
        }
    }
    if ( loginSuccess ) {
        // [self currentString];
        
        if ( strncmp (( char *)localname, "items" , sizeof ( "items" )) == 0 ) {
            [ _root setObject : items forKey : @"items" ];
            items = nil;
        }     
        
        
        if ( strncmp (( char *)localname, "FY_UserInfo" , sizeof ( "FY_UserInfo" )) == 0 ) {
            if(items != nil)
                [items addObject : item];
            else
                [ _root setObject : item forKey : @"item" ];
            item = nil;
        }
        else if ( strncmp (( char *)localname, "MySchedule" , sizeof ( "MySchedule" )) == 0 ) {
            if(items != nil)
                [items addObject : item];
            else
                [ _root setObject : item forKey : @"item" ];
            
           item = nil; 
        }
        
        
        if(item != nil)
        {
            // NSLog(@"------wen--%@----",[ NSString stringWithCString :( const char *)localname encoding : NSUTF8StringEncoding ]);
            // NSString *key  =  [ NSString stringWithCString :( const char *)localname encoding : NSUTF8StringEncoding ] ;
            //[key release];
            
            // NSLog(@"---currentString-%@:%@----" ,key,currentString);
            // NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            // NSString *str =  [NSString stringWithString:currentString];
            
            // str = [str stringByTrimmingCharactersInSet:whitespace];
            
            NSString *str = [currentString  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [item setValue:[str copy]  forKey:[ NSString stringWithCString :( const char *)localname encoding : NSUTF8StringEncoding ]];
            str=nil;
            currentString = nil;
            
        }
        
        
    }
    
    // [currentString release];
    
    
}

- (void)appendCharacters:(const char *)charactersFound length:(NSInteger)length {
    
    //[NSString stringWithCharacters:(const unichar)charactersFound length:length];
    [characterBuffer appendBytes:charactersFound length:length];
}

// 解析元素体时触发
- ( void )charactersFound:( const xmlChar *)ch
                      len:( int )len
{    
    
    // currentString = [NSString stringWithFormat:@"aa"];  
    
    //currentString = [[NSString alloc ] initWithBytes:(const char *)ch length:len encoding:NSUTF8StringEncoding] ;
    
    // NSLog(@"--%@------",[ NSString stringWithCString :( const char *)ch encoding : NSUTF8StringEncoding ]);
    
    //[currentString release];
    // NSString *str = [[NSString alloc] initWithBytes:ch length:len encoding:NSUTF8StringEncoding];
    NSString* string;
    string = [[NSString alloc] initWithBytes:ch length:len encoding:NSUTF8StringEncoding];
    [currentString appendString:string];
    
    // NSLog(@"---%@-%d--",[NSString stringWithCString :( const char *)ch encoding : NSUTF8StringEncoding ],len);
    //  if ([[ NSString stringWithCString :( const char *)ch encoding : NSUTF8StringEncoding ] length] >0 && len >0) 
    // [currentString appendString: [[ NSString stringWithCString :( const char *)ch encoding : NSUTF8StringEncoding ] substringToIndex:len]];
    
    
    
    /**
     
     NSString *str = [ NSString stringWithCString :( const char *)ch encoding : NSUTF8StringEncoding ];
     NSLog(@"-currentString-%@------",str);
     if (str != nil && str.length > 0) {
     
     
     NSRange range = [str rangeOfString:@"<"];  
     if(range.location != NSNotFound)
     {
     currentString = [str substringToIndex:NSMaxRange(range)-1];  
     }
     }
     // NSLog(@"-currentString-%@------",currentString);
     
     NSRange range = [str rangeOfString:@"<"];  
     str = [str substringFromIndex:NSMaxRange(range)];  
     **/
    
}


// 返回解析结果
-( NSDictionary *)getResult{
    return _root ;
}
@end
