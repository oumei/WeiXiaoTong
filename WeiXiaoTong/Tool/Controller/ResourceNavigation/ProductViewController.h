//
//  ProductViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-27.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"
#import "ProductCell.h"

@interface ProductViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,ProductCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (copy, nonatomic) NSMutableArray *cpsArr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cpsArr:(NSMutableArray *)cps;

@end
