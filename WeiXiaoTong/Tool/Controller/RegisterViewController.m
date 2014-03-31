//
//  RegisterViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+RegularExpressionTest.h"
#import "UserEntity.h"
#import "HttpService.h"
#import "JSON.h"
#import "ResultsModel.h"
#include <objc/runtime.h>
#import "Reachability.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil registerText:(NSString *)aRegisterText
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.st = aRegisterText;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.psd.secureTextEntry = YES;
    self.cpsd.secureTextEntry = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.registerWebView.scrollView.bounces = NO;
    [self.registerWebView loadHTMLString:self.st baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (IBAction)submit:(id)sender
{
    [self.tell endEditing:YES];
    [self.uname endEditing:YES];
    [self.psd endEditing:YES];
    [self.cpsd endEditing:YES];
    UserEntity *userModel = [UserEntity shareCurrentUe];
    if (userModel.uuid == nil) {
        userModel.uuid = [self uuid];
    }
    if (![self.uname.text isEqualToString:@""] && ![self.psd.text isEqualToString:@""] && ![self.cpsd.text isEqualToString:@""] && ![self.tell.text isEqualToString:@""] && self.uname.text.length >= 6 && self.psd.text.length >= 6 && self.cpsd.text.length >= 6)
    {
        if (![self.psd.text isEqualToString:self.cpsd.text]) {
            [self.view LabelTitle:@"两次密码填写不一致！"];
            return;
        }
        if (![NSString isValidateMobile:self.tell.text]) {
            [self.view LabelTitle:@"手机号码格式错误！"];
            return;
        }
        
        [self.view showWithType:0 Title:@"提交注册信息中..."];
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": USER_REGISTER,@"uname": self.uname.text,@"psd": self.psd.text,@"tell": self.tell.text,@"uuid": userModel.uuid} completionBlock:^(id object) {
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
            NSDictionary *ovoDic = [[object valueForKey:@"ovo"] JSONValue];
            if ([[ovoDic valueForKey:@"code"] integerValue] == 0) {
                [self.view endSynRequestSignal];
                [UserEntity clearCurrrentUe];
                [userModel setValue:self.uname.text forKey:@"userName"];
                [userModel setValue:self.psd.text forKey:@"psd"];
                [userModel setValue:self.tell.text forKey:@"tell"];
                
                // 将个人信息全部持久化到documents中，可通过ue的单例获取登录了的用户的个人信息
                NSMutableData *mData = [[NSMutableData alloc]init];
                NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
                [archiver encodeObject:userModel forKey:@"ueInfo"];
                [archiver finishEncoding];
                NSString *ueInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ueInfo.txt"];
                [mData writeToFile:ueInfoPath atomically:YES];
                mData = nil;
                [self.view LabelTitle:@"注册成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view endSynRequestSignal];
                [self.view LabelTitle:[ovoDic objectForKey:@"msg"]];
            }
            
        } failureBlock:^(NSError *error, NSString *responseString) {
            [self.view endSynRequestSignal];
        }];
    }
    else
    {
        [self.view LabelTitle:@"注册信息不完整，请继续填写！"];
    }
}


- (NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (__bridge_transfer NSString *)CFStringCreateCopy( NULL, uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

- (void)dealloc
{
    [self setView:nil];
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
