//
//  AddMerchantsViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-5.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "AddMerchantsViewController.h"
#import "UserEntity.h"
#import "HttpService.h"
#import "JSON.h"
#import "Config.h"
#import "ObjectVo.h"
#import "ResultsModel.h"
#include <objc/runtime.h>

@interface AddMerchantsViewController ()

@end

@implementation AddMerchantsViewController

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
    self.addWebView.scrollView.bounces = NO;
    Config *config = [Config shareCurrentConfig];
    [self.addWebView loadHTMLString:config.addFriendText baseURL:[NSBundle mainBundle].bundleURL];
    
    [self.validationMsg _init];
    self.validationMsg.placeholder = @"请在此输入验证消息...";
}

- (IBAction)sendMessage:(id)sender
{
    [self.account endEditing:YES];
    [self.validationMsg endEditing:YES];
    if (![[self.account.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] && self.account.text.length >= 6) {
        UserEntity *user = [UserEntity shareCurrentUe];
        [self.view showWithType:0 Title:@"正在发送验证信息..."];
        ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": ADD_FRIEND,@"fname": self.account.text,@"msg": self.validationMsg.text,@"uname": user.userName,@"uuid": user.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
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
            NSDictionary *ovoDic = [ovo JSONValue];
            if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
                [self.view endSynRequestSignal];
                [self.view LabelTitle:@"发送验证成功，请耐心等候商家审核！"];
            }else{
                [self.view endSynRequestSignal];
                [self.view LabelTitle:[ovoDic valueForKey:@"msg"]];
            }
            
        } failureBlock:^(NSError *error, NSString *responseString) {
            [self.view endSynRequestSignal];
        }];

    }else{
        [self.view LabelTitle:@"商家用户名不符合规则"];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.line1.backgroundColor = [UIColor blueColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.line1.backgroundColor = [UIColor lightGrayColor];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.line2.backgroundColor = [UIColor blueColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.line2.backgroundColor = [UIColor lightGrayColor];
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
