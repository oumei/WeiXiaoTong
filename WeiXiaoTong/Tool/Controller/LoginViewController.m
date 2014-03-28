//
//  LoginViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "LoginViewController.h"
#import "Config.h"
#import "RegisterViewController.h"
#import "ControlCenter.h"
#import "HttpService.h"
#import "JSON.h"
#import "ObjectVo.h"
#import "UserEntity.h"
#import "BaseData.h"
#import "Reachability.h"
#include<objc/runtime.h>
#import "ResultsModel.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize registerText = _registerText;

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
    self.loginWebView.scrollView.bounces = NO;
    //[self.navigationController.navigationBar setBackgroundImage:[self image]];
    self.psd.secureTextEntry = YES;
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 150, 30)];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    icon.image = [UIImage imageNamed:@"up_icon.png"];
    [leftView addSubview:icon];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(35, 5, 100, 20)];
    label.text = @"用户登录";
    label.backgroundColor = [UIColor clearColor];
    [leftView addSubview:label];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    leftView = nil;
    icon = nil;
    label = nil;
    leftBarButton = nil;
    
    UserEntity *user = [UserEntity shareCurrentUe];
    if (user.uuid == nil) {
        [user setValue:[self uuid] forKey:@"uuid"];
        NSMutableData *mData = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
        [archiver encodeObject:user forKey:@"ueInfo"];
        [archiver finishEncoding];
        NSString *userInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ueInfo.txt"];
        [mData writeToFile:userInfoPath atomically:YES];
    }
   
//    [UserModel clearCurrrentUser];
//    UserModel *userModel = [UserModel shareCurrentUser];
//    
//    [userModel setValue:@"oumeil" forKey:@"uname"];
//    [userModel setValue:@"123456" forKey:@"psd"];
//    [userModel setValue:@"18826483794" forKey:@"tell"];
//    [userModel setValue:@"02508B0C-9059-498F-A8C0-BD9B5B8C7AF2" forKey:@"uuid"];
//    
//    // 将个人信息全部持久化到documents中，可通过config的单例获取登录了的用户的个人信息
//    NSMutableData *mData = [[NSMutableData alloc]init];
//    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
//    [archiver encodeObject:userModel forKey:@"userModelInfo"];
//    [archiver finishEncoding];
//    NSString *userModelInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userModelInfo.txt"];
//    [mData writeToFile:userModelInfoPath atomically:YES];

    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": CONFIG} completionBlock:^(id object) {
        [Config clearCurrentConfig];
        Config *config = [Config shareCurrentConfig];
        if (object != nil)
        {
            self.registerText = [object valueForKey:@"seachText"];
            [self.loginWebView loadHTMLString:[object valueForKey:@"loginText"] baseURL:[NSBundle mainBundle].bundleURL];
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
            for (NSString *key in [object allKeys]) {
                NSArray *arr = [self properties_aps:[Config class] objc:config];
                for (NSString *k in arr) {
                    if ([key isEqualToString:k]) {
                        if ([[object valueForKey:key] isKindOfClass:[NSString class]]) {
                            [config setValue:[object valueForKey:key] forKey:key];
                        }else{
                            [config setValue:[NSString stringWithFormat:@"%d",[[object valueForKey:key] intValue]] forKey:key];
                        }
                    }
                }
                
            }
        }
        // 将个人信息全部持久化到documents中，可通过config的单例获取登录了的用户的个人信息
        NSMutableData *mData = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
        [archiver encodeObject:config forKey:@"configInfo"];
        [archiver finishEncoding];
        NSString *meInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/configInfo.txt"];
        [mData writeToFile:meInfoPath atomically:YES];
        mData = nil;
    } failureBlock:^(NSError *error, NSString *responseString) {
        //
    }];
}

//- (UIImage *)image
//{
//    CGSize imageSize = CGSizeMake(320, 44);
//    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
//    [[UIColor blackColor] set];
//    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
//    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return pressedColorImg;
//}

- (IBAction)registerAction:(id)sender
{
    UserEntity *user = [UserEntity shareCurrentUe];
    if (user.userName == nil) {
        RegisterViewController *registerViewController = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil registerText:self.registerText];
        [self.navigationController pushViewController:registerViewController animated:YES];
    }else{
        [self.view LabelTitle:@"该手机已注册！"];
    }
    
}

