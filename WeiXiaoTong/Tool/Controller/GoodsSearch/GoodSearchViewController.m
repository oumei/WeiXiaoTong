//
//  GoodSearchViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "GoodSearchViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "TableCell.h"
#import "ObjectVo.h"
#import "UserEntity.h"
#import "HttpService.h"
#import "ProductViewController.h"
#import "JSON.h"
#import "ChanPin.h"
#include<objc/runtime.h>
#import "UploadViewController.h"
#import "ResultsModel.h"

@interface GoodSearchViewController ()

@end

@implementation GoodSearchViewController
@synthesize tableViewController = _tableViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _lastIndexPath = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    height = self.table.frame.size.height;
    self.searchText.frame = CGRectMake(self.searchText.frame.origin.x, self.searchText.frame.origin.y, [UIScreen mainScreen].bounds.size.width - 84 - 45, self.searchText.frame.size.height);
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    icon.image = [UIImage imageNamed:@"up_icon.png"];
    [leftView addSubview:icon];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    leftView = nil;
    icon = nil;
    leftBarButton = nil;
    
    self.title = @"商品查找";
    
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    NSDictionary *baseData = [ob valueForKey:@"baseData"];
    _categorys = [baseData valueForKey:@"lxs"];
    
    _all = @[@"选择适用人群",@"选择售后服务",@"选择产品品牌"];
    _other = @[@"选择适用人群",@"选择售后服务",@"选择产品品牌"];
    _shoes = @[@"选择适用人群",@"选择售后服务",@"选择产品品牌",@"选择鞋子类型"];
    _watch = @[@"选择适用人群",@"选择售后服务",@"选择产品品牌",@"选择手表机芯",@"选择手表表带"];
    _bag = @[@"选择适用人群",@"选择售后服务",@"选择产品品牌",@"选择包包类型",@"选择产品品质"];
    _wallet = @[@"选择适用人群",@"选择售后服务",@"选择产品品牌"];
    _silk = @[@"选择适用人群",@"选择售后服务",@"选择产品品牌"];
    _belt = @[@"选择适用人群",@"选择售后服务",@"选择产品品牌",@"选择产品品质"];
    _clothes = @[@"选择适用人群",@"选择售后服务",@"选择产品品牌",@"选择服装类型"];
    _hat = @[@"选择适用人群",@"选择售后服务",@"选择产品品牌"];
    _glasses = @[@"选择适用人群",@"选择售后服务",@"选择产品品牌"];
    _jewelry = @[@"选择适用人群",@"选择售后服务",@"选择产品品牌"];
    _cosmetics = @[@"选择适用人群",@"选择售后服务",@"选择产品品牌",@"选择彩妆类型"];
    _gShoes = @[@"选择适用人群",@"选择售后服务",@"选择产品品牌",@"选择鞋子类型",@"选择鞋跟高度"];
    
    _tableViewController = [[TableViewController alloc]initWithNibName:@"TableViewController" bundle:nil data:_all];
//    _tableViewController.table.frame = CGRectMake(_tableViewController.table.frame.origin.x, _tableViewController.table.frame.origin.y, [UIScreen mainScreen].bounds.size.width - 84, _tableViewController.table.frame.size.height);
    _tableViewController.delegate = self;
    [self.view insertSubview:_tableViewController.view atIndex:0];

}

- (IBAction)cancelAction:(id)sender
{
    self.searchText.text = nil;
}

#pragma mark - tableView delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _categorys.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifier = @"categoryCell";
//    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    CategoryCell *cell;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoryCell" owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.categoryBtn.clipsToBounds = YES;
    if (indexPath.row == 0) {
        [cell.categoryBtn setTitle:@"全部" forState:0];
        if (_lastIndexPath == nil) {
            cell.categoryBtn.selected = YES;
            _lastIndexPath = indexPath;
        }
    }else{
        [cell.categoryBtn setTitle:[[_categorys objectAtIndex:indexPath.row - 1] valueForKey:@"name"] forState:0];
    }
    
    if (_lastIndexPath) {
        if (indexPath.row == _lastIndexPath.row) {
            cell.categoryBtn.selected = YES;
        }else{
            cell.categoryBtn.selected = NO;
        }
    }
    if (_indexPath == nil) {
        _indexPath = indexPath;
    }
    return cell;
}

- (void)selecte:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    if (_lastIndexPath == nil) {
        _lastIndexPath = indexPath;
    }else{
        CategoryCell *cell = (CategoryCell *)[self.table cellForRowAtIndexPath:_lastIndexPath];
        [cell.categoryBtn setSelected:NO];
        _lastIndexPath = indexPath;
    }
    [sender setSelected:YES];
