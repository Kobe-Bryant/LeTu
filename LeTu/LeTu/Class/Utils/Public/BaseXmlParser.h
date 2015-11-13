//
//  BaseXmlParser.h
//  CBD
//
//  Created by Roland on 12-7-3.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/tree.h>
#import "UserModel.h"
#import "Utility.h"
#import "ErrorModel.h"
#import "Paging.h"

@interface BaseXmlParser : NSObject {
    NSStringEncoding enc ;
    NSMutableDictionary *    _root ;
    NSMutableString *currentString;
     BOOL loginSuccess ;
     NSMutableData *characterBuffer;
    NSMutableArray * items;
    NSObject *item;
    NSObject *error;
    
}
// Property



- ( void )startElementLocalName:( const xmlChar *)localname
                         prefix:( const xmlChar *)prefix
                            URI:( const xmlChar *)URI
                  nb_namespaces:( int )nb_namespaces
                     namespaces:( const xmlChar **)namespaces
                  nb_attributes:( int )nb_attributes
                   nb_defaulted:( int )nb_defaultedslo
                     attributes:( const xmlChar **)attributes;
- ( void )endElementLocalName:( const xmlChar *)localname
                       prefix:( const xmlChar *)prefix URI:( const xmlChar *)URI;
- ( void )charactersFound:( const xmlChar *)ch
                      len:( int )len;
-( NSDictionary *)getAtributes:( const xmlChar **)attributes withSize:( int )nb_attributes;
-( NSDictionary *)getResult;



@end


