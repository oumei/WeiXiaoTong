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
- (void)upLoadImage:(id)sener suser:(NSDictionary *)suser;
@end

@interface TableViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,TableCellDelegate>
{
    NSArray *_dataArr;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray *dataArr;
@property (weak, nonatomic)id<TableViewControllerDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSArray *)dataArr;

@end
