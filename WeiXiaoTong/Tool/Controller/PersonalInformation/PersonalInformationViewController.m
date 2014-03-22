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
    self.userName.text = ue.userName;
//    self.level.text = [NSString stringWithFormat:@"用户等级：%d",ue.level];
    self.mersNum.text = [NSString stringWithFormat:@"商家数量上限："];
    
}

- (IBAction)closeAction:(id)sender {
}

- (IBAction)openAction:(id)sender {
}

- (IBAction)clearCache:(id)sender {
}

- (IBAction)uploadAction:(id)sender
{
    UploadViewController *uploadViewController = [[UploadViewController alloc]initWithNibName:@"UploadViewController" bundle:nil];
    [uploadViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:uploadViewController animated:YES];
    uploadViewController = nil;
}

- (IBAction)returnLogin:(id)sender
{
    [ControlCenter makeKeyAndVisibleAgain];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tabImageName
{
	return @"市场资讯-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}


@end
