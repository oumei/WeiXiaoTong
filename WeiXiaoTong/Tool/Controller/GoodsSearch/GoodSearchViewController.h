//
//  GoodSearchViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"
#import "CategoryCell.h"

@interface GoodSearchViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,CategoryCellDelegate>
{
    NSArray *_categorys;
    NSIndexPath *_lastIndexPath;
}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
