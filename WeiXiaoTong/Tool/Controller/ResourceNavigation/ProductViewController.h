//
//  ProductViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-27.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"
#import "ProductCell.h"
#import "WXApi.h"
#import "DetailsViewController.h"

@interface ProductViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,ProductCellDelegate,UITextFieldDelegate,DetailsViewControllerDelegate>
{
    UIView *alertView;
    UITextField *textMsg;
    NSIndexPath *targetIndexPath;
    UILabel *_spinner;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (copy, nonatomic) NSMutableArray *cpsArr;
@property (copy, nonatomic) NSString *lx;
@property (copy, nonatomic) NSString *xb;
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSString *isSelf;
@property (strong, nonatomic) NSMutableArray *imageArr;
@property (assign, nonatomic) int imageCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cpsArr:(NSMutableArray *)cps;

@end
