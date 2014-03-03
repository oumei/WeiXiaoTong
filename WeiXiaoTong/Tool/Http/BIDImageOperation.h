//
//  BIDImageOperation.h
//  UI_Thread
//
//  Created by 5000 on 13-8-28.
//  Copyright (c) 2013年 5000. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BIDImageOperation : NSOperation
{
    NSString *_url;
    id _target;
    SEL _action;
    NSString *_localPath;
}

@property (copy,nonatomic) NSString *url;
@property (retain,nonatomic) id target;
@property (assign,nonatomic) SEL action;
@property (copy,nonatomic) NSString *localPath;

-(id)initWithTarget:(id)aTarget Action:(SEL)aSelector Url:(NSString *)aURL ToPath:(NSString *)aLocalPath;

@end
