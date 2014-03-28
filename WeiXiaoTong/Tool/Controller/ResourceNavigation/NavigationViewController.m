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
#include <objc/runtime.h>
#import "ObjectVo.h"
#import "ResultsModel.h"

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
    [self.view showWithType:0 Title:@"正在获取商品列表..."];
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_CHANPIN_BY_DANGKOU,@"page":@"0",@"dangkou":link.name,@"uname": user.userName,@"uuid": user.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
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
            ob.baseData = [object valueForKey:@"baseData"];
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
        NSDictionary *ovoDic = [[object valueForKey:@"ovo"] JSONValue];

        if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
            NSMutableArray *cpsArr = [[NSMutableArray alloc]init];
            NSArray *arr = [[NSArray alloc]init];
            arr = [ovoDic valueForKey:@"cps"];
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
                [cpsArr addObject:chanpin];
                chanpin = nil;

            }
            
            if (cpsArr.count > 0) {
                ProductViewController *productViewController = [[ProductViewController alloc]initWithNibName:@"ProductViewController" bundle:nil cpsArr:cpsArr];
                productViewController.title = link.name;
                [productViewController setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:productViewController animated:YES];
                productViewController = nil;
            }else{
                [self.view LabelTitle:@"暂无数据！"];
            }
            cpsArr = nil;
            arr = nil;
        }
        [self.view endSynRequestSignal];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [self.view endSynRequestSignal];
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

- (void)dealloc
{
    self.table.delegate = nil;
    self.table.dataSource = nil;
    self.table = nil;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
