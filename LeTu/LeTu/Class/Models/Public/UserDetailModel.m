//
//  UserDetailModel.m
//  LeTu
//
//  Created by DT on 14-5-26.
//
//

#import "UserDetailModel.h"

@implementation UserDetailModel

-(void)setRelationType:(NSNumber *)relationType
{
    _relationType = relationType;
    
    if ([relationType intValue] == 0) {
        self.relationName = @"陌生人";
    }else if ([relationType intValue]==1){
        self.relationName = @"朋友";
    }else if ([relationType intValue]==2){
        self.relationName = @"黑名单";
    }
}
@end
