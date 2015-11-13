//
//  ModifyPersonViewController.h
//  LeTu
//
//  Created by mafeng on 14-9-18.
//
//

#import "BaseViewController.h"
@class UserDetailModel;


@interface ModifyPersonViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong) UserDetailModel* model;


@end
