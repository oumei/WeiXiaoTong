//
//  PersonalInformationViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"

@interface PersonalInformationViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *current;
@property (weak, nonatomic) IBOutlet UILabel *validityTime;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *mersNum;

@end
