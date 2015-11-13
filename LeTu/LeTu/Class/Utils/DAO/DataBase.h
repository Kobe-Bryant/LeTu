//
//  DataBase.h
//  BookManage
//
//  Created by WangChao on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PlausibleDatabase/PlausibleDatabase.h>

@interface DataBase : NSObject {

}

+ (PLSqliteDatabase *) setup;

+ (void) close;

@end
