//
//  ObjectVo.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-23.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "ObjectVo.h"

@implementation ObjectVo
@synthesize code = _code;
@synthesize msg = _msg;
@synthesize baseData = _baseData;
@synthesize dataVersions = _dataVersions;
@synthesize ue = _ue;
@synthesize suser = _suser;

+ (ObjectVo *)shareCurrentObjectVo
{
    static ObjectVo *objectVo = nil;
    if (objectVo) {
        return objectVo;
    }
    
    NSFileManager *fm =[NSFileManager defaultManager];
    NSString *objectVoInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/objectVoInfo.txt"];
    if ([fm fileExistsAtPath:objectVoInfoPath]) {
        NSMutableData *data=[[NSMutableData alloc] initWithContentsOfFile:objectVoInfoPath];
        
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        objectVo = [unarchiver decodeObjectForKey:@"objectVoInfo"];
        [unarchiver finishDecoding];
    } else {
        objectVo = [[ObjectVo alloc] init];
    }
    
    return objectVo;
}

+ (void)clearCurrentObjectVo
{
    NSString *objectVoInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/objectVoInfo.txt"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:objectVoInfoPath]) {
        NSError *error = nil;
        [fm removeItemAtPath:objectVoInfoPath error:&error];
        
        NSLog(@"clear current result : %@",error.localizedDescription);
    } else {
        NSLog(@"clear current result : 当前没有登录");
    }
}

- (id)initwithCode:(int)aCode msg:(NSString *)aMsg baseData:(NSDictionary *)aBaseData dataVersions:(NSString *)aDataVersions userEntity:(NSDictionary *)aUE suser:(NSDictionary *)aSuser
{
    if (self == [super init])
    {
        self.code = aCode;
        self.msg = aMsg;
        self.baseData = aBaseData;
        self.dataVersions = aDataVersions;
        self.ue = aUE;
        self.suser = aSuser;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.msg forKey:@"msg"];
    [encoder encodeInt:self.code forKey:@"code"];
    [encoder encodeObject:self.baseData forKey:@"baseData"];
    [encoder encodeObject:self.dataVersions forKey:@"dataVersions"];
    [encoder encodeObject:self.ue forKey:@"ue"];
    [encoder encodeObject:self.suser forKey:@"suser"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.msg = [decoder decodeObjectForKey:@"msg"];
        self.code = [decoder decodeIntForKey:@"code"];
        self.baseData = [decoder decodeObjectForKey:@"baseData"];
        self.dataVersions = [decoder decodeObjectForKey:@"dataVersions"];
        self.ue = [decoder decodeObjectForKey:@"ue"];
        self.suser = [decoder decodeObjectForKey:@"suser"];
    }
    return self;
    
}


@end
