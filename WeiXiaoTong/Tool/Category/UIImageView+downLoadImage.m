//
//  UIImageView+downLoadImage.m
//  UI_Thread
//
//  Created by 5000 on 13-8-28.
//  Copyright (c) 2013年 5000. All rights reserved.
//

#import "UIImageView+downLoadImage.h"
#import "BIDImageOperation.h"

@implementation UIImageView (downLoadImage)

-(void)imageURL:(NSString *)aURL withQueue:(NSOperationQueue *)aQueue
{
    NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache"];
    NSString *fileName = [aURL lastPathComponent];
    NSString *localImagePath = [documentPath stringByAppendingPathComponent:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    BIDImageOperation *op = [[BIDImageOperation alloc] initWithTarget:self Action:@selector(setImage:) Url:aURL ToPath:localImagePath];
    [aQueue addOperation:op];

//    if (![fm fileExistsAtPath:documentPath]) {
//        [fm createDirectoryAtPath:documentPath withIntermediateDirectories:NO attributes:nil error:nil];
//    } 
//    
//    if ([fm fileExistsAtPath:localImagePath]) {
//        UIImage *img = [UIImage imageWithContentsOfFile:localImagePath];
//        self.image = img;
//        return;
//    } else {
//        BIDImageOperation *op = [[BIDImageOperation alloc] initWithTarget:self Action:@selector(setImage:) Url:aURL ToPath:localImagePath];
//        [aQueue addOperation:op];
//    }
}

@end
