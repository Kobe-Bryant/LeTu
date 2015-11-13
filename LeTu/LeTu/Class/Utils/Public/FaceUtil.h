//
//  FaceUtil.h
//  AHAOrdering
//
//  Created by cyberway on 14-4-8.
//
//

#import <Foundation/Foundation.h>

#define BEGIN_FLAG @"["
#define END_FLAG @"]"

@interface FaceUtil : NSObject

+ (UIView *)assembleMessageAtIndex:(NSString *)message;

@end
