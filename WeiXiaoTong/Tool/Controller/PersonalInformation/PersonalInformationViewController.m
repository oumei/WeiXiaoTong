//
//  PersonalInformationViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "UINavigationBar+Custom.h"
#import "ControlCenter.h"
#import "UserEntity.h"

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
    
    [self.navigationController.navigationBar setBackgroundImage:[self image]];
    
    UserEntity *ue = [UserEntity shareCurrentUe];
    self.userName.text = ue.userName;
    self.level.text = [NSString stringWithFormat:@"用户等级：%d",ue.level];
    self.mersNum.text = [NSString stringWithFormat:@"商家数量上限："];
    
}

- (UIImage *)image
{
    CGSize imageSize = CGSizeMake(320, 44);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[UIColor blackColor] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}

- (IBAction)closeAction:(id)sender {
}

- (IBAction)openAction:(id)sender {
}

- (IBAction)clearCache:(id)sender {
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
