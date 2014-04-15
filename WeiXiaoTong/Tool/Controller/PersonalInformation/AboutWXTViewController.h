//
//  AboutWXTViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-4-7.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"

@interface AboutWXTViewController : CommonViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
