//
//  ResultsModel.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-26.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultsModel : NSObject
{
    NSDictionary *_ovo;
    NSDictionary *_baseData;
    NSString *_msg;
}
@property (copy,nonatomic)NSString *msg;
@property (copy,nonatomic)NSDictionary *ovo;
@property (copy,nonatomic)NSDictionary *baseData;
@end
