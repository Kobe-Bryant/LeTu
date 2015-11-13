//
//  ErrorModel.h
//  CBD
//
//  Created by Roland on 12-7-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseModel.h"


@interface ErrorModel : BaseModel{
    
  
    
}
@property(nonatomic,retain) NSString *RetrunValue;
@property(nonatomic,retain) NSString *messsage;
@property(nonatomic,retain) NSString *err_msg;
@property(nonatomic,retain) NSString *err_code;
@property(nonatomic,retain) NSString *request_args;




@end
