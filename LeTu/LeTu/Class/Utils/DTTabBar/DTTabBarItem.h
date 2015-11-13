//
//  DTTabBarItem.h
//  AnimatTabbarSample
//
//  Created by DT on 14-6-7.
//  Copyright (c) 2014年 DT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTTabBarItem : NSObject

@property(nonatomic,copy) NSString * normalImageName;
@property(nonatomic,copy) NSString * highlightImageName;

+(DTTabBarItem*)itemWithNormalImageName:(NSString*)normalImageName
                  highlightImageName:(NSString*)highlightImageName;


@end
