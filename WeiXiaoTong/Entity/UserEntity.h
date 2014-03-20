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
    NSString *_description;
    int _friendCout;
    int _chanPinCout;
    int _upCount;
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
@property(nonatomic,copy)NSString *description;
@property(nonatomic,assign)int friendCout;
@property(nonatomic,assign)int chanPinCout;
@property(nonatomic,assign)int upCount;

+ (UserEntity *)shareCurrentUe;
+ (void)clearCurrrentUe;
- (id)initWithUname:(NSString *)aUname
                psd:(NSString *)aPsd
               tell:(int)aTell
               uuid:(NSString *)aUuid
                 id:(int)aId
              xzStr:(NSString *)aXzStr
            xzCount:(int)aXzCount
                 qx:(int)aQx
              state:(int)aState
          resetUuid:(int)aResetUuid
              daoqi:(int)aDaoqi
       registerTime:(NSString *)aRegisterTime
              level:(int)aLevel
            firends:(NSString *)aFirends
          tableName:(int)aTableName
        description:(NSString *)aDescription
         friendCout:(int)aFriendCout
        chanPinCout:(int)aChanPinCout
            upCount:(int)aUpCount;

@end
