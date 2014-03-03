//
//  ShoesHeelSize.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-23.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoesHeelSize : NSObject
{
    int _Id;
    NSString *_name;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,copy)NSString *name;
@end
