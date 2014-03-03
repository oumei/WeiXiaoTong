//
//  HomeViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "UINavigationBar+Custom.h"
#import "HWSDK.h"
#import "LoginViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    [self initUI];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [self setView:nil];
}

#pragma mark - Private Methods
- (NSString *)tabImageName
{
	return @"首页-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}
//- (IBAction)pushaction:(id)sender
//{
//    LoginViewController *lo = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
//    [self presentViewController:lo animated:YES completion:^{
//        //
//    }];
//    lo = nil;
//}

- (void)initUI
{
    
    [self.navigationController.navigationBar setBackgroundImage:[self image]];
    
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

@end
