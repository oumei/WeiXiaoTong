//
//  RegisterViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+RegularExpressionTest.h"
#import "UserModel.h"
#import "HttpService.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil registerText:(NSString *)aRegisterText
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.st = aRegisterText;
        NSLog(@"self = %@",aRegisterText);
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
    self.registerTextView.text = self.st;
    NSLog(@"sf = %@",self.registerTextView.text);
}

- (IBAction)submit:(id)sender
{
    [self.tell endEditing:YES];
    [self.uname endEditing:YES];
    [self.psd endEditing:YES];
    [self.cpsd endEditing:YES];
    if (![self.uname.text isEqualToString:@""] && ![self.psd.text isEqualToString:@""] && ![self.cpsd.text isEqualToString:@""] && ![self.tell.text isEqualToString:@""] && self.uname.text.length >= 6 && self.psd.text.length >= 6 && self.cpsd.text.length >= 6)
    {
        if (![self.psd.text isEqualToString:self.cpsd.text]) {
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(50, 350, 220, 20)];
            lable.backgroundColor = [UIColor blackColor];
            lable.text = @"两次密码填写不一致！";
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [UIColor whiteColor];
            [self.view addSubview:lable];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
            lable = nil;
            return;
        }
        if (![NSString isValidateMobile:self.tell.text]) {
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(50, 350, 220, 20)];
            lable.backgroundColor = [UIColor blackColor];
            lable.text = @"手机号码格式错误！";
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [UIColor whiteColor];
            [self.view addSubview:lable];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
            lable = nil;
            return;
        }
        
        //UserModel *user = [UserModel shareCurrentUser];
        //oumeil,123456,123456,18826483794
        //204220CE-384B-4D31-8834-FF39365A8E77
        //02508B0C-9059-498F-A8C0-BD9B5B8C7AF2
        //***************************缺少uuid的值*******************************//
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": USER_REGISTER,@"uname": self.uname.text,@"psd": self.psd.text,@"tell": self.tell.text,@"uuid": @"uuid"} completionBlock:^(id object) {
            if ([[object valueForKey:@"code"] integerValue] == 0) {
                [UserModel clearCurrrentUser];
                UserModel *userModel = [UserModel shareCurrentUser];
                NSString *uuid = [self uuid];
                NSLog(@"2014uuid = %@",uuid);
                
                [userModel setValue:self.uname.text forKey:@"uname"];
                [userModel setValue:self.psd.text forKey:@"psd"];
                [userModel setValue:self.tell.text forKey:@"tell"];
                [userModel setValue:uuid forKey:@"uuid"];
                
                // 将个人信息全部持久化到documents中，可通过config的单例获取登录了的用户的个人信息
                NSMutableData *mData = [[NSMutableData alloc]init];
                NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
                [archiver encodeObject:userModel forKey:@"userModelInfo"];
                [archiver finishEncoding];
                NSString *userModelInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userModelInfo.txt"];
                [mData writeToFile:userModelInfoPath atomically:YES];
                
            }else{
                UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 350, 280, 20)];
                lable.backgroundColor = [UIColor blackColor];
                lable.text = [object objectForKey:@"msg"];
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
    else
    {
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
