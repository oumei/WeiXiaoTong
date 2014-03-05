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
@synthesize xzStr = _xzStr;
@synthesize xzCount = _xzCount;
@synthesize qx = _qx;
@synthesize state = _state;
@synthesize uuid = _uuid;
@synthesize resetUuid = _resetUuid;
@synthesize daoqi = _daoqi;
@synthesize registerTime = _registerTime;
@synthesize level = _level;
@synthesize firends = _firends;
@synthesize tableName = _tableName;

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

- (id)initWithUname:(NSString *)aUname psd:(NSString *)aPsd tell:(int)aTell uuid:(NSString *)aUuid id:(int)aId xzStr:(NSString *)aXzStr xzCount:(int)aXzCount qx:(int)aQx state:(int)aState resetUuid:(int)aResetUuid daoqi:(int)aDaoqi registerTime:(NSString *)aRegisterTime level:(int)aLevel firends:(NSString *)aFirends tableName:(int)aTableName
{
    if (self = [super init])
    {
        self.userName = aUname;
        self.psd = aPsd;
        self.tell = aTell;
        self.uuid = aUuid;
        self.Id = aId;
        self.xzCount = aXzCount;
        self.xzStr = aXzStr;
        self.qx = aQx;
        self.state = aState;
        self.resetUuid = aResetUuid;
        self.daoqi = aDaoqi;
        self.registerTime = aRegisterTime;
        self.level = aLevel;
        self.firends = aFirends;
        self.tableName = aTableName;
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
    [encoder encodeObject:self.xzStr forKey:@"xzStr"];
    [encoder encodeInt:self.xzCount forKey:@"xzCount"];
    [encoder encodeInt:self.qx forKey:@"qx"];
    [encoder encodeInt:self.state forKey:@"state"];
    [encoder encodeInt:self.resetUuid forKey:@"resetUuid"];
    [encoder encodeInt:self.daoqi forKey:@"daoqi"];
    [encoder encodeObject:self.registerTime forKey:@"registerTime"];
    [encoder encodeInt:self.level forKey:@"level"];
    [encoder encodeObject:self.firends forKey:@"firends"];
    [encoder encodeInt:self.tableName forKey:@"tableName"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    
    if (self = [super init]) {
        self.userName = [decoder decodeObjectForKey:@"userName"];
        self.tell = [decoder decodeIntForKey:@"tell"];
        self.psd = [decoder decodeObjectForKey:@"psd"];
        self.uuid = [decoder decodeObjectForKey:@"uuid"];
        self.Id = [decoder decodeIntForKey:@"id"];
        self.xzStr = [decoder decodeObjectForKey:@"xzStr"];
        self.xzCount = [decoder decodeIntForKey:@"xzCount"];
        self.qx = [decoder decodeIntForKey:@"qx"];
        self.state = [decoder decodeIntForKey:@"state"];
        self.resetUuid = [decoder decodeIntForKey:@"resetUuid"];
        self.daoqi = [decoder decodeIntForKey:@"daoqi"];
        self.registerTime = [decoder decodeObjectForKey:@"registerTime"];
        self.level = [decoder decodeIntForKey:@"level"];
        self.firends = [decoder decodeObjectForKey:@"firends"];
        self.tableName = [decoder decodeIntForKey:@"tableName"];
    }
    return self;
    
}

@end
