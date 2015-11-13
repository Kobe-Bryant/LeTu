//
//  FaceUtil.m
//  AHAOrdering
//
//  Created by cyberway on 14-4-8.
//
//

#import "FaceUtil.h"

@implementation FaceUtil

#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH 245
+ (UIView *)assembleMessageAtIndex:(NSString *)message
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *data = array;
    UIFont *fon = [UIFont systemFontOfSize:13.0f];
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    if (data) {
        for (int i=0;i < [data count];i++) {
            NSString *str=[data objectAtIndex:i];
//            NSLog(@"str--->%@",str);
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = MAX_WIDTH;
                    Y = upY;
                }
                NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
                imageName=[[str stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
//                NSLog(@"imageName(image)---->%@",imageName);
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                upX=KFacialSizeWidth+upX;
                if (X < MAX_WIDTH) X = upX;
                
                
            } else {
                if ([str isEqualToString:@"\n"])
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = MAX_WIDTH;
                    Y =upY;
                }
                else
                {
                    for (int j = 0; j < [str length]; j++) {
                        NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                        if (upX >= MAX_WIDTH)
                        {
                            upY = upY + KFacialSizeHeight;
                            upX = 0;
                            X = MAX_WIDTH;
                            Y =upY;
                        }
                        CGSize size = [temp sizeWithFont:fon constrainedToSize:CGSizeMake(MAX_WIDTH, 40)];
                        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                        la.font = fon;
                        la.text = temp;
                        la.backgroundColor = [UIColor clearColor];
                        [returnView addSubview:la];
                        
                        upX= upX + size.width;
                        if (X < MAX_WIDTH) {
                            X = upX;
                        }
                    }
                }
                
            }
        }
    }
    returnView.frame = CGRectMake(15.0f,1.0f, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
//    NSLog(@"x:%.1f y:%.1f", X, Y);
    return returnView;
}

//图文混排
+ (void)getImageRange:(NSString*)message : (NSMutableArray*)array {
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [self getLineRange:[message substringToIndex:range.location] array:array];
            
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [self getLineRange:message array:array];
    }
}

//换行
+ (NSMutableArray *)getLineRange:(NSString*)message array:(NSMutableArray *)array {
    NSArray *strArr = [message componentsSeparatedByString:@"/n"];
    
    //    NSMutableArray *array = [NSMutableArray arrayWithCapacity:strArr.count + 2];
    if ([message hasPrefix:@"\n"])
    {
        [array addObject:@"\n"];
    }
    
    for (int i = 0; i < strArr.count; i++)
    {
        if (! [message isEqualToString:@"\n"])
        {
            [array addObject:[strArr objectAtIndex:i]];
        }
        if (i < strArr.count - 1)
        {
            [array addObject:@"\n"];
        }
    }
    
    if (message.length > 2 && [message hasSuffix:@"\n"])
    {
        [array addObject:@"\n"];
    }
    
    return array;
}


@end
