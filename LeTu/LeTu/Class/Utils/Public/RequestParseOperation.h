//
//  RequestParseOperation.h
//  PGCBD
//
//  Created by screate on 13-5-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "UserDefaultsHelper.h"

@protocol NotifyDelegate <NSObject>

@optional
-(void)responseNotify:( id )sender;
@end



@interface RequestParseOperation : NSOperation
{
    id progressDelegate;
    id<NotifyDelegate> delegate;
}

@property ( nonatomic , retain ) NSDictionary *data;
@property ( nonatomic , retain ) NSURL *url;
@property ( nonatomic , retain ) NSDictionary *params;
@property ( assign ) int status;
@property NSInteger RequestTag;
@property BOOL isCache;

- ( id )initWithURLString:( NSString *) url delegate:( id )obj;
- ( id )initWithURLAndPostParams:( NSString *) url delegate:( id )obj params:(NSDictionary *)_params;
-( void )setProgressDelegate:( id )progress;

@end
