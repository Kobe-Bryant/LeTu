//
//  DTGridTableView.m
//  gridView
//
//  Created by DT on 14-5-24.
//  Copyright (c) 2014年 DT. All rights reserved.
//

#import "DTGridTableView.h"
#import "DTGridTableViewConstants.h"

@implementation DTGridTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)-kPaddingY) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.dataSource = self;
        self.tableView.delegate   = self;
        [self addSubview:self.tableView];
    }
    return self;
}
- (void)reloadData{
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    float rows = (float)[self.datasource numberOfGrids]/[self.datasource numberOfGridsInRow];
    return ceil(rows);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.frame.size.width/[_datasource numberOfGridsInRow];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    DTGridTableViewCell *cell = (DTGridTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DTGridTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier
                                                 delegate:self
                                                rowNumber:[self.datasource numberOfGridsInRow]
                                                rowHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath]
                                                indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    for (int i=0; i<[cell.gridViews count]; i++) {
        UIView *gridView = [cell.gridViews objectAtIndex:i];
        int index = indexPath.row *[self.datasource numberOfGridsInRow]+i;
        if (index >=[self.datasource numberOfGrids]) {
            gridView.hidden = YES;
        }else{
            gridView.hidden = NO;
            if ([self.delegate respondsToSelector:@selector(gridView:gridViewForRowAtIndexPath:)]) {
                [self.delegate gridView:gridView gridViewForRowAtIndexPath:index];
            }
        }
    }
    return cell;
    
}

#pragma mark DTGridTableViewCellDelegate
- (UIView*)viewAtIndex:(NSInteger)index size:(CGSize)size
{
    return [self.datasource viewAtIndex:index size:size];
}

- (void)gridView:(UIView*)gridView gridViewForRowAtIndexPath:(int)index;
{
    if ([self.delegate respondsToSelector:@selector(gridView:gridViewForRowAtIndexPath:)]) {
        [self.delegate gridView:self gridViewForRowAtIndexPath:index];
    }
}
@end
