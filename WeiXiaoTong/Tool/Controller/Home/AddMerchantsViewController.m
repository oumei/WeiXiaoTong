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
#import "UIView+SynRequestSignal.h"

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
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": ADD_FRIEND,@"fname": self.account.text,@"msg": self.validationMsg.text,@"uname": user.userName,@"uuid": user.uuid} completionBlock:^(id object) {
            
            NSString *ovo = [object valueForKey:@"ovo"];
            NSDictionary *ovoDic = [ovo JSONValue];
            if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
                [self.view endSynRequestSignal];
                UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 350, 280, 20)];
                lable.backgroundColor = [UIColor blackColor];
                lable.text = @"发送验证成功，请耐心等候商家审核！";
                lable.textAlignment = NSTextAlignmentCenter;
                lable.textColor = [UIColor whiteColor];
                
                [self.view addSubview:lable];
                [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
                lable = nil;
            }else{
                [self.view endSynRequestSignal];
                UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 350, 240, 20)];
                lable.backgroundColor = [UIColor blackColor];
                lable.text = [ovoDic valueForKey:@"msg"];
                lable.textAlignment = NSTextAlignmentCenter;
                lable.textColor = [UIColor whiteColor];
                
                [self.view addSubview:lable];
                [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
                lable = nil;
            }
            
        } failureBlock:^(NSError *error, NSString *responseString) {
            //
        }];

    }else{
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 350, 240, 20)];
        lable.backgroundColor = [UIColor blackColor];
        lable.text = @"商家用户名不符合规则";
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
