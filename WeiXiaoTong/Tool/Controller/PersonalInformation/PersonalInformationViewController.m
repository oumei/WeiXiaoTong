//
//  PersonalInformationViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "ControlCenter.h"
#import "UserEntity.h"
#import "UploadViewController.h"


@interface PersonalInformationViewController ()

@end

@implementation PersonalInformationViewController

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
    UserEntity *ue = [UserEntity shareCurrentUe];
    NSArray *array = @[@" 关闭图片水印",@" 开启图片水印",@" 清理缓存垃圾",@" 返回登录"];
//    if (ue.qx == 2) {
//        array = @[@" 关闭图片水印",@" 开启图片水印",@" 清理缓存垃圾",@" 上传产品到私有资源",@" 返回登录"];
//    }else{
//        array = @[@" 关闭图片水印",@" 开启图片水印",@" 清理缓存垃圾",@" 返回登录"];
//    }
    self.data = array;
    [self.table reloadData];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    icon.image = [UIImage imageNamed:@"up_icon.png"];
    [leftView addSubview:icon];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    leftView = nil;
    icon = nil;
    leftBarButton = nil;
    
    self.title = @"个人信息";
    
    
    self.userName.text = ue.userName;
    if (ue.daoqi) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%d",ue.daoqi] floatValue]/1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        self.validityTime.text = [formatter stringFromDate:date];
    }else{
        self.validityTime.text = @"永久";
    }
    self.level.text = [NSString stringWithFormat:@"好友上限：%d",ue.friendCout];
    self.mersNum.text = [NSString stringWithFormat:@"产品上传上限：%d",ue.chanPinCout];
    
}

- (void)closeAction:(id)sender
{
    NSString *sy = @"sy=0";
    NSError *error = nil;
    [sy writeToFile:[self syPath] atomically:YES encoding:4 error:&error];
    [self.view LabelTitle:@"关闭成功！"];
}

- (void)openAction:(id)sender
{
    NSString *sy = @"sy=1";
    NSError *error = nil;
    [sy writeToFile:[self syPath] atomically:YES encoding:4 error:&error];
    [self.view LabelTitle:@"开启成功！"];
}

- (void)clearCache:(id)sender
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/com.hackemist.SDWebImageCache.default"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        NSError *error = nil;
        [fm removeItemAtPath:path error:&error];
        [self.view LabelTitle:@"清理完成"];
    } else {
        [self.view LabelTitle:@"没有缓存垃圾"];
    }

}

//- (void)uploadAction:(id)sender
//{
//    UploadViewController *uploadViewController = [[UploadViewController alloc]initWithNibName:@"UploadViewController" bundle:nil];
//    [uploadViewController setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:uploadViewController animated:YES];
//    uploadViewController = nil;
//}

#pragma mark - tableview delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"applicablePeopleCell";
    ApplicablePeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ApplicablePeopleCell" owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell.btn setTitle:[self.data objectAtIndex:indexPath.row] forState:0];
    if ([cell.btn.titleLabel.text  rangeOfString:@"返回登录"].location != NSNotFound) {
        [cell.btn setTitleColor:[UIColor blueColor] forState:0];
    }
    return cell;
}

- (void)seletedAction:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self closeAction:nil];
        return;
    }
    if (indexPath.row == 1) {
        [self openAction:nil];
        return;
    }
    if (indexPath.row == 2) {
        [self clearCache:nil];
        return;
    }
//    if ([sender.titleLabel.text rangeOfString:@"上传产品到私有资源"].location != NSNotFound) {
//        [self uploadAction:nil];
//        return;
//    }
    if ([sender.titleLabel.text rangeOfString:@"返回登录"].location != NSNotFound) {
        [ControlCenter makeKeyAndVisibleAgain];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)syPath
{
    NSString *homePath=NSHomeDirectory();
    homePath=[homePath stringByAppendingPathComponent:@"Documents/sy.txt"];
    return homePath;
}

- (NSString *)tabImageName
{
	return @"user_info_on.png";
}

- (NSString *)tabTitle
{
	return nil;
}


@end
