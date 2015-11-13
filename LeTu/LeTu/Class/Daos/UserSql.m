//
//  UserSql.m
//  E-learning
//
//  Created by cyberway on 13-9-24.
//
//

#import "UserSql.h"
#import "UserModel.h"

@implementation UserSql

- (id)init
{
    if (self = [super init])
    {
        self.tableName = @"User";
    }
    
    return self;
}

- (NSDictionary *)setModel:(UserModel *)model
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
//    [dict setObject:model.key forKey:@"key"];
    [dict setObject:model.userId forKey:@"userId"];
//    [dict setObject:model.userName forKey:@"userName"];
//    [dict setObject:model.passWord forKey:@"passWord"];
//    [dict setObject:model.loginTime forKey:@"loginTime"];
//    [dict setObject:model.lastLoginTime forKey:@"lastLoginTime"];
    
    return dict;
}

- (UserModel *)getModel:(id<PLResultSet>)rs
{
    UserModel *model = [[UserModel alloc]init];
//    model.key = [rs objectForColumn:@"key"];
    model.userId = [rs objectForColumn:@"userId"];
//    model.userName = [rs objectForColumn:@"userName"];
//    model.passWord = [rs objectForColumn:@"passWord"];
//    model.loginTime = [rs objectForColumn:@"loginTime"];
//    model.lastLoginTime = [rs objectForColumn:@"lastLoginTime"];
    
    return model;
}

@end
