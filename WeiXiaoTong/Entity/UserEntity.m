//
//  UserEntity.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-23.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "UserEntity.h"

@implementation UserEntity
@synthesize Id = _Id;
@synthesize userName = _userName;
@synthesize psd = _psd;
@synthesize tell = _tell;
@synthesize xzCount = _xzCount;
@synthesize qx = _qx;
@synthesize state = _state;
@synthesize uuid = _uuid;
@synthesize resetUuid = _resetUuid;
@synthesize daoqi = _daoqi;
@synthesize registerTime = _registerTime;
@synthesize tableName = _tableName;
@synthesize description = _description;
@synthesize friendCout = _friendCout;
@synthesize chanPinCout = _chanPinCout;
@synthesize upCount = _upCount;

+ (UserEntity *)shareCurrentUe
{
    static UserEntity *ue = nil;
    if (ue) {
        return ue;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *ueInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ueInfo.txt"];
    if ([fm fileExistsAtPath:ueInfoPath]) {
        NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:ueInfoPath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        ue = [unarchiver decodeObjectForKey:@"ueInfo"];
        [unarchiver finishDecoding];
    }else{
        ue = [[UserEntity alloc]init];
    }
    return ue;
}

+ (void)clearCurrrentUe
{
    NSString *ueInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ueInfo.txt"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:ueInfoPath]) {
        NSError *error = nil;
        [fm removeItemAtPath:ueInfoPath error:&error];
        
        NSLog(@"clear current ue result : %@",error.localizedDescription);
    } else {
        NSLog(@"clear current ue result : 当前没有登录");
    }
}

- (id)initWithUname:(NSString *)aUname psd:(NSString *)aPsd tell:(int)aTell uuid:(NSString *)aUuid id:(int)aId xzCount:(int)aXzCount qx:(int)aQx state:(int)aState resetUuid:(int)aResetUuid daoqi:(int)aDaoqi registerTime:(NSString *)aRegisterTime tableName:(int)aTableName description:(NSString *)aDescription friendCout:(int)aFriendCout chanPinCout:(int)aChanPinCout upCount:(int)aUpCount
{
    if (self = [super init])
    {
        self.userName = aUname;
        self.psd = aPsd;
        self.tell = aTell;
        self.uuid = aUuid;
        self.Id = aId;
        self.xzCount = aXzCount;
        self.qx = aQx;
        self.state = aState;
        self.resetUuid = aResetUuid;
        self.daoqi = aDaoqi;
        self.registerTime = aRegisterTime;
        self.tableName = aTableName;
        self.description = aDescription;
        self.friendCout = aFriendCout;
        self.chanPinCout = aChanPinCout;
        self.upCount = aUpCount;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.userName forKey:@"userName"];
    [encoder encodeInt:self.tell forKey:@"tell"];
    [encoder encodeObject:self.psd forKey:@"psd"];
    [encoder encodeObject:self.uuid forKey:@"uuid"];
    [encoder encodeInt:self.Id forKey:@"id"];
    [encoder encodeInt:self.xzCount forKey:@"xzCount"];
    [encoder encodeInt:self.qx forKey:@"qx"];
    [encoder encodeInt:self.state forKey:@"state"];
    [encoder encodeInt:self.resetUuid forKey:@"resetUuid"];
    [encoder encodeInt:self.daoqi forKey:@"daoqi"];
    [encoder encodeObject:self.registerTime forKey:@"registerTime"];
    [encoder encodeInt:self.tableName forKey:@"tableName"];
    [encoder encodeObject:self.description forKey:@"description"];
    [encoder encodeInt:self.friendCout forKey:@"friendCout"];
    [encoder encodeInt:self.chanPinCout forKey:@"chanPinCout"];
    [encoder encodeInt:self.upCount forKey:@"upCount"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    
    if (self = [super init]) {
        self.userName = [decoder decodeObjectForKey:@"userName"];
        self.tell = [decoder decodeIntForKey:@"tell"];
        self.psd = [decoder decodeObjectForKey:@"psd"];
        self.uuid = [decoder decodeObjectForKey:@"uuid"];
        self.Id = [decoder decodeIntForKey:@"id"];
        self.xzCount = [decoder decodeIntForKey:@"xzCount"];
        self.qx = [decoder decodeIntForKey:@"qx"];
        self.state = [decoder decodeIntForKey:@"state"];
        self.resetUuid = [decoder decodeIntForKey:@"resetUuid"];
        self.daoqi = [decoder decodeIntForKey:@"daoqi"];
        self.registerTime = [decoder decodeObjectForKey:@"registerTime"];
        self.tableName = [decoder decodeIntForKey:@"tableName"];
        self.description = [decoder decodeObjectForKey:@"description"];
        self.friendCout = [decoder decodeIntForKey:@"friendCout"];
    }
    return self;
    
}

@end
