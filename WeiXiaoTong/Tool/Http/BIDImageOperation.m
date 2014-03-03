//
//  BIDImageOperation.m
//  UI_Thread
//
//  Created by 5000 on 13-8-28.
//  Copyright (c) 2013年 5000. All rights reserved.
//

#import "BIDImageOperation.h"

@implementation BIDImageOperation
@synthesize url = _url;
@synthesize target = _target;
@synthesize action = _action;
@synthesize localPath = _localPath;

-(id)initWithTarget:(id)aTarget Action:(SEL)aSelector Url:(NSString *)aURL ToPath:(NSString *)aLocalPath
{
    if (self = [super init]) {
        self.target = aTarget;
        self.action = aSelector;
        self.url = aURL;
        self.localPath = aLocalPath;
    }
    return self;
}

-(void)dealloc
{
    _url = nil;
    _localPath = nil;
}

-(void)main
{
    if ([self isCancelled]) {
        return;
    }
    NSURL *imageURL = [NSURL URLWithString:_url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    
    // 写入本地
    [imageData writeToFile:_localPath atomically:YES];
    
    UIImage *img = [UIImage imageWithData:imageData];
    
    if ([self isCancelled]) {
        return;
    }
    
    [self.target performSelectorOnMainThread:self.action withObject:img waitUntilDone:NO];
}

@end
