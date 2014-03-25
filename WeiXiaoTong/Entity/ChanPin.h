//
//  ChanPin.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-23.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChanPin : NSObject
{
    int _Id;
    NSString *_miaoshu;
    int _pinpai;
    int _leixing;
    int _xingbie;
    NSString *_shijian;
    NSString *_dangkou;
    int _jiage;
    int _pics;
    int _price;
    int _upload;
    int _state;
    NSString *_categorys;
    NSString *_address;
    NSString *_title;
    NSString *_attrebute;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,copy)NSString *miaoshu;
@property(nonatomic,assign)int pinpai;
@property(nonatomic,assign)int leixing;
@property(nonatomic,assign)int xingbie;
@property(nonatomic,copy)NSString *shijian;
@property(nonatomic,copy)NSString *dangkou;
@property(nonatomic,assign)int jiage;
@property(nonatomic,assign)int pics;
@property(nonatomic,assign)int price;
@property(nonatomic,assign)int upload;
@property(nonatomic,assign)int state;
@property(nonatomic,copy)NSString *categorys;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *attrebute;


@end
