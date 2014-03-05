//
//  AddMerchantsViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-5.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "AddMerchantsViewController.h"

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
    if (![[self.account.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] && self.account.text.length >= 6) {
        //
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
