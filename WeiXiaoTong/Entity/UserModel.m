//
//  UserModel.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-25.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
@synthesize uname = _uname;
@synthesize psd = _psd;
@synthesize tell = _tell;
@synthesize uuid = _uuid;

+ (UserModel *)shareCurrentUser
{
    static UserModel *userModel = nil;
    if (userModel) {
        return userModel;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *userModelInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userModelInfo.txt"];
    if ([fm fileExistsAtPath:userModelInfoPath]) {
        NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:userModelInfoPath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        userModel = [unarchiver decodeObjectForKey:@"userModelInfo"];
        [unarchiver finishDecoding];
    }else{
        userModel = [[UserModel alloc]init];
    }
    return userModel;
}

+ (void)clearCurrrentUser
{
    NSString *userModelInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userModelInfo.txt"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:userModelInfoPath]) {
        NSError *error = nil;
        [fm removeItemAtPath:userModelInfoPath error:&error];
        
        NSLog(@"clear current user result : %@",error.localizedDescription);
    } else {
        NSLog(@"clear current user result : 当前没有登录");
    }
}

- (id)initWithUname:(NSString *)aUname psd:(int)aPsd tell:(NSString *)aTell uuid:(NSString *)aUuid
{
    if (self = [super init])
    {
        self.uname = aUname;
        self.psd = aPsd;
        self.tell = aTell;
        self.uuid = aUuid;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    [encoder encodeObject:self.uname forKey:@"uname"];
    [encoder encodeInt:self.psd forKey:@"psd"];
    [encoder encodeObject:self.tell forKey:@"tell"];
    [encoder encodeObject:self.uuid forKey:@"uuid"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    
    if (self = [super init]) {
        self.uname = [decoder decodeObjectForKey:@"uname"];
        self.psd = [decoder decodeIntForKey:@"psd"];
        self.tell = [decoder decodeObjectForKey:@"tell"];
        self.uuid = [decoder decodeObjectForKey:@"uuid"];
        
    }
    return self;
    
}


@end
