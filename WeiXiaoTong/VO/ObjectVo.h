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
    int _dataVersions;
    NSDictionary *_ue;
    NSDictionary *_baseData;
}
@property(nonatomic,assign)int code;
@property(nonatomic,copy)NSString *msg;
//@property(nonatomic,copy)BaseData *baseData;
@property(nonatomic,assign)int dataVersions;
//@property(nonatomic,copy)UserEntity *ue;
@property(nonatomic,copy)NSDictionary *baseData;
@property(nonatomic,copy)NSDictionary *ue;

+ (ObjectVo *)shareCurrentObjectVo;
+ (void)clearCurrentObjectVo;
- (id)initwithCode:(int)aCode
               msg:(NSString *)aMsg
          baseData:(NSDictionary *)aBaseData
      dataVersions:(int)aDataVersions
        userEntity:(NSDictionary *)aUE;

@end