- (IBAction)loginAction:(id)sender
{
    UserEntity *user = [UserEntity shareCurrentUe];
    //回收键盘
    [self.uname endEditing:YES];
    [self.psd endEditing:YES];
    
    if (![[self.uname.text stringByReplacingOccurrencesOfString:@" " withString:@""]isEqualToString:@""] && ![[self.psd.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] && self.uname.text.length >= 6 && self.psd.text.length >= 6){
        
        //*****************************网络判断***************************************//
        if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable && [Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable)
        {
            [self.view LabelTitle:@"无网络连接！"];
            //NSLog(@"无网络连接");
        }else{
            //**************************有网络的操作**************************************//
            [self.view showWithType:0 Title:@"正在登录,请稍候..."];
            //UserModel *user = [UserModel shareCurrentUser];
            //oumeil,123456,123456,18826483794
            //204220CE-384B-4D31-8834-FF39365A8E77
            //02508B0C-9059-498F-A8C0-BD9B5B8C7AF2
            
            [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": USER_LOGIN,@"psd": self.psd.text,@"uname": self.uname.text,@"uuid": user.uuid} completionBlock:^(id object) {
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
                NSString *ovo = [object valueForKey:@"ovo"];
                NSDictionary *objectVoDic = [ovo JSONValue];
                NSString *code = [objectVoDic valueForKey:@"code"];
                if ([code intValue] == 0) {
                    [ObjectVo clearCurrentObjectVo];
                    ObjectVo *objectVo = [ObjectVo shareCurrentObjectVo];
                    
                    for (NSString *key in [objectVoDic allKeys]) {
                        NSArray *obArr = [self properties_aps:[ObjectVo class] objc:objectVo];
                        for (NSString *obKey in obArr) {
                            if ([key isEqualToString:obKey]) {
                                
                                if ([key isEqualToString:@"baseData"] || [key isEqualToString:@"ue"]) {
                                    
                                    if ([key isEqualToString:@"ue"]){
                                        NSDictionary *ueDic = [objectVoDic valueForKey:key];
                                        [UserEntity clearCurrrentUe];
                                        UserEntity *ue = [UserEntity shareCurrentUe];
                                        for (NSString *uekey in [ueDic allKeys]) {
                                            NSArray *uArr = [self properties_aps:[UserEntity class] objc:ue];
                                            for (NSString *u in uArr) {
                                                if ([uekey isEqualToString:u]) {
                                                    [ue setValue:[ueDic valueForKey:uekey] forKey:uekey];
                                                }
                                                if ([uekey isEqualToString:@"id"]) {
                                                    [ue setValue:[ueDic valueForKey:uekey] forKey:uekey];
                                                    break;
                                                }
                                            }
                                            
                                        }

                                        // 将个人信息全部持久化到documents中，可通过ue的单例获取登录了的用户的个人信息
                                        NSMutableData *mData = [[NSMutableData alloc]init];
                                        NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
                                        [archiver encodeObject:ue forKey:@"ueInfo"];
                                        [archiver finishEncoding];
                                        NSString *ueInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ueInfo.txt"];
                                        [mData writeToFile:ueInfoPath atomically:YES];
                                        mData = nil;
                                        ue = nil;
                                    }
                                    
                                    [objectVo setValue:[objectVoDic valueForKey:key] forKey:key];
                                }else{
                                    [objectVo setValue:[objectVoDic valueForKey:key] forKey:key];
                                }
                            }
                        }
                    }
                    // 将个人信息全部持久化到documents中，可通过objectVo的单例获取登录了的用户的个人信息
                    NSMutableData *mData = [[NSMutableData alloc]init];
                    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
                    [archiver encodeObject:objectVo forKey:@"objectVoInfo"];
                    [archiver finishEncoding];
                    NSString *objectVoInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/objectVoInfo.txt"];
                    [mData writeToFile:objectVoInfoPath atomically:YES];
                    mData = nil;
                    //*****************页面跳转*************************************//
                    [self.view endSynRequestSignal];
                    [ControlCenter makeKeyAndVisible];
                }else{
                    [self.view LabelTitle:[objectVoDic valueForKey:@"msg"]];
                    [self.view endSynRequestSignal];
                }
            } failureBlock:^(NSError *error, NSString *responseString) {
                [self.view endSynRequestSignal];
            }];
        }
    }
    else{
        
        [self.view LabelTitle:@"注册信息不完整，请继续填写！"];
    }
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    UserEntity *user = [UserEntity shareCurrentUe];
    self.uname.text = user.userName;
    self.psd.text = user.psd;
    
    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable && [Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable)
    {
        [self.view LabelTitle:@"无网络连接！"];
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

- (NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (__bridge_transfer NSString *)CFStringCreateCopy( NULL, uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
