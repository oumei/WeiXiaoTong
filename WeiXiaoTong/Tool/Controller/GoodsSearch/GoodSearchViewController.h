//
//  GoodSearchViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"
#import "CategoryCell.h"
#import "TableViewController.h"
#import "ApplicablePeopleViewController.h"

@interface GoodSearchViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,CategoryCellDelegate,UITextFieldDelegate,TableViewControllerDelegate,ApplicablePeopleViewControllerDelegate>
{
    NSArray *_categorys;
    NSIndexPath *_lastIndexPath;
    TableViewController *_tableViewController;
    NSArray *_categoryArr;
    
    NSArray *_all;             //全部
    NSArray *_other;           //其他
    NSArray *_shoes;           //鞋子
    NSArray *_watch;           //手表
    NSArray *_bag;             //包包
    NSArray *_wallet;          //皮夹
    NSArray *_silk;            //丝巾
    NSArray *_belt;            //皮带
    NSArray *_clothes;         //衣服
    NSArray *_hat;             //帽子
    NSArray *_glasses;         //眼镜
    NSArray *_jewelry;         //首饰
    NSArray *_cosmetics;       //护肤彩妆
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (retain, nonatomic) TableViewController *tableViewController;

@end
