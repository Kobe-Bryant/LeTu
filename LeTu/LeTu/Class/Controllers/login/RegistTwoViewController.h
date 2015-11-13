//
//  RegistTwoViewController.h
//  LeTu
//
//  Created by mafeng on 14-9-16.
//
//

#import <UIKit/UIKit.h>

@interface RegistTwoViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

- (id)initWithMobileTextfield:(NSString*)mobile captcha:(NSString*)captcha;

@end
