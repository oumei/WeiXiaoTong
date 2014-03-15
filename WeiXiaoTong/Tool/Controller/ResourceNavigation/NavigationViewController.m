//
//  NavigationViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-26.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "NavigationViewController.h"
#import "Link.h"
#import "AKTabBarController.h"
#import "ProductViewController.h"
#import "HttpService.h"
#import "JSON.h"
#import "ChanPin.h"
#import "UserEntity.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil links:(NSArray *)linksArr
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.linksArr = linksArr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _changeData = [[NSArray alloc]initWithArray:self.linksArr];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - tableView delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.linksArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.detailTextLabel.numberOfLines = 2;
//    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    Link *link = [self.linksArr objectAtIndex:indexPath.row];
    cell.textLabel.text = link.name;
    cell.detailTextLabel.text = @"暂未提供任何厂商描述！";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_time invalidate];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserEntity *user = [UserEntity shareCurrentUe];
    Link *link = [self.linksArr objectAtIndex:indexPath.row];
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_CHANPIN_BY_DANGKOU,@"page":@"0",@"dangkou":link.name,@"uname": user.userName,@"uuid": user.uuid} completionBlock:^(id object) {
        
        NSDictionary *ovoDic = [[object valueForKey:@"ovo"] JSONValue];
        NSLog(@"ovoallkey=%@",[ovoDic allKeys]);
        if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
            NSMutableArray *cpsArr = [[NSMutableArray alloc]init];
            NSArray *arr = [[NSArray alloc]init];
            arr = [ovoDic valueForKey:@"cps"];
            for (int i = 0; i < arr.count; i++) {
                NSLog(@"chanpin=%@",[arr objectAtIndex:i]);
                ChanPin *chanPin = [[ChanPin alloc]init];
                chanPin.Id = [[[arr objectAtIndex:i] valueForKey:@"id"] intValue];
                chanPin.miaoshu = [[arr objectAtIndex:i] valueForKey:@"miaoshu"];
                chanPin.pinpai = [[[arr objectAtIndex:i] valueForKey:@"pinpai"] intValue];
                chanPin.leixing = [[[arr objectAtIndex:i] valueForKey:@"leixing"] intValue];
                chanPin.shijian = [[arr objectAtIndex:i] valueForKey:@"shijian"];
                chanPin.dangkou = [[arr objectAtIndex:i] valueForKey:@"dangkou"];
                chanPin.jiage = [[[arr objectAtIndex:i] valueForKey:@"jiage"] intValue];
                chanPin.pics = [[[arr objectAtIndex:i] valueForKey:@"pics"] intValue];
                chanPin.price = [[[arr objectAtIndex:i] valueForKey:@"price"] intValue];
                chanPin.upload = [[[arr objectAtIndex:i] valueForKey:@"upload"] intValue];
                chanPin.state = [[[arr objectAtIndex:i] valueForKey:@"state"] intValue];
                chanPin.categorys = [[arr objectAtIndex:i] valueForKey:@"categorys"];
                [cpsArr addObject:chanPin];
                chanPin = nil;
            }
//            NSLog(@"cps0=%@",[[ovoDic valueForKey:@"cps"] objectAtIndex:0]);
//            NSLog(@"cps= %@",[ovoDic valueForKey:@"cps"]);
            
            if (cpsArr.count > 0) {
                ProductViewController *productViewController = [[ProductViewController alloc]initWithNibName:@"ProductViewController" bundle:nil cpsArr:cpsArr];
                productViewController.title = link.name;
                [productViewController setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:productViewController animated:YES];
                productViewController = nil;
            }
            cpsArr = nil;
            arr = nil;
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        //
    }];
}

#pragma mark - textField -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _time = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changedata) userInfo:nil repeats:YES];
    return YES;
}

- (void)changedata{
    if ([[self.searchText.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        self.linksArr = _changeData;
    }else{
        NSMutableArray *data = [[NSMutableArray alloc]init];
        for (int i = 0; i < _changeData.count; i++) {
            Link *link = [_changeData objectAtIndex:i];
            if ([link.name rangeOfString:self.searchText.text].location != NSNotFound) {
                [data addObject:[_changeData objectAtIndex:i]];
            }
        }
        self.linksArr = data;
    }
    [self.table reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    AKTabBarController *tab = [[AKTabBarController alloc]initWithTabBarHeight:49];
//    //[tab.tabBarItem setSelectedTab:[tabBar.tabs objectAtIndex:0]];
//    [tab hideTabBar:AKShowHideFromLeft animated:YES];
    
}

- (void)dealloc
{
    self.table.delegate = nil;
    self.table.dataSource = nil;
    self.table = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