//    _tableViewController.dataArr = [_categoryArr objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        _tableViewController.dataArr = _all;
        [_tableViewController.table reloadData];
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(tableViewControllerReloadData) userInfo:nil repeats:NO];
        _indexPath = indexPath;
        return;
    }
    if ([[[_categorys objectAtIndex:indexPath.row - 1] valueForKey:@"id"] intValue] == 3) {
        _tableViewController.dataArr = _bag;
    }else if ([[[_categorys objectAtIndex:indexPath.row - 1] valueForKey:@"id"] intValue] == 12){
        _tableViewController.dataArr = _cosmetics;
    }else if ([[[_categorys objectAtIndex:indexPath.row - 1] valueForKey:@"id"] intValue] == 8){
        _tableViewController.dataArr = _hat;
    }else if ([[[_categorys objectAtIndex:indexPath.row - 1] valueForKey:@"id"] intValue] == 6){
        _tableViewController.dataArr = _belt;
    }else if ([[[_categorys objectAtIndex:indexPath.row - 1] valueForKey:@"id"] intValue] == 13){
        _tableViewController.dataArr = _wallet;
    }else if ([[[_categorys objectAtIndex:indexPath.row - 1] valueForKey:@"id"] intValue] == 0){
        _tableViewController.dataArr = _other;
    }else if ([[[_categorys objectAtIndex:indexPath.row - 1] valueForKey:@"id"] intValue] == 2){
        _tableViewController.dataArr = _watch;
    }else if ([[[_categorys objectAtIndex:indexPath.row - 1] valueForKey:@"id"] intValue] == 10){
        _tableViewController.dataArr = _jewelry;
    }else if ([[[_categorys objectAtIndex:indexPath.row - 1] valueForKey:@"id"] intValue] == 5){
        _tableViewController.dataArr = _silk;
    }else if ([[[_categorys objectAtIndex:indexPath.row - 1] valueForKey:@"id"] intValue] == 1){
        _tableViewController.dataArr = _shoes;
        if ([_xb intValue] == 3) {
            _tableViewController.dataArr = _gShoes;
        }
    }else if ([[[_categorys objectAtIndex:indexPath.row - 1] valueForKey:@"id"] intValue] == 9){
        _tableViewController.dataArr = _glasses;
    }else if ([[[_categorys objectAtIndex:indexPath.row - 1] valueForKey:@"id"] intValue] == 7){
        _tableViewController.dataArr = _clothes;
    }else{
        _tableViewController.dataArr = _all;
    }
//    NSLog(@"%d,%@",[[[_categorys objectAtIndex:indexPath.row] valueForKey:@"id"] intValue],[[_categorys objectAtIndex:indexPath.row] valueForKey:@"name"]);
//    if ([_xb intValue] == 3 && [[[_categorys objectAtIndex:indexPath.row] valueForKey:@"id"] intValue] == 1) {
//        _tableViewController.dataArr = _gShoes;
//    }
    [_tableViewController.table reloadData];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(tableViewControllerReloadData) userInfo:nil repeats:NO];
    _indexPath = indexPath;
}

