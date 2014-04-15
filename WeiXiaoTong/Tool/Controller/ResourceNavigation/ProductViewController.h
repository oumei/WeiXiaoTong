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
    NSIndexPath *shareIndexPath;
    UILabel *_spinner;
    NSString *html;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *cpsArr;
@property (strong, nonatomic) NSString *lx;
@property (strong, nonatomic) NSString *xb;
@property (strong, nonatomic) NSString *pp;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *isSelf;
//@property (strong, nonatomic) NSMutableArray *imageArr;
@property (assign, nonatomic) int imageCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cpsArr:(NSMutableArray *)cps;

@end
