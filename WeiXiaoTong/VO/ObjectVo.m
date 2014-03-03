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

- (id)initwithCode:(int)aCode msg:(NSString *)aMsg baseData:(NSDictionary *)aBaseData dataVersions:(int)aDataVersions userEntity:(NSDictionary *)aUE
{
    if (self == [super init])
    {
        self.code = aCode;
        self.msg = aMsg;
        self.baseData = aBaseData;
        self.dataVersions = aDataVersions;
        self.ue = aUE;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.msg forKey:@"msg"];
    [encoder encodeInt:self.code forKey:@"code"];
    [encoder encodeObject:self.baseData forKey:@"baseData"];
    [encoder encodeInt:self.dataVersions forKey:@"dataVersions"];
    [encoder encodeObject:self.ue forKey:@"ue"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    
    if (self = [super init]) {
        self.msg = [decoder decodeObjectForKey:@"msg"];
        self.code = [decoder decodeIntForKey:@"code"];
        self.baseData = [decoder decodeObjectForKey:@"baseData"];
        self.dataVersions = [decoder decodeIntForKey:@"dataVersions"];
        self.ue = [decoder decodeObjectForKey:@"ue"];
    }
    return self;
    
}


@end
