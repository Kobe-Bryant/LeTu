//
//  AddMeListViewController.h
//  LeTu
//
//  Created by mac on 14-7-3.
//
//

#import "BaseViewController.h"
#import "TableView.h"
@interface AddMeListViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITableViewRefresh>
{
    TableView *mTableView;
    
    NSOperationQueue *queue;

    int mPageIndex;

}
@end
