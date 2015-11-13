//
//  ContactPersonsViewController.h
//  LeTu
//
//  Created by mac on 14-5-12.
//
//

#import "BaseViewController.h"
#import "BATableView.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
@interface ContactPersonsViewController : BaseViewController<BATableViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UIView *headerView;
    
    
    NSMutableArray *searchResults;
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *dataArray;
     BOOL isOpen;
    UIView *mContainer;
      NSOperationQueue *queue;
    UISwipeGestureRecognizer *swipeGes;
    NSMutableDictionary *pictureDict;
    NSMutableDictionary *idDict;
    UIButton *newFriendBtn;
    UIButton *addBtn;
    UIView *remindView;
    
    int selectRow;
    
}
@property (nonatomic, strong) BATableView *contactTableView;
@property (nonatomic, strong) NSArray * dataSource;
@end
