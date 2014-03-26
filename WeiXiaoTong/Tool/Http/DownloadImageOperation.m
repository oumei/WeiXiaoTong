//
//  DownloadImageOperation.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-21.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "DownloadImageOperation.h"

@implementation DownloadImageOperation
@synthesize target = _target;
@synthesize action = _action;
@synthesize url = _url;


- (id)initWithTarget:(id)aTarget selector:(SEL)aAction url:(NSString *)url
{
    if (self = [super init])
    {
        self.target = aTarget;
        self.action = aAction;
        self.url = url;
    }
    return self;
}

-(void)main
{
    if ([self isCancelled]) {
        return;
    }
    NSURL *imageURL = [NSURL URLWithString:self.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    if ([self isCancelled]) {
        return;
    }
    
    [self.target performSelectorOnMainThread:self.action withObject:imageData waitUntilDone:NO];
}


- (void)dealloc
{
    self.url = nil;
    self.target = nil;
}
@end
