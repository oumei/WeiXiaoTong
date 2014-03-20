//
//  AddMerchantsViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-5.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"
#import "CDTextView.h"

@interface AddMerchantsViewController : CommonViewController<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet CDTextView *validationMsg;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIWebView *addWebView;

@end
