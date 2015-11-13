//
//  CacheSql.h
//  E-learning
//
//  Created by cyberway on 13-9-25.
//
//

#import "BaseSql.h"
#import "MessageModel.h"
@interface CacheSql : BaseSql
{
 NSMutableArray *arrays;
}
-(BOOL)DelAllNewMessage;
-(BOOL)AddNewMessage:(NSString *)json;
- (NSString*)getNewMessageJson;
-(BOOL)itemAdd:(MessageModel *)messageModel;
- (int)ifHasMessageID:(NSString*)mID;
-(NSMutableArray *)getNewMessage:(int)count;
-(NSMutableArray *)getHisMessageByID:(NSString*)messageID;
-(BOOL)DelMessageByMsgID:(NSString*)msgID;
@end