- (void)tableViewControllerReloadData
{
    [_tableViewController.table reloadData];
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    NSDictionary *baseData = [ob valueForKey:@"baseData"];
    NSArray *cells = [_tableViewController.table visibleCells];
    if (_tableViewController.dataArr.count > 3) {
        for (int i = 0; i < cells.count - 2; i ++) {
            TableCell *cell = [cells objectAtIndex:i + 2];
//            NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
            if ([cell.btn.titleLabel.text rangeOfString:@"鞋子类型"].location != NSNotFound && _sts != nil) {
//                NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
                NSArray *sts = [baseData valueForKey:@"sts"];
                for (int i = 0; i < sts.count; i++) {
                    if ([[sts objectAtIndex:i] valueForKey:@"id"] == _sts && [_sts intValue] != -1) {
                        [cell.btn setTitle:[NSString stringWithFormat:@"  鞋子类型：%@",[[sts objectAtIndex:i] valueForKey:@"name"]] forState:0];
                    }
                }
            }else if ([cell.btn.titleLabel.text rangeOfString:@"手表机芯"].location != NSNotFound && _cs != nil) {
                NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
                NSArray *cs = [baseData valueForKey:@"cs"];
                for (int i = 0; i < cs.count; i++) {
                    if ([[cs objectAtIndex:i] valueForKey:@"id"] == _cs && [_cs intValue] != -1) {
                        [cell.btn setTitle:[NSString stringWithFormat:@"  手表机芯：%@",[[cs objectAtIndex:i] valueForKey:@"name"]] forState:0];
                    }
                }
            }else if ([cell.btn.titleLabel.text rangeOfString:@"手表表带"].location != NSNotFound && _ws != nil) {
                NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
                NSArray *ws = [baseData valueForKey:@"ws"];
                for (int i = 0; i < ws.count; i++) {
                    if ([[ws objectAtIndex:i] valueForKey:@"id"] == _ws && [_ws intValue] != -1) {
                        [cell.btn setTitle:[NSString stringWithFormat:@"  手表表带：%@",[[ws objectAtIndex:i] valueForKey:@"name"]] forState:0];
                    }
                }
            }else if ([cell.btn.titleLabel.text rangeOfString:@"包包类型"].location != NSNotFound && _bts != nil) {
                NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
                NSArray *bts = [baseData valueForKey:@"bts"];
                for (int i = 0; i < bts.count; i++) {
                    if ([[bts objectAtIndex:i] valueForKey:@"id"] == _bts && [_bts intValue] != -1) {
                        [cell.btn setTitle:[NSString stringWithFormat:@"  包包类型：%@",[[bts objectAtIndex:i] valueForKey:@"name"]] forState:0];
                    }
                }
            }else if ([cell.btn.titleLabel.text rangeOfString:@"产品品质"].location != NSNotFound && _bqs != nil) {
                NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
                NSArray *bqs = [baseData valueForKey:@"bqs"];
                for (int i = 0; i < bqs.count; i++) {
                    if ([[bqs objectAtIndex:i] valueForKey:@"id"] == _bqs && [_bqs intValue] != -1) {
                        [cell.btn setTitle:[NSString stringWithFormat:@"  产品品质：%@",[[bqs objectAtIndex:i] valueForKey:@"name"]] forState:0];
                    }
                }
            }else if ([cell.btn.titleLabel.text rangeOfString:@"服装类型"].location != NSNotFound && _cts != nil) {
                NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
                NSArray *cts = [baseData valueForKey:@"cts"];
                for (int i = 0; i < cts.count; i++) {
                    if ([[cts objectAtIndex:i] valueForKey:@"id"] == _cts && [_cts intValue] != -1) {
                        [cell.btn setTitle:[NSString stringWithFormat:@"  服装类型：%@",[[cts objectAtIndex:i] valueForKey:@"name"]] forState:0];
                    }
                }
            }else if ([cell.btn.titleLabel.text rangeOfString:@"彩妆类型"].location != NSNotFound && _mts != nil) {
                NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
                NSArray *mts = [baseData valueForKey:@"mts"];
                for (int i = 0; i < mts.count; i++) {
                    if ([[mts objectAtIndex:i] valueForKey:@"id"] == _mts && [_mts intValue] != -1) {
                        [cell.btn setTitle:[NSString stringWithFormat:@"  彩妆类型：%@",[[mts objectAtIndex:i] valueForKey:@"name"]] forState:0];
                    }
                }
            }else if ([cell.btn.titleLabel.text rangeOfString:@"鞋跟高度"].location != NSNotFound && _shh != nil) {
                NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
                NSArray *shh = [baseData valueForKey:@"shh"];
                for (int i = 0; i < shh.count; i++) {
                    if ([[shh objectAtIndex:i] valueForKey:@"id"] == _shh && [_shh intValue] != -1) {
                        [cell.btn setTitle:[NSString stringWithFormat:@"  鞋跟高度：%@",[[shh objectAtIndex:i] valueForKey:@"name"]] forState:0];
                    }
                }
            }
        }
    }
    if (_xb != nil) {
        TableCell *cell = [cells objectAtIndex:0];
        NSArray *xbs = [baseData valueForKey:@"xbs"];
        for (int i = 0; i < xbs.count; i++) {
            if ([[xbs objectAtIndex:i] valueForKey:@"id"] == _xb && [_xb intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  适用人群：%@",[[xbs objectAtIndex:i] valueForKey:@"name"]] forState:0];
            }
        }
    }
    if (_ss != nil) {
        TableCell *cell = [cells objectAtIndex:1];
        NSArray *ss = [baseData valueForKey:@"ss"];
        for (int i = 0; i < ss.count; i++) {
            if ([[ss objectAtIndex:i] valueForKey:@"id"] == _ss && [_ss intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  售后服务：%@",[[ss objectAtIndex:i] valueForKey:@"name"]] forState:0];
            }
        }
    }
    if (_pps != nil) {
        TableCell *cell = [cells objectAtIndex:2];
        NSArray *pps = [baseData valueForKey:@"pps"];
        for (int i = 0; i < pps.count; i++) {
            if ([[pps objectAtIndex:i] valueForKey:@"id"] == _pps && [_pps intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  产品品牌：%@(%@)",[[pps objectAtIndex:i] valueForKey:@"ename"],[[pps objectAtIndex:i] valueForKey:@"cname"]] forState:0];
            }
        }
    }

    
}

#pragma mark - tableViewController delegate -
- (void)seletedCell:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *contents = [[NSMutableArray alloc]init];
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    NSDictionary *baseData = [ob valueForKey:@"baseData"];
    if ([[_tableViewController.dataArr objectAtIndex:indexPath.row] isEqualToString:@"选择适用人群"]) {
        _contentsArr =[baseData valueForKey:@"xbs"];
    }else if ([[_tableViewController.dataArr objectAtIndex:indexPath.row] isEqualToString:@"选择售后服务"]){
        _contentsArr =[baseData valueForKey:@"ss"];
    }else if ([[_tableViewController.dataArr objectAtIndex:indexPath.row] isEqualToString:@"选择鞋子类型"]){
        _contentsArr =[baseData valueForKey:@"sts"];
    }else if ([[_tableViewController.dataArr objectAtIndex:indexPath.row] isEqualToString:@"选择产品材质"]){
        _contentsArr =[baseData valueForKey:@"ms"];
    }else if ([[_tableViewController.dataArr objectAtIndex:indexPath.row] isEqualToString:@"选择闭合方式"]){
        _contentsArr =[baseData valueForKey:@"bhs"];
    }else if ([[_tableViewController.dataArr objectAtIndex:indexPath.row] isEqualToString:@"选择手表机芯"]){
        _contentsArr =[baseData valueForKey:@"cs"];
    }else if ([[_tableViewController.dataArr objectAtIndex:indexPath.row] isEqualToString:@"选择手表表带"]){
        _contentsArr =[baseData valueForKey:@"ws"];
    }else if ([[_tableViewController.dataArr objectAtIndex:indexPath.row] isEqualToString:@"选择包包类型"]){
        _contentsArr =[baseData valueForKey:@"bts"];
    }else if ([[_tableViewController.dataArr objectAtIndex:indexPath.row] isEqualToString:@"选择产品品质"]){
        _contentsArr =[baseData valueForKey:@"bqs"];
    }else if ([[_tableViewController.dataArr objectAtIndex:indexPath.row] isEqualToString:@"选择服装类型"]){
        _contentsArr =[baseData valueForKey:@"cts"];
    }else if ([[_tableViewController.dataArr objectAtIndex:indexPath.row] isEqualToString:@"选择彩妆类型"]){
        _contentsArr =[baseData valueForKey:@"mts"];
    }else if ([[_tableViewController.dataArr objectAtIndex:indexPath.row] isEqualToString:@"选择鞋跟高度"]){
        _contentsArr =[baseData valueForKey:@"shhs"];
    }else if ([[_tableViewController.dataArr objectAtIndex:indexPath.row] isEqualToString:@"选择产品品牌"]){
        _contentsArr =[baseData valueForKey:@"pps"];
        for (int i = 0; i < _contentsArr.count; i++) {
            NSString *str = [NSString stringWithFormat:@"%@(%@)",[[_contentsArr objectAtIndex:i] valueForKey:@"ename"],[[_contentsArr objectAtIndex:i] valueForKey:@"cname"]];
            [contents addObject:str];
        }
//        NSLog(@"%d",contents.count);
        ApplicablePeopleViewController *applicablePeopleViewController = [[ApplicablePeopleViewController alloc]initWithNibName:@"ApplicablePeopleViewController" bundle:nil data:contents indexPath:indexPath title:[_tableViewController.dataArr objectAtIndex:indexPath.row]];
        [applicablePeopleViewController setHidesBottomBarWhenPushed:YES];
        applicablePeopleViewController.delegate = self;
        [self.navigationController pushViewController:applicablePeopleViewController animated:YES];
        applicablePeopleViewController = nil;
        return;
    }
    for (int i = 0; i < _contentsArr.count; i++) {
//        NSLog(@"dic = %@",[_contentsArr objectAtIndex:i]);
//        NSLog(@"name = %@",[[_contentsArr objectAtIndex:i] valueForKey:@"name"]);
        NSString *str = [[_contentsArr objectAtIndex:i] valueForKey:@"name"];
        [contents addObject:str];
    }
    
    ApplicablePeopleViewController *applicablePeopleViewController = [[ApplicablePeopleViewController alloc]initWithNibName:@"ApplicablePeopleViewController" bundle:nil data:contents indexPath:indexPath title:[_tableViewController.dataArr objectAtIndex:indexPath.row]];
    [applicablePeopleViewController setHidesBottomBarWhenPushed:YES];
    applicablePeopleViewController.delegate = self;
    [self.navigationController pushViewController:applicablePeopleViewController animated:YES];
    applicablePeopleViewController = nil;
}

- (void)queryGoods:(UIButton *)sender
{
    sender.enabled = NO;
    if (_indexPath == nil || _indexPath.row == 0) {
        _lx = @"-1";
    }else{
        _lx = [[_categorys objectAtIndex:_indexPath.row - 1] valueForKey:@"id"];
    }
    if (_xb == nil) {
        _xb = @"-1";
    }
    if (_pps == nil) {
        _pps = @"-1";
    }
    NSString *text = @"";
    if (_ss != nil && [_ss intValue] != -1) {
        text = [NSString stringWithFormat:@"6/_%@",_ss];
    }
    if (_tableViewController.dataArr.count > 3) {
        for (int i = 0; i < _tableViewController.dataArr.count; i++) {
            NSString *title = [_tableViewController.dataArr objectAtIndex:i];
            if ([title rangeOfString:@"鞋子类型"].location != NSNotFound){
                if (_sts != nil && [_sts intValue] != -1) {
                    if ([text isEqualToString:@""]) {
                        text = [NSString stringWithFormat:@"9/_%@",_sts];
                    }else{
                        text = [NSString stringWithFormat:@"%@|9/_%@",text,_sts];
                    }
                }
            }else if ([title rangeOfString:@"手表机芯"].location != NSNotFound){
                if (_cs != nil && [_cs intValue] != -1) {
                    if ([text isEqualToString:@""]) {
                        text = [NSString stringWithFormat:@"3/_%@",_cs];
                    }else{
                        text = [NSString stringWithFormat:@"%@|3/_%@",text,_cs];
                    }
                }
            }else if ([title rangeOfString:@"手表表带"].location != NSNotFound){
                if (_ws != nil && [_ws intValue] != -1) {
                    if ([text isEqualToString:@""]) {
                        text = [NSString stringWithFormat:@"10/_%@",_ws];
                    }else{
                        text = [NSString stringWithFormat:@"%@|10/_%@",text,_ws];
                    }
                }
            }else if ([title rangeOfString:@"包包类型"].location != NSNotFound){
                if (_bts != nil && [_bts intValue] != -1) {
                    if ([text isEqualToString:@""]) {
                        text = [NSString stringWithFormat:@"2/_%@",_bts];
                    }else{
                        text = [NSString stringWithFormat:@"%@|2/_%@",text,_bts];
                    }
                }
            }else if ([title rangeOfString:@"产品品质"].location != NSNotFound){
                if (_bqs != nil && [_bqs intValue] != -1) {
                    if ([text isEqualToString:@""]) {
                        text = [NSString stringWithFormat:@"1/_%@",_bqs];
                    }else{
                        text = [NSString stringWithFormat:@"%@|1/_%@",text,_bqs];
                    }
                }
            }else if ([title rangeOfString:@"服装类型"].location != NSNotFound){
                if (_cts != nil && [_cts intValue] != -1) {
                    if ([text isEqualToString:@""]) {
                        text = [NSString stringWithFormat:@"4/_%@",_cts];
                    }else{
                        text = [NSString stringWithFormat:@"%@|4/_%@",text,_cts];
                    }
                }
            }else if ([title rangeOfString:@"彩妆类型"].location != NSNotFound){
                if (_mts != nil && [_mts intValue] != -1) {
                    if ([text isEqualToString:@""]) {
                        text = [NSString stringWithFormat:@"12/_%@",_mts];
                    }else{
                        text = [NSString stringWithFormat:@"%@|12/_%@",text,_mts];
                    }
                }
            }else if ([title rangeOfString:@"鞋跟高度"].location != NSNotFound){
                if (_shh != nil && [_shh intValue] != -1) {
                    if ([text isEqualToString:@""]) {
                        text = [NSString stringWithFormat:@"7/_%@",_shh];
                    }else{
                        text = [NSString stringWithFormat:@"%@|7/_%@",text,_shh];
                    }
                }
            }
        }
    }

    NSLog(@"text = %@,lx= %@,xb = %@",text,_lx,_xb);
    UserEntity *ue = [UserEntity shareCurrentUe];

    ObjectVo *ob= [ObjectVo shareCurrentObjectVo];
    NSDictionary *params;
//    NSLog(@"%@",self.searchText.text);
    if (self.searchText.text == nil || [[self.searchText.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        params = @{@"interface": GET_CHANPIN,@"page": @"0",@"lx":_lx,@"xb": _xb,@"pp": _pps,@"miaoshu": @"",@"text": text,@"uname": ue.userName,@"uuid": ue.uuid,@"dataVersions":ob.dataVersions};
    }else{
        if ([self.searchText.text stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length >0) {
            params = @{@"interface": GET_CHANPIN,@"page": @"0",@"lx":_lx,@"xb": _xb,@"pp": _pps,@"miaoshu": [self.searchText.text stringByReplacingOccurrencesOfString:@" " withString:@""],@"text": text,@"uname": ue.userName,@"uuid": ue.uuid,@"dataVersions":ob.dataVersions};
        }else{
            params = @{@"interface": GET_CHANPIN_BY_ID,@"page": @"0",@"cpid":self.searchText.text,@"uname": ue.userName,@"uuid": ue.uuid,@"dataVersions":ob.dataVersions};
        }
    }
    [self.view showWithType:0 Title:@"正在获取商品列表..."];
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:params completionBlock:^(id object) {
        ResultsModel *result = [[ResultsModel alloc]init];
        NSArray *properties = [self properties_aps:[ResultsModel class] objc:result];
        for (NSString *resultKey in [object allKeys]) {
            for (NSString *proKey in properties) {
                if ([resultKey isEqualToString:proKey]) {
                    [result setValue:[object valueForKey:resultKey] forKey:resultKey];
                }
            }
        }
        if (result.msg) {
            [self.view endSynRequestSignal];
            [self.view LabelTitle:[object valueForKey:@"msg"]];
            return;
        }
        if (result.baseData) {
            ob.baseData = [[object valueForKey:@"baseData"] JSONValue];
            [ObjectVo clearCurrentObjectVo];
            // 将个人信息全部持久化到documents中，可通过objectVo的单例获取登录了的用户的个人信息
            NSMutableData *mData = [[NSMutableData alloc]init];
            NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
            [archiver encodeObject:ob forKey:@"objectVoInfo"];
            [archiver finishEncoding];
            NSString *objectVoInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/objectVoInfo.txt"];
            [mData writeToFile:objectVoInfoPath atomically:YES];
            mData = nil;
            
        }
        NSString *ovo = [object valueForKey:@"ovo"];
        NSDictionary *objectVoDic = [ovo JSONValue];
        NSMutableArray *cps = [[NSMutableArray alloc]init];
        NSString *code = [objectVoDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            NSArray *arr = [objectVoDic valueForKey:@"cps"];
            for (int i = 0; i < arr.count; i++) {
                NSDictionary *dic = [arr objectAtIndex:i];
                ChanPin *chanpin = [[ChanPin alloc]init];
                NSArray *cpArr = [self properties_aps:[ChanPin class] objc:chanpin];
                for (NSString *key in dic) {
                    for (NSString *k in cpArr) {
                        if ([key isEqualToString:k]) {
                            [chanpin setValue:[dic valueForKey:key] forKey:key];
                        }
                        if ([key isEqualToString:@"id"]) {
                            [chanpin setValue:[dic valueForKey:key] forKey:@"Id"];
                            break;
                        }
                    }
                }
                [cps addObject:chanpin];
                chanpin = nil;
            }
        }
        if (cps.count > 0) {
            
            ProductViewController *productViewController = [[ProductViewController alloc]initWithNibName:@"ProductViewController" bundle:nil cpsArr:cps];
            productViewController.lx = _lx;
            productViewController.xb = _xb;
            productViewController.pp = _pps;
            productViewController.text = text;
            [productViewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:productViewController animated:YES];
            productViewController = nil;
        }else{
            [self.view LabelTitle:@"没有该类型的商品！"];
        }
        sender.enabled = YES;
        [self.view endSynRequestSignal];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [self.view endSynRequestSignal];
        sender.enabled = YES;
    }];
    
}

- (void)upLoadImage:(id)sener suser:(NSDictionary *)suser
{
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    UploadViewController *uploadViewController = [[UploadViewController alloc]initWithNibName:@"UploadViewController" bundle:nil address:[ob.suser valueForKey:@"dangkou"]];
    [self.navigationController pushViewController:uploadViewController animated:YES];
    uploadViewController = nil;
}

- (void)removeSelectedAttributes:(id)sender
{
    for (int i = 0; i < _tableViewController.dataArr.count; i++) {
        if ([[_tableViewController.dataArr objectAtIndex:i] rangeOfString:@"适用人群"].location != NSNotFound) {
            _xb = nil;
        }else if ([[_tableViewController.dataArr objectAtIndex:i] rangeOfString:@"售后服务"].location != NSNotFound){
            _ss = nil;
        }else if ([[_tableViewController.dataArr objectAtIndex:i] rangeOfString:@"鞋子类型"].location != NSNotFound){
            _sts = nil;
        }else if ([[_tableViewController.dataArr objectAtIndex:i] rangeOfString:@"手表机芯"].location != NSNotFound){
            _cs = nil;
        }else if ([[_tableViewController.dataArr objectAtIndex:i] rangeOfString:@"手表表带"].location != NSNotFound){
            _ws = nil;
        }else if ([[_tableViewController.dataArr objectAtIndex:i] rangeOfString:@"包包类型"].location != NSNotFound){
            _bts = nil;
        }else if ([[_tableViewController.dataArr objectAtIndex:i] rangeOfString:@"产品品质"].location != NSNotFound){
            _bqs = nil;
        }else if ([[_tableViewController.dataArr objectAtIndex:i] rangeOfString:@"服装类型"].location != NSNotFound){
            _cts = nil;
        }else if ([[_tableViewController.dataArr objectAtIndex:i] rangeOfString:@"彩妆类型"].location != NSNotFound){
            _mts = nil;
        }else if ([[_tableViewController.dataArr objectAtIndex:i] rangeOfString:@"产品品牌"].location != NSNotFound){
            _pps = nil;
        }else if ([[_tableViewController.dataArr objectAtIndex:i] rangeOfString:@"鞋跟高度"].location != NSNotFound){
            _shh = nil;
        }
    }
    [_tableViewController.table reloadData];
}

#pragma mark - ApplicablePeopleCellDelegate -
- (void)changeTitle:(NSString *)aStr indexPath:(NSIndexPath *)indexPath apIndexPath:(NSIndexPath *)apIndexPath
{
    NSMutableArray *_ids = [[NSMutableArray alloc]init];
    for (int i = 0; i < _contentsArr.count; i++) {
        NSString *str = [[_contentsArr objectAtIndex:i] valueForKey:@"id"];
        [_ids addObject:str];
    }
    if (indexPath.row == 0) {
        if (_indexPath.row > 0) {
            NSString *lxStr = [[_categorys objectAtIndex:_indexPath.row - 1] valueForKey:@"id"];
            if ([lxStr intValue] == 1) {
                if ([lxStr intValue] == 1 && [aStr rangeOfString:@"女士"].location != NSNotFound) {
                    _tableViewController.dataArr = _gShoes;
                    [_tableViewController.table reloadData];
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(tableViewControllerReloadData) userInfo:nil repeats:NO];
                }else{
                    _tableViewController.dataArr = _shoes;
                    [_tableViewController.table reloadData];
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(tableViewControllerReloadData) userInfo:nil repeats:NO];
                }
            }
        }
    }
    
    TableCell *cell = (TableCell *)[_tableViewController.table cellForRowAtIndexPath:indexPath];
    if ([[_ids objectAtIndex:apIndexPath.row] intValue] == -1) {
        NSString *title;
        if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"适用人群"].location != NSNotFound) {
            title = @"  选择适用人群";
        }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"售后服务"].location != NSNotFound){
            title = @"  选择售后服务";
        }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"鞋子类型"].location != NSNotFound){
            title = @"  选择鞋子类型";
        }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"材质"].location != NSNotFound){
            title = @"  选择产品材质";
        }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"闭合方式"].location != NSNotFound){
            title = @"  选择闭合方式";
        }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"机芯"].location != NSNotFound){
            title = @"  选择手表机芯";
        }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"表带"].location != NSNotFound){
            title = @"  选择手表表带";
        }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"包包类型"].location != NSNotFound){
            title = @"  选择包包类型";
        }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"品质"].location != NSNotFound){
            title = @"  选择产品品质";
        }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"服装类型"].location != NSNotFound){
            title = @"  选择服装类型";
        }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"彩妆类型"].location != NSNotFound){
            title = @"  选择彩妆类型";
        }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"鞋跟高度"].location != NSNotFound){
            title = @"  选择鞋跟高度";
        }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"产品品牌"].location != NSNotFound){
            title = @"  选择产品品牌";
        }
        
        [cell.btn setTitle:title forState:0];
    }else{
        [cell.btn setTitle:aStr forState:0];
    }
    
    if ([cell.btn.titleLabel.text rangeOfString:@"适用人群"].location != NSNotFound) {
        _xb = [_ids objectAtIndex:apIndexPath.row];
    }else if ([cell.btn.titleLabel.text rangeOfString:@"售后服务"].location != NSNotFound){
        _ss = [_ids objectAtIndex:apIndexPath.row];
    }else if ([cell.btn.titleLabel.text rangeOfString:@"鞋子类型"].location != NSNotFound){
        _sts = [_ids objectAtIndex:apIndexPath.row];
//    }else if ([cell.btn.titleLabel.text rangeOfString:@"产品材质"].location != NSNotFound){
//        _ms = [_ids objectAtIndex:apIndexPath.row];
//    }else if ([cell.btn.titleLabel.text rangeOfString:@"闭合方式"].location != NSNotFound){
//        _bhs = [_ids objectAtIndex:apIndexPath.row];
    }else if ([cell.btn.titleLabel.text rangeOfString:@"手表机芯"].location != NSNotFound){
        _cs = [_ids objectAtIndex:apIndexPath.row];
    }else if ([cell.btn.titleLabel.text rangeOfString:@"手表表带"].location != NSNotFound){
        _ws = [_ids objectAtIndex:apIndexPath.row];
    }else if ([cell.btn.titleLabel.text rangeOfString:@"包包类型"].location != NSNotFound){
        _bts = [_ids objectAtIndex:apIndexPath.row];
    }else if ([cell.btn.titleLabel.text rangeOfString:@"产品品质"].location != NSNotFound){
        _bqs = [_ids objectAtIndex:apIndexPath.row];
    }else if ([cell.btn.titleLabel.text rangeOfString:@"服装类型"].location != NSNotFound){
        _cts = [_ids objectAtIndex:apIndexPath.row];
    }else if ([cell.btn.titleLabel.text rangeOfString:@"彩妆类型"].location != NSNotFound){
        _mts = [_ids objectAtIndex:apIndexPath.row];
    }else if ([cell.btn.titleLabel.text rangeOfString:@"鞋跟高度"].location != NSNotFound){
        _shh = [_ids objectAtIndex:apIndexPath.row];
    }else if ([cell.btn.titleLabel.text rangeOfString:@"产品品牌"].location != NSNotFound){
        _pps = [_ids objectAtIndex:apIndexPath.row];
    }
    
}

