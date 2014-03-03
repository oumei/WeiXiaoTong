//
//  UIImageView+downLoadImage.h
//  UI_Thread
//
//  Created by 5000 on 13-8-28.
//  Copyright (c) 2013年 5000. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (downLoadImage)

-(void)imageURL:(NSString *)aURL withQueue:(NSOperationQueue *)aQueue;

@end
