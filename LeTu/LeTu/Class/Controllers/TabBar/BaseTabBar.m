//
//  BaseTabBar.m
//  CBD
//
//  Created by Roland on 12-7-11.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseTabBar.h"
#import "TabBarController.h"




@interface BaseTabBar (Private)

-(UIImage*) tabBarImage:(UIImage*)startImage size:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage;

@end

@implementation BaseTabBar

@synthesize delegate = _delegate;

@synthesize buttons,currentSelectedIndex;
@synthesize viewController;



- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
                   tabImages = [[NSArray alloc] initWithObjects:
                         [UIImage imageNamed:@"letu_navbtn_letu_normal"],
                         [UIImage imageNamed:@"letu_navbtn_message_normal"],
                         [UIImage imageNamed:@"letu_navbtn_find_normal"],
                         [UIImage imageNamed:@"letu_navbtn_my_normal"],
                         nil];
            tabActImages = [[NSArray alloc] initWithObjects:
                            [UIImage imageNamed:@"letu_navbtn_letu_press"],
                            [UIImage imageNamed:@"letu_navbtn_message_press"],
                            [UIImage imageNamed:@"letu_navbtn_find_press"],
                            [UIImage imageNamed:@"letu_navbtn_my_pressl"],
                            nil];

              // Initialization code.
    }
    return self;
}
- (id)initWithBackgroundImageForView:(UIImage *)bgImage
                           ViewCount:(NSUInteger)count
                      ViewController:(UIViewController *)vc
{
    self = [super init];
	if (self != nil) {
		//create scroll view
        float scrollViewHeight = 49;
        float scrollViewWidth  = 320;
        float Y=(float)431/480;
		//tabBarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 431, scrollViewWidth, scrollViewHeight)];
        int y = Y*[[UIScreen mainScreen]bounds].size.height;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)
        {
            y -= 20;
        }
        if ([[UIScreen mainScreen]bounds].size.height==480)
        {
            tabBarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, scrollViewWidth, scrollViewHeight)];
        }
        else if([[UIScreen mainScreen]bounds].size.height==568)
        {
            y += 10;
            tabBarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, scrollViewWidth, scrollViewHeight)];
        }
        
//        float scrollViewHeight = 47;
//        float scrollViewWidth  = 320;
//		tabBarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 414, scrollViewWidth, scrollViewHeight)];
		[tabBarScrollView setCanCancelContentTouches:NO];
		[tabBarScrollView setClipsToBounds:NO];
		tabBarScrollView.showsHorizontalScrollIndicator = NO;
		
		slideBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide"]];
		CGRect slideBgFrame = slideBg.frame;
		//self.viewController = vc;
		CGRect tabBarFrame = viewController.tabBarView.frame;
		self.frame = tabBarFrame;
		//添加背景图片
		CGRect bgImageFrame = CGRectMake(0, 414, 320, 47);
		UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
		bgImageView.frame = bgImageFrame;
		[vc.view addSubview:bgImageView];
		
		
		//遍历buttons
		self.buttons = [NSMutableArray arrayWithCapacity:count];
		double btnWidth = 320 / 5;
		double btnHeight = 43;
		slideBgFrame.size.width = btnWidth;
		slideBgFrame.origin.x = 0;
		slideBg.frame = slideBgFrame;
		for (int i = 0; i < count; i++) {
			UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
			btn.frame = CGRectMake(i * btnWidth, 0, btnWidth, btnHeight);
			btn.tag = i;
			//设定btn的响应方法
			[btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
            // NSString *imageName = [NSString stringWithFormat:@"tab%d.png",i+1];
            //UIImage *icon = [UIImage imageNamed:imageName];
            
			[btn setImage:[tabImages objectAtIndex:i] forState:UIButtonTypeCustom];
           	//btn.imageEdgeInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
			//NSLog(@"%@",[btn.imageView.superview description]);
			
			
			[buttons addObject:btn];
			[tabBarScrollView addSubview:btn];
			//[tabBarScrollView addSubview:slideBg];
		}
		[vc.view addSubview:tabBarScrollView];
        [tabBarScrollView setContentSize:CGSizeMake(count * btnWidth, scrollViewHeight)];
	}
	return self;
    
}