- (void)clear:(NSString *)aStr indexPath:(NSIndexPath *)indexPath
{
    TableCell *cell = (TableCell *)[_tableViewController.table cellForRowAtIndexPath:indexPath];
    [cell.btn setTitle:aStr forState:0];
    if ([cell.btn.titleLabel.text rangeOfString:@"适用人群"].location != NSNotFound) {
        _xb = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"售后服务"].location != NSNotFound){
        _ss = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"鞋子类型"].location != NSNotFound){
        _sts = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"手表机芯"].location != NSNotFound){
        _cs = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"手表表带"].location != NSNotFound){
        _ws = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"包包类型"].location != NSNotFound){
        _bts = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"产品品质"].location != NSNotFound){
        _bqs = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"服装类型"].location != NSNotFound){
        _cts = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"彩妆类型"].location != NSNotFound){
        _mts = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"鞋跟高度"].location != NSNotFound){
        _shh = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"产品品牌"].location != NSNotFound){
        _pps = nil;
    }

}

#pragma mark - textField -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tabImageName
{
	return @"find_on.png";
}

- (NSString *)tabTitle
{
	return nil;
}

//遍历类属性
- (NSMutableArray *)properties_aps:(Class)aClass objc:(id)aObjc
{
    //NSMutableDictionary *props = [NSMutableDictionary dictionary];
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(aClass, &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
        //        id propertyValue = [aObjc valueForKey:(NSString *)propertyName];
        //        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([UIScreen mainScreen].bounds.size.width == 320 && [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        if ([UIScreen mainScreen].bounds.size.height > 500) {
            self.table.frame = CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y, self.table.frame.size.width, height);
        }else{
            self.table.frame = CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y, self.table.frame.size.width, 346);
        }
    }
    [self.table reloadData];
}

- (void)dealloc
{
    _categorys = nil;
    _lastIndexPath = nil;
    _tableViewController = nil;
    _indexPath = nil;
    _lx = nil;
    _xb = nil;
    _ss = nil;
    _sts = nil;
    _cs = nil;
    _ws = nil;
    _bts = nil;
    _bqs = nil;
    _cts = nil;
    _mts = nil;
    _shh = nil;
    _pps = nil;
    _contentsArr = nil;
    _all = nil;
    _other = nil;
    _shoes = nil;
    _watch = nil;
    _bag = nil;
    _wallet = nil;
    _silk = nil;
    _belt = nil;
    _clothes = nil;
    _hat = nil;
    _glasses = nil;
    _jewelry = nil;
    _cosmetics = nil;
    _gShoes = nil;
    [self setView:nil];
}

@end
