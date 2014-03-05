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
#import "UINavigationBar+Custom.h"
#import "ControlCenter.h"
#import "UserModel.h"
#import "HttpService.h"
#import "JSON.h"
#import "ObjectVo.h"
#import "UserEntity.h"
#import "BaseData.h"
#import "Reachability.h"
#import "UIView+SynRequestSignal.h"


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
    [self initUI];
    self.psd.secureTextEntry = YES;
    
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
            self.loginTextView.text = [object valueForKey:@"loginText"];
            for (NSString *key in [object allKeys]) {
                if ([[object valueForKey:key] isKindOfClass:[NSString class]]) {
                    [config setValue:[object valueForKey:key] forKey:key];
                }else{
                    [config setValue:[NSString stringWithFormat:@"%d",[[object valueForKey:key] intValue]] forKey:key];
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

- (IBAction)registerAction:(id)sender
{
    UserModel *user = [UserModel shareCurrentUser];
    if (user.uuid == nil) {
        RegisterViewController *registerViewController = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil registerText:self.registerText];
        [self.navigationController pushViewController:registerViewController animated:YES];
//        [self presentViewController:registerViewController animated:YES completion:^{
//            //
//        }];
    }else{
        NSLog(@"该uuid已注册！！！");
    }
    
    
}

- (IBAction)loginAction:(id)sender
{
    UserModel *user = [UserModel shareCurrentUser];
    //回收键盘
    [self.uname endEditing:YES];
    [self.psd endEditing:YES];
    if (user.uuid == nil) {
        return;
    }
    
    if (![[self.uname.text stringByReplacingOccurrencesOfString:@" " withString:@""]isEqualToString:@""] && ![[self.psd.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] && self.uname.text.length >= 6 && self.psd.text.length >= 6){
        
        //*****************************网络判断***************************************//
        if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable && [Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable)
        {
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(50, 200, 220, 20)];
            lable.backgroundColor = [UIColor blackColor];
            lable.text = @"无网络连接！";
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [UIColor whiteColor];
            
            [self.view addSubview:lable];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
            lable = nil;
            //NSLog(@"无网络连接");
        }else{
            //**************************有网络的操作**************************************//
            [self.view showWithType:0 Title:@"正在登录,请稍等..."];
            //UserModel *user = [UserModel shareCurrentUser];
            //oumeil,123456,123456,18826483794
            //204220CE-384B-4D31-8834-FF39365A8E77
            //02508B0C-9059-498F-A8C0-BD9B5B8C7AF2
            
            [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": USER_LOGIN,@"psd": self.psd.text,@"uname": self.uname.text,@"uuid": user.uuid} completionBlock:^(id object) {
                //            NSLog(@"dic = %@",object);
                NSString *ovo = [object valueForKey:@"ovo"];
                NSDictionary *objectVoDic = [ovo JSONValue];
                NSString *code = [objectVoDic valueForKey:@"code"];
                if ([code intValue] == 0) {
                    [ObjectVo clearCurrentObjectVo];
                    ObjectVo *objectVo = [ObjectVo shareCurrentObjectVo];
                    
                    for (NSString *key in [objectVoDic allKeys]) {
//                        NSLog(@"key = %@",key);
//                        NSLog(@"value=%@",[objectVoDic valueForKey:key]);
                        
                        if ([key isEqualToString:@"baseData"] || [key isEqualToString:@"ue"]) {
                            if ([key isEqualToString:@"ue"]){
                                
                                NSDictionary *ueDic = [objectVoDic valueForKey:key];
                                [UserEntity clearCurrrentUe];
                                UserEntity *ue = [UserEntity shareCurrentUe];
                                for (NSString *uekey in [ueDic allKeys]) {
                                    if ([[ueDic valueForKey:uekey] isKindOfClass:[NSString class]]) {
                                        [ue setValue:[ueDic valueForKey:uekey] forKey:uekey];
                                    }else{
                                        [ue setValue:[NSString stringWithFormat:@"%d",[[ueDic valueForKey:uekey] intValue]] forKey:uekey];
                                    }
//                                    [ue setValue:[ueDic valueForKey:uekey] forKey:uekey];
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
                            
//                            NSDictionary *baseDataDic = [objectVoDic valueForKey:key];
////                            BaseData *baseData = [[BaseData alloc]init];
////                            baseData.pps = [NSArray array];
//////                            for (NSString *bdkey in [baseDataDic allKeys]) {
//////                                
//////                                [baseData setValue:[baseDataDic valueForKey:bdkey] forKey:bdkey];
//////                            }
////                            NSLog(@"baseData = %@",baseData);
//                            [objectVo setValue:baseDataDic forKey:key];
//
////                            [objectVo setValue:baseData forKey:key];
//                            //baseData = nil;
//                            
//                        }else if ([key isEqualToString:@"ue"]){
//                        
//                            NSDictionary *ueDic = [objectVoDic valueForKey:key];
//                            UserEntity *ue = [[UserEntity alloc]init];
//                            for (NSString *uekey in [ueDic allKeys]) {
//                                [ue setValue:[ueDic valueForKey:uekey] forKey:uekey];
//                            }
//                            [objectVo setValue:ue forKey:key];
//                            //ue = nil;
                            
                            [objectVo setValue:[objectVoDic valueForKey:key] forKey:key];
                        }else{
                            
                            if ([[objectVoDic valueForKey:key] isKindOfClass:[NSString class]]) {
                                [objectVo setValue:[objectVoDic valueForKey:key] forKey:key];
                            }else{
                                [objectVo setValue:[NSString stringWithFormat:@"%d",[[objectVoDic valueForKey:key] intValue]] forKey:key];
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
                    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 350, 240, 20)];
                    lable.backgroundColor = [UIColor blackColor];
                    lable.text = [objectVoDic valueForKey:@"msg"];
                    lable.textAlignment = NSTextAlignmentCenter;
                    lable.textColor = [UIColor whiteColor];
                    
                    [self.view addSubview:lable];
                    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
                    lable = nil;
                }
            } failureBlock:^(NSError *error, NSString *responseString) {
                //
            }];
        }
    }
    else{
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 350, 240, 20)];
        lable.backgroundColor = [UIColor blackColor];
        lable.text = @"注册信息不完整，请继续填写！";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        
        [self.view addSubview:lable];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
        lable = nil;
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
    UserModel *user = [UserModel shareCurrentUser];
    self.uname.text = user.uname;
    self.psd.text = user.psd;
    
    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable && [Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable)
    {
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(50, 200, 220, 20)];
        lable.backgroundColor = [UIColor blackColor];
        lable.text = @"无网络连接！";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        
        [self.view addSubview:lable];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
        lable = nil;
        //NSLog(@"无网络连接");
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
