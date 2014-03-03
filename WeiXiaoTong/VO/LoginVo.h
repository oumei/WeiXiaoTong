//
//  LoginVo.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-23.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "ObjectVo.h"
@class UserEntity;
@class BaseData;
@interface LoginVo : ObjectVo
{
    UserEntity *ue;
    BaseData *data;
    int dataVersions;
}

@end
