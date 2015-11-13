//
//  Utility.m
//  CBD
//
//  Created by Roland on 12-6-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"
#import "Reachability.h"

@implementation Utility


+(BOOL) connectedToNetwork
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);    
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) 
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

// 是否wifi
+ (BOOL) isEnableWIFI
{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

+(UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    UIColor *DEFAULT_VOID_COLOR = [UIColor lightGrayColor];
	
	NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	
	// String should be 8 characters
	if ([cString length] == 8)
	{
		return DEFAULT_VOID_COLOR;
	}
	
	// strip 0X if it appears
	if ([cString hasPrefix:@"0X"])
	{
		cString = [cString substringFromIndex:2];
	}
	if ([cString hasPrefix:@"#"])
	{
		cString = [cString substringFromIndex:1];
	}
	
	// Separate into r, g, b substrings
	NSRange range;
	range.length = 2;
    
    if (cString.length == 8)
        range.location = 2;
    else
        range.location = 0;
    
	NSString *rString = [cString substringWithRange:range];
	
    if (cString.length == 8)
        range.location = 4;
    else
        range.location = 2;
    
	NSString *gString = [cString substringWithRange:range];
	
    if (cString.length == 8)
        range.location = 6;
    else
        range.location = 4;
    
	NSString *bString = [cString substringWithRange:range];
	
    range.location = 0;
    if (cString.length == 6)
        cString = [NSString stringWithFormat:@"FF%@", cString];
    
	NSString *aString = [cString substringWithRange:range];
	
	// Scan values
	unsigned int r, g, b, a;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	[[NSScanner scannerWithString:aString] scanHexInt:&a];
	
	return [UIColor colorWithRed:((float) r / 255.0f)
						   green:((float) g / 255.0f)
							blue:((float) b / 255.0f)
						   alpha:((float) a / 255.0f)];
}

+(void)resizeTouchableAreaForButton:(UIButton* )button withNewSize:(CGSize)size
{
    // increase margin around button based on width
    const CGFloat margin_h = 0.5f * ( size.width - button.frame.size.width );
    const CGFloat margin_v = 0.5f * ( size.height - button.frame.size.height );
    
    // add margin on all four sides of the button
    CGRect newFrame = button.frame;
    newFrame.origin.x -= margin_h;
    newFrame.origin.y -= margin_v;
    newFrame.size.width  += 2.0f * margin_h;
    newFrame.size.height += 2.0f * margin_v;
    
    button.frame = newFrame;
}

+(BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isEqualToString: @""]) {
        return YES;
    }
    
    return NO;
}

+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr), result );
    NSString *temp = [NSString stringWithFormat:
                      @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]
                      ];
    return [temp lowercaseString];
}

@end
