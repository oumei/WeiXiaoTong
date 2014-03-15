//
//  NavigationViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-26.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"

@interface NavigationViewController : CommonViewController<UITableViewDataSource,UITableViewDataSource,UITextFieldDelegate>
{
    NSTimer *_time;
    NSArray *_changeData;
}

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSArray *linksArr;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil links:(NSArray *)linksArr;
@end
