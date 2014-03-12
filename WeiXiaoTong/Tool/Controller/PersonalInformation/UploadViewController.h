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

@interface UploadViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,ApplicablePeopleCellDelegate,UITextFieldDelegate,UITextViewDelegate,ApplicablePeopleViewControllerDelegate>
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
    NSString *_ms;         //产品材质
    NSString *_bhs;        //闭合方式
    NSString *_cs;         //手表机芯
    NSString *_ws;         //手表表带
    NSString *_bts;        //包包类型
    NSString *_bqs;        //产品品质
    NSString *_cts;        //服装类型
    NSString *_mts;        //彩妆类型
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (copy, nonatomic) NSArray *data;
@property (retain, nonatomic) CDTextView *describeText;
@property (retain, nonatomic) UITextField *address;
@property (retain, nonatomic) UITextField *price;        //进货价
@property (retain, nonatomic) UITextField *agentPrice;   //代理价
@property (retain, nonatomic) UIView *lineOne;
@property (retain, nonatomic) UIView *lineTwo;
@property (retain, nonatomic) UIView *lineThree;
@property (retain, nonatomic) UIView *lineFour;

@end
