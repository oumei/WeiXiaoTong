//
//  HomeViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"
#import "MerchantsCell.h"
#import "CheckApplicationViewController.h"

@interface HomeViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,MerchantsCellDelegate,UITextFieldDelegate,UIAlertViewDelegate,CheckApplicationViewControllerDelegate>
{
    NSMutableArray *_friendsMutArr;
    NSIndexPath *_lastIndexPath;
    NSIndexPath *_targetIndexPath;
    NSIndexPath *_friendIndexPath;
    UIView *alertView;
    UITextField *textMsg;
    UILabel *rightLabel;
    
    NSMutableArray *_changeData;
    NSTimer *_time;
    
    CGFloat height;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *addFriend;
@property (weak, nonatomic) IBOutlet UIButton *refreshFriend;
@property (weak, nonatomic) IBOutlet UIButton *applicantList;
@property (weak, nonatomic) IBOutlet UITextField *searchText;


@end
