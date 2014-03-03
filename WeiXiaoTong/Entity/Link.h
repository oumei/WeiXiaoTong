//
//  Link.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-23.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Link : NSObject
{
    int _Id;
    NSString *_name;
    NSString *_link;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *link;
@end
