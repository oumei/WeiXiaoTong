//
//  Config.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-23.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "Config.h"

@implementation Config
@synthesize url = _url;
@synthesize serverBanBen = _serverBanBen;
@synthesize dxurl = _dxurl;
@synthesize wturl = _wturl;
@synthesize sj = _sj;
@synthesize loginText = _loginText;
@synthesize seachText = _seachText;
@synthesize addFriendText = _addFriendText;

+ (Config *)shareCurrentConfig
{
    static Config *config = nil;
    if (config) {
        return config;
    }
    
    NSFileManager *fm =[NSFileManager defaultManager];
    NSString *meInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/configInfo.txt"];
    if ([fm fileExistsAtPath:meInfoPath]) {
        NSMutableData *data=[[NSMutableData alloc] initWithContentsOfFile:meInfoPath];
        
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        config = [unarchiver decodeObjectForKey:@"configInfo"];
        [unarchiver finishDecoding];
    } else {
        config = [[Config alloc] init];
    }
    
    return config;
}

+ (void)clearCurrentConfig
{
    NSString *configInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/configInfo.txt"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:configInfoPath]) {
        NSError *error = nil;
        [fm removeItemAtPath:configInfoPath error:&error];
        
        NSLog(@"clear current config result : %@",error.localizedDescription);
    } else {
        NSLog(@"clear current config result : 当前没有登录");
    }
}

- (id)initWithUrl:(NSString *)aUrl serverBanBen:(int)aServerBanBen dxurl:(NSString *)aDxurl wturl:(NSString *)aWturl sj:(NSString *)aSj loginText:(NSString *)aLoginText seachText:(NSString *)aSeachText addFriendText:(NSString *)aFriendText
{
    if (self = [super init])
    {
        self.url = aUrl;
        self.serverBanBen = aServerBanBen;
        self.dxurl = aDxurl;
        self.wturl = aWturl;
        self.sj = aSj;
        self.loginText = aLoginText;
        self.seachText = aSeachText;
        self.addFriendText  = aFriendText;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeInt:self.serverBanBen forKey:@"serverBanBen"];
    [encoder encodeObject:self.dxurl forKey:@"dxurl"];
    [encoder encodeObject:self.wturl forKey:@"wturl"];
    [encoder encodeObject:self.sj forKey:@"sj"];
    [encoder encodeObject:self.loginText forKey:@"loginText"];
    [encoder encodeObject:self.seachText forKey:@"seachText"];
    [encoder encodeObject:self.addFriendText forKey:@"addFriendText"];

}

- (id)initWithCoder:(NSCoder *)decoder
{
    
    if (self = [super init]) {
        self.url = [decoder decodeObjectForKey:@"url"];
        self.serverBanBen = [decoder decodeIntForKey:@"serverBanBen"];
        self.dxurl = [decoder decodeObjectForKey:@"dxurl"];
        self.wturl = [decoder decodeObjectForKey:@"wturl"];
        self.sj = [decoder decodeObjectForKey:@"sj"];
        self.loginText = [decoder decodeObjectForKey:@"loginText"];
        self.seachText = [decoder decodeObjectForKey:@"seachText"];
        self.addFriendText = [decoder decodeObjectForKey:@"addFriendText"];
    }
    return self;
    
}


@end
