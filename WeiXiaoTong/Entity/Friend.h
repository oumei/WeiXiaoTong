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
    NSString *_uname;
//    int _qx;
//    int _xzCount;
    NSString *_addTime;
    NSString *_description;
    NSString *_fname;
    NSString *_remark;
    int _fid;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,copy)NSString *uname;
@property(nonatomic,copy)NSString *addTime;
@property(nonatomic,copy)NSString *description;
@property(nonatomic,copy)NSString *fname;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,assign)int fid;
//@property(nonatomic,assign)int qx;
//@property(nonatomic,assign)int xzCount;



@end
