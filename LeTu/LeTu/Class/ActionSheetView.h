//
//  ActionSheetView.h
//  LeTu
//
//  Created by mafeng on 14-9-24.
//
//

#import <UIKit/UIKit.h>

@protocol sureDelegate <NSObject>

- (void)sureClickMethod:(NSString*)dateString;


@end

@interface ActionSheetView : UIView
@property(nonatomic,strong) id<sureDelegate> sureDelegate;

- (id)initWithHeight:(CGFloat)height backColor:(UIColor*)color;
- (void)addView:(UIView*)view;
- (void)show;
- (void)hide;
- (void)showOrHidden:(UITableView*)tableview indexPath:(NSIndexPath*)index isHidden:(BOOL)hidden;



@end
