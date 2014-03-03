//
//  ResultModel.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-23.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultModel : NSObject
{
    NSString *_ovo;
    NSString *_baseData;
}
@property(nonatomic,copy)NSString *ovo;
@property(nonatomic,copy)NSString *baseData;
@end
