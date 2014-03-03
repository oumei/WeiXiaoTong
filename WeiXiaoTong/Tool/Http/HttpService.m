//
//  HttpService.m
//  HWSDK
//
//  Created by Carl on 13-11-28.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "HttpService.h"
#import "JSON.h"

@implementation HttpService

#pragma mark Life Cycle
- (id)init
{
    if ((self = [super init])) {
        
    }
    return  self;
}

#pragma mark Class Method
+ (HttpService *)sharedInstance
{
    static HttpService * this = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[self alloc] init];
    });
    return this;
}

#pragma mark Instance Method
- (void)postRequestWithUrl:(NSString *)url params:(NSDictionary *)params completionBlock:(void (^)(id))success failureBlock:(void (^)(NSError *, NSString *))failure
{

    //@"http://115.28.17.18:8080/service/interface.do"
    //@"http://192.168.1.101:8080/service/interface.do"
    [self post:url withParams:params completionBlock:^(id obj) {
        //NSDictionary *dic=[obj JSONValue];
        NSLog(@"dic= %@",obj);
        
        success(obj);
    } failureBlock:failure];
}




@end
