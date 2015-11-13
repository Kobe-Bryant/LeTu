//
//  SearchContactViewController.h
//  LeTu
//
//  Created by mac on 14-6-18.
//
//

#import "BaseViewController.h"

@interface SearchContactViewController : BaseViewController<UITextFieldDelegate>
{
    UITextField *searchFriendTf;
    NSOperationQueue *queue;
}
@end
