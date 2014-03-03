//
//  SourceUser.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-23.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SourceUser : NSObject
{
    int _Id;
    NSString *_uname;
    NSString *_psd;
    int _qx;
    int _state;
    NSString *_dangkou;
    int _upCount;
    int _tell;
    int _qq;
    NSString *_description;
    NSString *_name;
    int _holder;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,copy)NSString *uname;
@property(nonatomic,copy)NSString *psd;
@property(nonatomic,assign)int qx;
@property(nonatomic,assign)int state;
@property(nonatomic,copy)NSString *dangkou;
@property(nonatomic,assign)int upCount;
@property(nonatomic,assign)int tell;
@property(nonatomic,assign)int qq;
@property(nonatomic,copy)NSString *description;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)int holder;

@end
