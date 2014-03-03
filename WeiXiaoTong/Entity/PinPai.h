//
//  PinPai.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-23.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinPai : NSObject
{
    int _Id;
    NSString *_cname;
    NSString *_ename;
    NSString *_pic;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,copy)NSString *cname;
@property(nonatomic,copy)NSString *ename;
@property(nonatomic,copy)NSString *pic;
@end
