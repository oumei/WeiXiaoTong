//
//  CustomAlertView.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

- (id)initWithFrame:(CGRect)frame labelText:(NSString *)labelText content:(NSString *)content
{
    self = [super initWithFrame:frame];
    if (self) {
        self.labelText = labelText;
        self.content = content;
        [self _initUI];
    }
    return self;
}

- (void)_initUI
{
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 280, 120)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    image.image = [UIImage imageNamed:@"ic_launcher.png"];
    [backgroundView addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 220, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blueColor];
    label.text = self.labelText;
    [backgroundView addSubview:label];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 280, 1)];
    line.backgroundColor = [UIColor blueColor];
    [backgroundView addSubview:line];
    
    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(15, 50, 250, 30)];
    text.backgroundColor = [UIColor clearColor];
    text.text = self.content;
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 85, 280, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:line2];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.backgroundColor = [UIColor clearColor];
    cancel.frame = CGRectMake(0, 90, 140, 30);
    [cancel setTitle:@"取消" forState:0];
    [cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:cancel];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(140, 85, 1, 35)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:line3];
    
    UIButton *modify = [UIButton buttonWithType:UIButtonTypeCustom];
    modify.backgroundColor = [UIColor clearColor];
    modify.frame = CGRectMake(141, 90, 139, 30);
    [modify setTitle:@"修改" forState:0];
    [modify addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:modify];
    
    [self addSubview:backgroundView];
    [self bringSubviewToFront:backgroundView];
    
//    backgroundView = nil;
//    image = nil;
//    label = nil;
//    text = nil;
//    line = nil;
//    line2 = nil;
//    line3 = nil;
//    cancel = nil;
//    modify = nil;
}

- (void)cancelAction:(UIButton *)sender
{
    [sender performSelector:@selector(alertViewCancel:) withObject:self];
}

- (void)modifyAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:1];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
