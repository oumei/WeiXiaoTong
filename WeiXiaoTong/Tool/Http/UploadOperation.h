//
//  UploadOperation.h
//  te
//
//  Created by 李世明 on 14-3-19.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadOperation : NSOperation
{
    id _target;
    SEL _action;
    NSString *_url;
    UIImage *_image;
//    NSLock *lock;
}
@property(nonatomic,strong)id target;
@property(nonatomic,assign)SEL action;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,retain)UIImage *image;
- (id)initWithTarget:(id)aTarget selector:(SEL)aAction url:(NSString *)url image:(UIImage *)image;

@end
