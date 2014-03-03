//
//  ApplyFriend.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-23.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyFriend : NSObject
{
    int _Id;
    int _applyId;
    int _friendId;
    NSString *_message;
    NSString *_date;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,assign)int applyId;
@property(nonatomic,assign)int friendId;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *date;

@end
