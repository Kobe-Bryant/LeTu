//
//  DTTabBarItem.m
//  AnimatTabbarSample
//
//  Created by DT on 14-6-7.
//  Copyright (c) 2014年 DT. All rights reserved.
//

#import "DTTabBarItem.h"

@implementation DTTabBarItem

+(DTTabBarItem*)itemWithNormalImageName:(NSString*)normalImageName
                     highlightImageName:(NSString*)highlightImageName
{
    DTTabBarItem * item = [[DTTabBarItem alloc] init];
    item.normalImageName = normalImageName;
    item.HighlightImageName = highlightImageName;
    return item;
}
@end
