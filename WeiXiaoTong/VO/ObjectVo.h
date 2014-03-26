//
//  ObjectVo.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-23.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BaseData.h"
//#import "UserEntity.h"

@interface ObjectVo : NSObject
{
    int _code;
    NSString *_msg;
//    BaseData *_baseData;
//    UserEntity *_ue;
    NSString *_dataVersions;
    NSDictionary *_ue;
    NSDictionary *_baseData;
    NSDictionary *_suser;
}
@property(nonatomic,assign)int code;
@property(nonatomic,copy)NSString *msg;
//@property(nonatomic,copy)BaseData *baseData;
//@property(nonatomic,copy)UserEntity *ue;
@property(nonatomic,copy)NSDictionary *baseData;
@property(nonatomic,copy)NSDictionary *ue;
@property(nonatomic,copy)NSDictionary *suser;
@property(nonatomic,copy)NSString *dataVersions;

+ (ObjectVo *)shareCurrentObjectVo;
+ (void)clearCurrentObjectVo;
- (id)initwithCode:(int)aCode
               msg:(NSString *)aMsg
          baseData:(NSDictionary *)aBaseData
      dataVersions:(NSString *)aDataVersions
        userEntity:(NSDictionary *)aUE
           suser:(NSDictionary *)aSuser;

@end
