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
    [self saveTheImage:[UIImage imageWithData:imageData]];
//    NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache"];
//    NSString *fileName = self.file;
//    NSString *localImagePath = [documentPath stringByAppendingPathComponent:fileName];
//    NSFileManager *fm = [NSFileManager defaultManager];
//    if (![fm fileExistsAtPath:documentPath]) {
//        [fm createDirectoryAtPath:documentPath withIntermediateDirectories:NO attributes:nil error:nil];
//    }
//    // 写入本地
//    [imageData writeToFile:localImagePath atomically:YES];
    
    if ([self isCancelled]) {
        return;
    }
    
    [self.target performSelectorOnMainThread:self.action withObject:imageData waitUntilDone:NO];
}

#pragma mark - 保存拍摄的图片
- (void)saveTheImage:(UIImage *)image {
    //将图片存储到系统相册
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
//        [Tools showMessage:msg :nil :1.0f];
    }
    else {
        msg = @"保存图片成功" ;
    }
    NSLog(@"msg= %@",msg);
}



- (void)dealloc
{
    self.url = nil;
    self.target = nil;
}
@end
