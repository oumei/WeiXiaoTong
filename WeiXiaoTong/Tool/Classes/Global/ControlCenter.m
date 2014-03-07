//
//  ControlCenter.m
//  ClairAudient
//
//  Created by Carl on 13-12-31.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "ControlCenter.h"
#import "LoginViewController.h"

@implementation ControlCenter

+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (UIWindow *)keyWindow
{
    return [[UIApplication sharedApplication] keyWindow];
}

+ (UIWindow *)newWindow
{
    UIWindow * window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    return window;
}

+ (void)makeKeyAndVisible
{
    AppDelegate * appDelegate = [[self class] appDelegate];
    appDelegate.window = [[self class] newWindow];
    AKTabBarController * tabBarController = [[AKTabBarController alloc] initWithTabBarHeight:49];
    [tabBarController setBackgroundImageName:@"tabbar_bg"];
    [tabBarController setSelectedBackgroundImageName:nil];
    tabBarController.iconGlossyIsHidden = NO;
    tabBarController.tabTitleIsHidden = YES;
    UINavigationController * nav_1 = [[self class] navWithRootVC:[[self class] viewControllerWithName:@"HomeViewController"]];
    UINavigationController * nav_2 = [[self class] navWithRootVC:[[self class] viewControllerWithName:@"GoodSearchViewController"]];
    UINavigationController * nav_3 = [[self class] navWithRootVC:[[self class] viewControllerWithName:@"ResourceNavigationViewController"]];
    UINavigationController * nav_4 = [[self class] navWithRootVC:[[self class] viewControllerWithName:@"PersonalInformationViewController"]];


    [tabBarController setIconColors:@[[UIColor colorWithRed:73.0/255.0 green:29.0/255.0f blue:18.0/255.0f alpha:1.0],[UIColor colorWithRed:73.0/255.0 green:29.0/255.0f blue:18.0/255.0f alpha:1.0],[UIColor colorWithRed:73.0/255.0 green:29.0/255.0f blue:18.0/255.0f alpha:1.0],[UIColor colorWithRed:73.0/255.0 green:29.0/255.0f blue:18.0/255.0f alpha:1.0],[UIColor colorWithRed:73.0/255.0 green:29.0/255.0f blue:18.0/255.0f alpha:1.0]]];
    [tabBarController setSelectedIconColors:@[[UIColor colorWithRed:206.0/255.0f green:48.0/255.0f blue:17.0/255.0f alpha:1.0f],[UIColor colorWithRed:206.0/255.0f green:48.0/255.0f blue:17.0/255.0f alpha:1.0f],[UIColor colorWithRed:206.0/255.0f green:48.0/255.0f blue:17.0/255.0f alpha:1.0f],[UIColor colorWithRed:206.0/255.0f green:48.0/255.0f blue:17.0/255.0f alpha:1.0f],[UIColor colorWithRed:206.0/255.0f green:48.0/255.0f blue:17.0/255.0f alpha:1.0f]]];
    [tabBarController setSelectedTabColors:@[[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor]]];
    [tabBarController setTabColors:@[[UIColor whiteColor],[UIColor whiteColor],[UIColor whiteColor]]];
    [tabBarController setTabStrokeColor:[UIColor clearColor]];
    [tabBarController setTabEdgeColor:[UIColor clearColor]];
    tabBarController.viewControllers = [NSMutableArray arrayWithObjects:nav_1,nav_2,nav_3,nav_4,nil];
    tabBarController.selectedViewController = nav_2;
    appDelegate.akTabBarController = tabBarController;
    [appDelegate.window setRootViewController:appDelegate.akTabBarController];
    
    
    [appDelegate.window makeKeyAndVisible];
    nav_1 = nil;
    nav_2 = nil;
    nav_3 = nil;
    nav_4 = nil;
    tabBarController = nil;

//    LoginView *loginView = (LoginView *)[[[NSBundle  mainBundle]  loadNibNamed:@"LoginView" owner:self options:nil]  lastObject];
//    [appDelegate.window addSubview:loginView];
    
}

+ (void)makeKeyAndVisibleAgain
{
    AppDelegate * appDelegate = [[self class] appDelegate];
    appDelegate.window = [[self class] newWindow];
    appDelegate.akTabBarController = nil;
    appDelegate.navigataController = nil;
    LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *navigataController = [[UINavigationController alloc]initWithRootViewController:login];
    appDelegate.navigataController = navigataController;
    
    [appDelegate.window setRootViewController:appDelegate.navigataController];
    [appDelegate.window makeKeyAndVisible];
    login = nil;
    navigataController = nil;
}

+ (void)setNavigationTitleWhiteColor
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor]}];
}



+ (void)showVC:(NSString *)vcName
{
    AppDelegate * appDelegate = [[self class] appDelegate];
    UIViewController * vc = [[self class] viewControllerWithName:vcName];
}


+ (UIViewController *)viewControllerWithName:(NSString *)vcName
{
    Class cls = NSClassFromString(vcName);
    UIViewController * vc = [[cls alloc] initWithNibName:vcName bundle:[NSBundle mainBundle]];
    return vc;
}

+ (UINavigationController *)navWithRootVC:(UIViewController *)vc
{
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    return nav;
}






@end
