//
//  CheckApplicationViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-4.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"
#import "CheckApplicationCell.h"

@interface CheckApplicationViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,CheckApplicationCellDelegate>
@property (copy, nonatomic) __block NSMutableArray *afs;
@property (weak, nonatomic) IBOutlet UITableView *table;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil afs:(NSMutableArray *)afs;
@end