- (id)initWithBackgroundImage:(UIImage *)bgImage 
					ViewCount:(NSUInteger)count 
			   ViewController:(TabBarController *)vc{
    self = [super init];
	if (self != nil) {
		//create scroll view
        float scrollViewHeight = 49;
        float scrollViewWidth  = 320;
        float Y=(float)431/480;
        
        int y = Y*[[UIScreen mainScreen]bounds].size.height;
//        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)
//        {
//            y -= 20;
//        }
        if ([[UIScreen mainScreen]bounds].size.height==480)
        {
            tabBarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, scrollViewWidth, scrollViewHeight)];
        }
        else if([[UIScreen mainScreen]bounds].size.height==568)
        {
            y += 10;
            tabBarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, scrollViewWidth, scrollViewHeight)];
        }
        
		[tabBarScrollView setCanCancelContentTouches:NO];
		[tabBarScrollView setClipsToBounds:NO];
		tabBarScrollView.showsHorizontalScrollIndicator = NO;
		
		slideBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide"]];
		CGRect slideBgFrame = slideBg.frame;
		self.viewController = vc;
		CGRect tabBarFrame = viewController.tabBarView.frame;
		self.frame = tabBarFrame;
		//添加背景图片
        CGRect bgImageFrame;
        if ([[UIScreen mainScreen]bounds].size.height==480)
        {
            bgImageFrame = CGRectMake(0, y, 320, 49);
        }
        else if([[UIScreen mainScreen]bounds].size.height==568)
        {
            bgImageFrame = CGRectMake(0, y, 320, 49);
        }
		UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
		bgImageView.frame = bgImageFrame;
		[self.viewController.view addSubview:bgImageView];
		
		
		//遍历buttons
		self.buttons = [NSMutableArray arrayWithCapacity:count];
		double btnWidth = 320 / 4;
		double btnHeight = 49;
		slideBgFrame.size.width = btnWidth;
		slideBgFrame.origin.x = vc.selectedIndex * btnWidth;
		slideBg.frame = slideBgFrame;
		for (int i = 0; i < count; i++) {
			UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
			btn.frame = CGRectMake(i * btnWidth, 0, btnWidth, btnHeight);
			btn.tag = i;
			//设定btn的响应方法
			[btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
           // NSString *imageName = [NSString stringWithFormat:@"tab%d.png",i+1];
            //UIImage *icon = [UIImage imageNamed:imageName];
            
			[btn setImage:[tabImages objectAtIndex:i] forState:UIButtonTypeCustom];
           	//btn.imageEdgeInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
			//NSLog(@"%@",[btn.imageView.superview description]);
			
			
			[buttons addObject:btn];
			[tabBarScrollView addSubview:btn];
			//[tabBarScrollView addSubview:slideBg];
		}
		[self.viewController.view addSubview:tabBarScrollView];
        [tabBarScrollView setContentSize:CGSizeMake(count * btnWidth, scrollViewHeight)];
	}
	return self;
}


//切换tabbar
- (void)selectedTab:(UIButton *)button{
         
                   if (self.currentSelectedIndex != button.tag) {
                UIButton *currenBut = (UIButton *)[buttons objectAtIndex:self.currentSelectedIndex];
                //NSString *curimageName = [NSString stringWithFormat:@"tab%d.png",self.currentSelectedIndex+1];
                //UIImage *curIcon = [UIImage imageNamed:curimageName];
                [currenBut setImage:[tabImages objectAtIndex:self.currentSelectedIndex] forState:UIButtonTypeCustom];
            }
            self.currentSelectedIndex = button.tag;
            //NSString *imageName = [NSString stringWithFormat:@"tab%d_act.png",button.tag+1];
            //UIImage *selectIcon = [UIImage imageNamed:imageName];
            [button setImage:[tabActImages objectAtIndex:self.currentSelectedIndex] forState:UIButtonTypeCustom];
           
            if (self.delegate && [self.delegate respondsToSelector:@selector(clickTab:)]) {
                [self.delegate clickTab:self.currentSelectedIndex];
                [self performSelector:@selector(slideTabBg:) withObject:button];
            }

}

- (void)currentTab:(int)currentIndex
{
           if (self.currentSelectedIndex != currentIndex) {
             UIButton *currenBut = (UIButton *)[buttons objectAtIndex:self.currentSelectedIndex];
             [currenBut setImage:[tabImages objectAtIndex:self.currentSelectedIndex] forState:UIButtonTypeCustom];
             
         }
        
        self.currentSelectedIndex = currentIndex;
        
        UIButton *button = (UIButton *)[buttons objectAtIndex:currentIndex];
        [button setImage:[tabActImages objectAtIndex:self.currentSelectedIndex] forState:UIButtonTypeCustom];
        
       
         if (self.delegate && [self.delegate respondsToSelector:@selector(clickTab:)]) {
                [self.delegate clickTab:self.currentSelectedIndex];
                [self performSelector:@selector(slideTabBg:) withObject:button];
            }

        


}


