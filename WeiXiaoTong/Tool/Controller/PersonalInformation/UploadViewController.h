//
//  UploadViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-11.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"
#import "ApplicablePeopleViewController.h"
#import "ApplicablePeopleCell.h"
#import "CDTextView.h"
#import "ZYQAssetPickerController.h"

@interface UploadViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,ApplicablePeopleCellDelegate,UITextFieldDelegate,UITextViewDelegate,ApplicablePeopleViewControllerDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate>
{
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
    NSArray *_contentsArr;
    
    NSString *_lx;
    NSString *_xb;         //适用人群
    NSString *_ss;         //售后服务
    NSString *_sts;        //鞋子类型
    NSString *_cs;         //手表机芯
    NSString *_ws;         //手表表带
    NSString *_bts;        //包包类型
    NSString *_bqs;        //产品品质
    NSString *_cts;        //服装类型
    NSString *_mts;        //彩妆类型
    
    NSMutableArray *_images;
    NSMutableArray *_bad;
    NSMutableArray *_well;
    
    NSString *cpid;
    UILabel *_spinner;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (copy, nonatomic) NSArray *data;
@property (strong, nonatomic) CDTextView *describeText;
@property (strong, nonatomic) UITextField *address;
@property (strong, nonatomic) UITextField *price;        //进货价
@property (strong, nonatomic) UITextField *agentPrice;   //代理价
@property (strong, nonatomic) UIView *lineOne;
@property (strong, nonatomic) UIView *lineTwo;
@property (strong, nonatomic) UIView *lineThree;
@property (strong, nonatomic) UIView *lineFour;
@property (strong, nonatomic) UIView *imagesView;
@property (strong, nonatomic) UIButton *chooseBtn;
//@property (strong, nonatomic) UIProgressView *progress;

@end
