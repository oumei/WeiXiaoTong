//
//  HttpService.h
//  HWSDK
//
//  Created by Carl on 13-11-28.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "AFHttp.h"

@interface HttpService : AFHttp

+ (HttpService *)sharedInstance;

- (void)postRequestWithUrl:(NSString *)url params:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

@end
