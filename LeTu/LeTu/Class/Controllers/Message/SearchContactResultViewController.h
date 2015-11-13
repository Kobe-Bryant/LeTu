//
//  SearchContactResultViewController.h
//  LeTu
//
//  Created by mac on 14-6-18.
//
//

#import "BaseViewController.h"
#import "SearchResultModel.h"
@interface SearchContactResultViewController : BaseViewController
{
      NSOperationQueue *queue;
}
@property SearchResultModel* searchResultModel;

@end
