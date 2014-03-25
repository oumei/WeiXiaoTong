//
//  CustomAlertView.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIAlertView
@property(copy,nonatomic)NSString *labelText;
@property(copy,nonatomic)NSString *content;
@property(copy,nonatomic)NSIndexPath *indexPath;

- (id)initWithFrame:(CGRect)frame labelText:(NSString *)labelText content:(NSString *)content;

@end
