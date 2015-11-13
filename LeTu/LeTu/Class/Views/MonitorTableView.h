//
//  MonitorTableView.h
//  Monitor
//
//  Created by Cyberway on 13-9-5.
//
//

#import <UIKit/UIKit.h>
#import "TableView.h"

@interface MonitorTableView : UIView<UITableViewDataSource,UITableViewDelegate,UITableViewRefresh>
{
    UIViewController *mViewController;
    TableView *mTableView;
    int mPageIndex;
}
- (id)initWithViewController:(UIViewController *)viewController;

- (NSMutableArray *)getTableArray;

- (int) getPageIndex;

- (void)reloadData:(int)count;
@end
