//
//  UploadOperation.m
//  te
//
//  Created by 李世明 on 14-3-19.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "UploadOperation.h"

@implementation UploadOperation
@synthesize target = _target;
@synthesize action = _action;
@synthesize image = _image;
@synthesize url = _url;

- (id)initWithTarget:(id)aTarget selector:(SEL)aAction url:(NSString *)url image:(UIImage *)image
{
    if (self = [super init])
    {
        self.target = aTarget;
        self.action = aAction;
        self.url = url;
        self.image = image;
    }
    return self;
}

- (void)main
{
    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1000];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data

    NSData *data = UIImageJPEGRepresentation(self.image,1.0);
//    NSLog(@"1=%d",data.length);
    CGFloat max = 1024 * 300;
    CGFloat oneM = 1024 * 1000;
    CGFloat length = data.length;
    if ( length > max) {
        if (length > oneM) {
            CGFloat f = max/length;
//            NSLog(@"%f",f);
            data = UIImageJPEGRepresentation(self.image, f);
        }else{
            data = UIImageJPEGRepresentation(self.image, 0.75);
        }
    }
//    NSLog(@"2=%d",data.length);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"boris.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/jpg\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *resp = nil;
    NSError *error = nil;
    NSData *reqData = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&error];
    NSString *req = [[NSString alloc]initWithData:reqData encoding:NSUTF8StringEncoding];
    NSLog(@"errorreq=%@",req);
    if (self.target != nil)
    {
        [self.target performSelectorOnMainThread:self.action withObject:reqData waitUntilDone:NO];
    }
}

- (void)dealloc
{
    self.url = nil;
    self.image = nil;
    self.target = nil;
}


@end
