//
//  RegisterViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"

@interface RegisterViewController : CommonViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *uname;
@property (weak, nonatomic) IBOutlet UITextField *psd;
@property (weak, nonatomic) IBOutlet UITextField *cpsd;
@property (weak, nonatomic) IBOutlet UITextField *tell;
@property (weak, nonatomic) IBOutlet UIWebView *registerWebView;
@property (strong, nonatomic) NSString *st;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil registerText:(NSString *)aRegisterText;

@end
