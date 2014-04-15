//
//  ResourceNavigationViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "ResourceNavigationViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "NavigationViewController.h"
#import "ObjectVo.h"
#import "Link.h"
#import "AKTabBarController.h"
#import "HttpService.h"
#import "UserEntity.h"
#import "JSON.h"
#import "ResultsModel.h"
#include <objc/runtime.h>

@interface ResourceNavigationViewController ()

@end

@implementation ResourceNavigationViewController
@synthesize bazaars = _bazaars;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    height = self.table.frame.size.height;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    icon.image = [UIImage imageNamed:@"up_icon.png"];
    [leftView addSubview:icon];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    leftView = nil;
    icon = nil;
    leftBarButton = nil;
    
    self.title = @"资源导航";
    
    self.bazaars = [[[ObjectVo shareCurrentObjectVo] valueForKey:@"baseData"] valueForKey:@"bazaars"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (NSString *)tabImageName
{
	return @"source_on.png";
}

- (NSString *)tabTitle
{
	return nil;
}

#pragma mark - tableView delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bazaars.count + 1;
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
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"优质供货商";
        cell.detailTextLabel.text = @"此类供货商均为自行管理商品，一旦断货情况他们会及时更新产品状态。为广大用户提供更好的服务！";
        return cell;
    }
    cell.textLabel.text = [[self.bazaars objectAtIndex:indexPath.row - 1] valueForKey:@"name"];
    cell.detailTextLabel.text = [[self.bazaars objectAtIndex:indexPath.row - 1] valueForKey:@"address"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        UserEntity *user = [UserEntity shareCurrentUe];
        [self.view showWithType:0 Title:@"正在加载..."];
        ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
        [[HttpService sharedInstance]postRequestWithUrl:DEFAULT_URL params:@{@"interface": FIND_SOURCE_USERS,@"uuid":user.uuid,@"uname":user.userName,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
            NSLog(@"%@",object);
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
//            NSLog(@"_______________%@",objectVoDic);
            if ([[objectVoDic valueForKey:@"code"] intValue] == 0) {
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                NSArray *users = [objectVoDic valueForKey:@"users"];
                for (int i = 0; i < users.count; i++) {
                    Link *link = [[Link alloc]init];
                    link.Id = [[[users objectAtIndex:i] valueForKey:@"id"] intValue];
                    link.description = [[users objectAtIndex:i] valueForKey:@"description"];
                    link.name = [[users objectAtIndex:i]valueForKey:@"dangkou"];
                    [arr addObject:link];
                    link = nil;
                }
                if (arr.count == 0) {
                    [self.view endSynRequestSignal];
                    [self.view LabelTitle:@"暂无数据！"];
                    return;
                }
                [self.view endSynRequestSignal];
                NavigationViewController *navigationViewController = [[NavigationViewController alloc]initWithNibName:@"NavigationViewController" bundle:nil links:arr];
                [navigationViewController setHidesBottomBarWhenPushed:YES];
                
                [self.navigationController pushViewController:navigationViewController animated:YES];
                navigationViewController = nil;
            }else{
                [self.view endSynRequestSignal];
                [self.view LabelTitle:[objectVoDic valueForKey:@"msg"]];
            }

        } failureBlock:^(NSError *error, NSString *responseString) {
            [self.view endSynRequestSignal];
            if ([error.description rangeOfString:@"Code=-1001"].location != NSNotFound) {
                [self.view LabelTitle:@"请求超时"];
            }else if ([error.description rangeOfString:@"Code=-1004"].location != NSNotFound){
                [self.view LabelTitle:@"未连接服务器"];
            }else{
                [self.view LabelTitle:@"网络异常"];
            }
        }];
    }else{
        NSString *title = [[self.bazaars objectAtIndex:indexPath.row - 1] valueForKey:@"name"];
        NSArray *links = [[[ObjectVo shareCurrentObjectVo] valueForKey:@"baseData"] valueForKey:@"links"];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < links.count; i++) {
            if ([[[links objectAtIndex:i] valueForKey:@"name"] rangeOfString:title].location !=NSNotFound) {
                
                Link *link = [[Link alloc]init];
                link.Id = [[[links objectAtIndex:i] valueForKey:@"id"] intValue];
                link.link = [[links objectAtIndex:i] valueForKey:@"link"];
                link.name = [[links objectAtIndex:i] valueForKey:@"name"];
                [arr addObject:link];
                link = nil;
            }
        }
        if (arr.count == 0) {
            [self.view LabelTitle:@"暂无数据！"];
            return;
        }
        NavigationViewController *navigationViewController = [[NavigationViewController alloc]initWithNibName:@"NavigationViewController" bundle:nil links:arr];
        [navigationViewController setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:navigationViewController animated:YES];
        navigationViewController = nil;
    }
}

- (void)hideCollectionLable:(NSTimer *)aTimer
{
    UILabel *lable = [aTimer userInfo];
    lable.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([UIScreen mainScreen].bounds.size.width == 320 && [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        if ([UIScreen mainScreen].bounds.size.height > 500) {
            self.table.frame = CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y, self.table.frame.size.width, height);
        }else{
            self.table.frame = CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y, self.table.frame.size.width, 365);
        }
    }
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


- (void)dealloc
{
    self.table.delegate = nil;
    self.table.dataSource = nil;
    self.table = nil;
    _bazaars = nil;
    [self setView:nil];
}

@end
