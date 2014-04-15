//
//  AboutWXTViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-4-7.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "AboutWXTViewController.h"

@interface AboutWXTViewController ()

@end

@implementation AboutWXTViewController

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
    NSURL *url=[NSURL URLWithString:@"http://www.016888.net/"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

//开始加载的时候调用的代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.view showSpinner:0 Title:@"正在加载"];
}

//完成加载的时候调用的代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view endSynRequestSignal];
}
//加载失败的时候调用的代理方法
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%s--%@",__FUNCTION__,error.localizedDescription);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self setView:nil];
}

@end
