//
//  Config.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-23.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
{
    NSString *_url;
    int _serverBanBen;
    NSString *_dxurl;
    NSString *_wturl;
    NSString *_sj;
    NSString *_loginText;
    NSString *_seachText;
    NSString *_addFriendText;
}

@property(nonatomic,copy)NSString *url;
@property(nonatomic,assign)int serverBanBen;
@property(nonatomic,copy)NSString *dxurl;
@property(nonatomic,copy)NSString *wturl;
@property(nonatomic,copy)NSString *sj;
@property(nonatomic,copy)NSString *loginText;
@property(nonatomic,copy)NSString *seachText;
@property(nonatomic,copy)NSString *addFriendText;

+ (Config *)shareCurrentConfig;
+ (void)clearCurrentConfig;
- (id)initWithUrl:(NSString *)aUrl
     serverBanBen:(int)aServerBanBen
            dxurl:(NSString *)aDxurl
            wturl:(NSString *)aWturl
               sj:(NSString *)aSj
        loginText:(NSString *)aLoginText
        seachText:(NSString *)aSeachText
    addFriendText:(NSString *)aFriendText;

@end