//切换滑块位置
- (void)slideTabBg:(UIButton *)btn{
	[UIView beginAnimations:nil context:nil];  
	[UIView setAnimationDuration:0.20];  
	[UIView setAnimationDelegate:self];
	slideBg.frame = btn.frame;
	[UIView commitAnimations];
	CAKeyframeAnimation * animation; 
	animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"]; 
	animation.duration = 0.50; 
	animation.delegate = self;
	animation.removedOnCompletion = YES;
	animation.fillMode = kCAFillModeForwards;
	NSMutableArray *values = [NSMutableArray array];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]]; 
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]]; 
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
	animation.values = values;
	[btn.layer addAnimation:animation forKey:nil];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */


-(UIImage*) tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage
{
	// The background is either the passed in background image (for the blue selected state) or gray (for the non-selected state)
	UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
	if (backgroundImage)
	{
		// Draw the background image centered
		[backgroundImage drawInRect:CGRectMake((targetSize.width - CGImageGetWidth(backgroundImage.CGImage)) / 2, (targetSize.height - CGImageGetHeight(backgroundImage.CGImage)) / 2, CGImageGetWidth(backgroundImage.CGImage), CGImageGetHeight(backgroundImage.CGImage))];
	}
	else
	{
		[[UIColor lightGrayColor] set];
		UIRectFill(CGRectMake(0, 0, targetSize.width, targetSize.height));
	}
	
	UIImage* finalBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return finalBackgroundImage;
}

// Convert the image's fill color to black and background to white
-(UIImage*) blackFilledImageWithWhiteBackgroundUsing:(UIImage*)startImage
{
	// Create the proper sized rect
	CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));
	
	// Create a new bitmap context
	CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(startImage.CGImage), kCGImageAlphaPremultipliedLast);
	
	CGContextSetRGBFillColor(context, 1, 1, 1, 1);
	CGContextFillRect(context, imageRect);
	
	// Use the passed in image as a clipping mask
	CGContextClipToMask(context, imageRect, startImage.CGImage);
	// Set the fill color to black: R:0 G:0 B:0 alpha:1
	CGContextSetRGBFillColor(context, 0, 0, 0, 1);
	// Fill with black
	CGContextFillRect(context, imageRect);
	
	// Generate a new image
	CGImageRef newCGImage = CGBitmapContextCreateImage(context);
	UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:startImage.scale orientation:startImage.imageOrientation];
	
	// Cleanup
	CGContextRelease(context);
	CGImageRelease(newCGImage);
	
	return newImage;
}

// Create a tab bar image
-(UIImage*) tabBarImage:(UIImage*)startImage 
				   size:(CGSize)targetSize 
		backgroundImage:(UIImage*)backgroundImageSource
{
	// The background is either the passed in background image (for the blue selected state) or gray (for the non-selected state)
	UIImage* backgroundImage = [self tabBarBackgroundImageWithSize:startImage.size backgroundImage:backgroundImageSource];
	
	// Convert the passed in image to a white backround image with a black fill
	UIImage* bwImage = [self blackFilledImageWithWhiteBackgroundUsing:startImage];
	
	// Create an image mask
	CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(bwImage.CGImage),
											 CGImageGetHeight(bwImage.CGImage),
											 CGImageGetBitsPerComponent(bwImage.CGImage),
											 CGImageGetBitsPerPixel(bwImage.CGImage),
											 CGImageGetBytesPerRow(bwImage.CGImage),
											 CGImageGetDataProvider(bwImage.CGImage), NULL, YES);
	
	// Using the mask create a new image
	CGImageRef tabBarImageRef = CGImageCreateWithMask(backgroundImage.CGImage, imageMask);
	
	UIImage* tabBarImage = [UIImage imageWithCGImage:tabBarImageRef scale:startImage.scale orientation:startImage.imageOrientation];
	
	// Cleanup
	CGImageRelease(imageMask);
	CGImageRelease(tabBarImageRef);
	
	// Create a new context with the right size
	UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
	
	// Draw the new tab bar image at the center
	[tabBarImage drawInRect:CGRectMake((targetSize.width/2.0) - (startImage.size.width/2.0), (targetSize.height/2.0) - (startImage.size.height/2.0), startImage.size.width, startImage.size.height)];
	
	// Generate a new image
	UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return resultImage;
}

@end
