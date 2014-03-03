//
//  UserEntity.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-23.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserEntity : NSObject
{
    int _Id;
    NSString *_userName;
    NSString *_psd;
    int _tell;
    NSString *_xzStr;
    int _xzCount;
    int _qx;
    int _state;
    NSString *_uuid;
    int _resetUuid;
    int _daoqi;
    NSString *_registerTime;
    int _level;
    NSString *_firends;
    int _tableName;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *psd;
@property(nonatomic,assign)int tell;
@property(nonatomic,copy)NSString *xzStr;
@property(nonatomic,assign)int xzCount;
@property(nonatomic,assign)int qx;
@property(nonatomic,assign)int state;
@property(nonatomic,copy)NSString *uuid;
@property(nonatomic,assign)int resetUuid;
@property(nonatomic,assign)int daoqi;
@property(nonatomic,copy)NSString *registerTime;
@property(nonatomic,assign)int level;
@property(nonatomic,copy)NSString *firends;
@property(nonatomic,assign)int tableName;


@end
