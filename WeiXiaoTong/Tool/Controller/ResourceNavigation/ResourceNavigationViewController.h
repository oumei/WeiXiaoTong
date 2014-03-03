//
//  ResourceNavigationViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"

@interface ResourceNavigationViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_bazaars;
}
@property (copy, nonatomic) NSArray *bazaars;
@property (weak, nonatomic) IBOutlet UITableView *table;
@end
