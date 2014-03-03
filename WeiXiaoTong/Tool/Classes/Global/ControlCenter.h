//
//  ControlCenter.h
//  ClairAudient
//
//  Created by Carl on 13-12-31.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "AKTabBarController.h"
#import "HomeViewController.h"
#import "GoodSearchViewController.h"
#import "ResourceNavigationViewController.h"
#import "PersonalInformationViewController.h"

@interface ControlCenter : NSObject

+ (AppDelegate *)appDelegate;
+ (UIWindow *)keyWindow;
+ (UIWindow *)newWindow;
+ (void)makeKeyAndVisible;
+ (void)makeKeyAndVisibleAgain;
+ (void)setNavigationTitleWhiteColor;
+ (void)showVC:(NSString *)vcName;
+ (UIViewController *)viewControllerWithName:(NSString *)vcName;
+ (UINavigationController *)navWithRootVC:(UIViewController *)vc;
@end
