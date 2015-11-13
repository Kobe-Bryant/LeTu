//
//  DTButton.h
//  LeTu
//
//  Created by DT on 14-5-21.
//
//

#import <UIKit/UIKit.h>

@interface DTButton : UIButton

@property(nonatomic,strong)UIImage *normalImage;
@property(nonatomic,strong)UIImage *pressImage;
@property(nonatomic,assign)BOOL isSelect;
@property(nonatomic,strong)NSIndexPath *indexPath;

-(void)redDotNormal:(UIImage*)normalImage redDotPress:(UIImage*)pressImage;
@property(nonatomic,assign)BOOL isRedDot;

@end
