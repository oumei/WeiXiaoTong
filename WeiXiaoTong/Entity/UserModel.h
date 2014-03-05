//
//  UserModel.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-25.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
{
    NSString *_uname;
    NSString *psd;
    int _tell;
    NSString *_uuid;
}
@property(nonatomic,copy)NSString *uname;
@property(nonatomic,copy)NSString *psd;
@property(nonatomic,assign)int tell;
@property(nonatomic,copy)NSString *uuid;
+ (UserModel *)shareCurrentUser;
+ (void)clearCurrrentUser;
- (id)initWithUname:(NSString *)aUname psd:(NSString *)aPsd tell:(int)aTell uuid:(NSString *)aUuid;

@end
