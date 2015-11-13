//
//  MessageBoxViewController.h
//  LeTu
//
//  Created by mac on 14-5-12.
//
//

#import "BaseViewController.h"
#import "TableView.h"
@interface MessageBoxViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITableViewRefresh>
{
    UIButton *contactPersonBtn;
    NSOperationQueue *queue;
    TableView *mTableView;
    
    int mPageIndex;
    BOOL isOpen;
    UISwipeGestureRecognizer *swipeGes;
    NSTimer *timer;
    NSTimer *newFriendTimer;
    UILabel *tipLabel;
}


@end
