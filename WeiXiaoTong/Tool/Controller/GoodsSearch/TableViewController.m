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
    UserEntity *ue = [UserEntity shareCurrentUe];
    
    //*******************************headerView*****************************//
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 230, 35)];
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBtn.frame = CGRectMake(0, 0, 230, 35);
    [headerBtn setBackgroundImage:[UIImage imageNamed:@"long_button.png"] forState:0];
    [headerBtn setBackgroundImage:[UIImage imageNamed:@"long_button_over.png"] forState:UIControlStateHighlighted];
    [headerBtn addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 3, 20, 28)];
    imgView.backgroundColor = [UIColor redColor];
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
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 230, 75)];
    UIButton *footBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    footBtn1.frame = CGRectMake(0, 0, 230, 35);
    [footBtn1 setBackgroundImage:[UIImage imageNamed:@"long_button.png"] forState:0];
    [footBtn1 setBackgroundImage:[UIImage imageNamed:@"long_button_over.png"] forState:UIControlStateHighlighted];
    [footBtn1 addTarget:self action:@selector(removeAttributes:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(2, 3, 20, 28)];
    imgView1.backgroundColor = [UIColor redColor];
    [footBtn1 addSubview:imgView1];
    UILabel *titleLable1 = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 150, 35)];
    titleLable1.backgroundColor = [UIColor clearColor];
    titleLable1.text = @"清除所选属性";
    titleLable1.textColor = [UIColor redColor];
    titleLable1.font = [UIFont systemFontOfSize:18];
    [footBtn1 addSubview:titleLable1];
    [footView addSubview:footBtn1];
    
    UIButton *footBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    footBtn2.frame = CGRectMake(0, 36, 230, 35);
    if (ue.level < 1) {
        footBtn2.hidden = YES;
    }
    [footBtn2 setBackgroundImage:[UIImage imageNamed:@"long_button.png"] forState:0];
    [footBtn2 setBackgroundImage:[UIImage imageNamed:@"long_button_over.png"] forState:UIControlStateHighlighted];
    [footBtn2 addTarget:self action:@selector(footBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(2, 3, 20, 28)];
    imgView2.backgroundColor = [UIColor redColor];
    [footBtn2 addSubview:imgView2];
    UILabel *titleLable2 = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 150, 35)];
    titleLable2.backgroundColor = [UIColor clearColor];
    titleLable2.text = @"查询我的商品";
    titleLable2.textColor = [UIColor blueColor];
    titleLable2.font = [UIFont systemFontOfSize:18];
    [footBtn2 addSubview:titleLable2];
    [footView addSubview:footBtn2];
    self.table.tableFooterView = footView;
    footBtn1 = nil;
    footBtn2 = nil;
    imgView1 = nil;
    imgView2 = nil;
    titleLable1 = nil;
    titleLable2 = nil;
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

- (void)footBtnAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(queryMyGoods:)]) {
        [self.delegate performSelector:@selector(queryMyGoods:) withObject:sender];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
