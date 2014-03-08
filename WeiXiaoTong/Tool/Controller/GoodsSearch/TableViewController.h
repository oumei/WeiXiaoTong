//
//  TableViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-7.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"
#import "TableCell.h"
@protocol  TableViewControllerDelegate <NSObject>
- (void)seletedCell:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath;
- (void)queryGoods:(id)sender;
- (void)removeSelectedAttributes:(id)sender;
- (void)queryMyGoods:(id)sender;
@end

@interface TableViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,TableCellDelegate>
{
    NSArray *_dataArr;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (copy, nonatomic) NSArray *dataArr;
@property (assign, nonatomic)id<TableViewControllerDelegate> delegate;
@property (copy, nonatomic) NSIndexPath *indexPath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSArray *)dataArr;

@end