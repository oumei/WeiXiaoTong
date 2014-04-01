//
//  LoginViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"

@interface LoginViewController : CommonViewController
{
    NSString *_registerText;
}

@property(nonatomic,strong)NSString *registerText;
@property (weak, nonatomic) IBOutlet UITextField *uname;
@property (weak, nonatomic) IBOutlet UITextField *psd;
@property (weak, nonatomic) IBOutlet UIWebView *loginWebView;

@end
