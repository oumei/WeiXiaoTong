//
//  HomeViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"
#import "MerchantsCell.h"

@interface HomeViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,MerchantsCellDelegate>
{
    NSMutableArray *_friendsMutArr;
    NSIndexPath *_lastIndexPath;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *addNewMer;

@end
