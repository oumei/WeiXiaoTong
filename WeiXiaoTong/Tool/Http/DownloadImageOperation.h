//
//  DownloadImageOperation.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-21.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadImageOperation : NSOperation
{
    id _target;
    SEL _action;
    NSString *_url;
}
@property(nonatomic,strong)id target;
@property(nonatomic,assign)SEL action;
@property(nonatomic,copy)NSString *url;
- (id)initWithTarget:(id)aTarget selector:(SEL)aAction url:(NSString *)url;

@end
