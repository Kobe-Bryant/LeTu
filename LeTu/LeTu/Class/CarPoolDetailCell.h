//
//  CarPoolDetailCell.h
//  LeTu
//
//  Created by mafeng on 14-9-22.
//
//

#import <UIKit/UIKit.h>
@class LeTuRouteModel;
@class ApplyPersonModel;
@class ActionButton;


@protocol clickAcceptButtonDelegate <NSObject>

//刷新表示图。
//接受车主调用的方法
- (void)refreshTableViewHeadView:(ApplyPersonModel*)model acceptType:(NSInteger)type;
//取消调用的方法 //车主发起取消方法
- (void)cancelTableViewHeadView:(ApplyPersonModel*)model cancelType:(NSInteger)type;
//取消调用的方法 //乘客参与取消方法
- (void)coustomCancelTableViewHeadView:(ApplyPersonModel*)model cancelType:(NSInteger)type;

//接受乘客调用的方法
- (void)coustomRefreshTableViewHeadView:(ApplyPersonModel*)model coustomAcceptType:(NSInteger)type;
//取消调用的方法 //乘客发起取消方法
- (void)coustomFAqiCancelTableViewHeadView:(ApplyPersonModel*)model cancelType:(NSInteger)type;
//取消调用的方法 //车主参与取消方法
- (void)cheZhuCancelTableViewHeadView:(ApplyPersonModel*)model cancelType:(NSInteger)type;

- (void)refreshTableViewCell;




@end
typedef enum : NSInteger{
    
    CarPoolDetailTableViewFirstCell = 0,
    CarPoolDetailTableViewMiddleCell = 1 <<0 ,
    CarPoolDetailTableViewLastCell = 1 <<1

}CarPoolTableViewCellStyle;



@interface CarPoolDetailCell : UITableViewCell
@property(nonatomic,strong) LeTuRouteModel* model;
@property(nonatomic,strong) ApplyPersonModel* applyModel;

@property(nonatomic,assign) id<clickAcceptButtonDelegate> clickButtonDelegate;
@property(nonatomic,strong) ActionButton* acceptButton;//接受按钮
@property(nonatomic,strong) ActionButton* cancelButton;//取消按钮
@property(nonatomic,strong) ActionButton* joinButton;




- (id)initWithStyle:(UITableViewCellStyle)systemCellStyle customCellStyle:(CarPoolTableViewCellStyle)carPoolTableViewCellStyle;

- (void)setCellInfomation:(ApplyPersonModel*)model;




@end
