//
//  TableViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-7.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "TableViewController.h"
#import "UserEntity.h"

@interface TableViewController ()

@end

@implementation TableViewController
@synthesize dataArr = _dataArr;
@synthesize table = _table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSArray *)dataArr
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataArr = dataArr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //UserEntity *ue = [UserEntity shareCurrentUe];
    
    //*******************************headerView*****************************//
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 230, 35)];
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBtn.frame = CGRectMake(0, 0, 230, 35);
    [headerBtn setBackgroundImage:[UIImage imageNamed:@"long_button.png"] forState:0];
    [headerBtn setBackgroundImage:[UIImage imageNamed:@"long_button_over.png"] forState:UIControlStateHighlighted];
    [headerBtn addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 8, 20, 20)];
    imgView.image = [UIImage imageNamed:@"seach_icon.png"];
    [headerBtn addSubview:imgView];
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 100, 35)];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = @"查询商品";
    titleLable.textColor = [UIColor blueColor];
    titleLable.font = [UIFont systemFontOfSize:18];
    [headerBtn addSubview:titleLable];
    [headerView addSubview:headerBtn];
    self.table.tableHeaderView = headerView;
    headerBtn = nil;
    imgView = nil;
    titleLable = nil;
    headerView = nil;
    
    //********************************footView******************************//
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 230, 40)];
    UIButton *footBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    footBtn1.frame = CGRectMake(0, 0, 230, 35);
    [footBtn1 setBackgroundImage:[UIImage imageNamed:@"long_button.png"] forState:0];
    [footBtn1 setBackgroundImage:[UIImage imageNamed:@"long_button_over.png"] forState:UIControlStateHighlighted];
    [footBtn1 addTarget:self action:@selector(removeAttributes:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(2, 8, 20, 20)];
    imgView1.image = [UIImage imageNamed:@"clear_icon.png"];
    [footBtn1 addSubview:imgView1];
    UILabel *titleLable1 = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 150, 35)];
    titleLable1.backgroundColor = [UIColor clearColor];
    titleLable1.text = @"清除所选属性";
    titleLable1.textColor = [UIColor redColor];
    titleLable1.font = [UIFont systemFontOfSize:18];
    [footBtn1 addSubview:titleLable1];
    [footView addSubview:footBtn1];
    
    self.table.tableFooterView = footView;
    footBtn1 = nil;
    imgView1 = nil;
    titleLable1 = nil;
    footView = nil;

    [self.view addSubview:self.table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tableCell";
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell.btn setTitle:[NSString stringWithFormat:@"  %@",[self.dataArr objectAtIndex:indexPath.row]] forState:0];
    return cell;
}

- (void)seletedAction:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(seletedCell:IndexPath:)]) {
        [self.delegate performSelector:@selector(seletedCell:IndexPath:) withObject:sender withObject:indexPath];
    }
}

- (void)headerBtnAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(queryGoods:)]) {
        [self.delegate performSelector:@selector(queryGoods:) withObject:sender];
    }
}

- (void)removeAttributes:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeSelectedAttributes:)]) {
        [self.delegate performSelector:@selector(removeSelectedAttributes:) withObject:sender];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
