//
//  Friend.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-23.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject
{
    int _Id;
    NSString *_userName;
    int _qx;
    int _xzCount;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,assign)int qx;
@property(nonatomic,assign)int xzCount;

@end
