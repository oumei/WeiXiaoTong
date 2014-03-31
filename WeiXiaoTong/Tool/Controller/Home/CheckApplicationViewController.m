//
//  CheckApplicationViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-4.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CheckApplicationViewController.h"
#import "ApplyFriend.h"
#import "HttpService.h"
#import "UserEntity.h"
#import "JSON.h"
#import "ObjectVo.h"
#import "ResultsModel.h"
#include <objc/runtime.h>

@interface CheckApplicationViewController ()

@end

@implementation CheckApplicationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil afs:(NSMutableArray *)afs
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.afs = afs;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - tableview delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.afs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"checkApplicationCell";
    CheckApplicationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CheckApplicationCell" owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    ApplyFriend *af = [self.afs objectAtIndex:indexPath.row];
    cell.userName.text = af.fname;
    cell.validationMsg.text = [NSString stringWithFormat:@"验证消息：%@",af.message];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[af.date floatValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    cell.time.text = [NSString stringWithFormat:@"时间：%@",[formatter stringFromDate:date]];
    formatter = nil;
    date = nil;
    return cell;
}

#pragma mark - checkApplication delegate -
- (void)refuse:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    [self.view showWithType:0 Title:@"正在拒绝好友请求..."];
    ApplyFriend *af = [self.afs objectAtIndex:indexPath.row];
    UserEntity *ue = [UserEntity shareCurrentUe];
    ObjectVo *ob= [ObjectVo shareCurrentObjectVo];
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": DECLINE_FRIEND,@"afid":[NSString stringWithFormat:@"%d",af.Id],@"uname":ue.userName,@"uuid":ue.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
        ResultsModel *result = [[ResultsModel alloc]init];
        NSArray *properties = [self properties_aps:[ResultsModel class] objc:result];
        for (NSString *resultKey in [object allKeys]) {
            for (NSString *proKey in properties) {
                if ([resultKey isEqualToString:proKey]) {
                    [result setValue:[object valueForKey:resultKey] forKey:resultKey];
                }
            }
        }
        if (result.msg) {
            [self.view endSynRequestSignal];
            [self.view LabelTitle:[object valueForKey:@"msg"]];
            return;
        }
        if (result.baseData) {
            ob.baseData = [[object valueForKey:@"baseData"] JSONValue];
            [ObjectVo clearCurrentObjectVo];
            // 将个人信息全部持久化到documents中，可通过objectVo的单例获取登录了的用户的个人信息
            NSMutableData *mData = [[NSMutableData alloc]init];
            NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
            [archiver encodeObject:ob forKey:@"objectVoInfo"];
            [archiver finishEncoding];
            NSString *objectVoInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/objectVoInfo.txt"];
            [mData writeToFile:objectVoInfoPath atomically:YES];
            mData = nil;
            
        }

        NSString *ovo = [object valueForKey:@"ovo"];
        NSDictionary *ovoDic = [ovo JSONValue];
        if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
            NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:self.afs];
            [arr removeObjectAtIndex:indexPath.row];
            self.afs = arr;
            [self.table reloadData];
            [self.view endSynRequestSignal];
            arr = nil;
            
            [self.view LabelTitle:@"操作成功"];
            
        }else{
            [self.view endSynRequestSignal];
            [self.view LabelTitle:[ovoDic valueForKey:@"msg"]];
        }

    } failureBlock:^(NSError *error, NSString *responseString) {
        [self.view endSynRequestSignal];
    }];
}

- (void)agree:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    [self.view showWithType:0 Title:@"正在同意好友请求..."];
    ApplyFriend *af = [self.afs objectAtIndex:indexPath.row];
    UserEntity *ue = [UserEntity shareCurrentUe];
    ObjectVo *ob= [ObjectVo shareCurrentObjectVo];
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": ALLOW_FRIEND,@"afid":[NSString stringWithFormat:@"%d",af.Id],@"uname":ue.userName,@"uuid":ue.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
        NSLog(@"ob = %@",object);
        NSString *ovo = [object valueForKey:@"ovo"];
        NSDictionary *ovoDic = [ovo JSONValue];
        if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
            NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:self.afs];
            [arr removeObjectAtIndex:indexPath.row];
            self.afs = arr;
            [self.table reloadData];
            [self.view endSynRequestSignal];
            arr = nil;
            
            [self.view LabelTitle:@"操作成功"];
            
        }else{
            [self.view endSynRequestSignal];
            [self.view LabelTitle:[ovoDic valueForKey:@"msg"]];
        }
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [self.view endSynRequestSignal];
    }];

}

//- (void)reloadTableData:(NSIndexPath *)indexPath
//{
//    
//}

//遍历类属性
- (NSMutableArray *)properties_aps:(Class)aClass objc:(id)aObjc
{
    //NSMutableDictionary *props = [NSMutableDictionary dictionary];
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(aClass, &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
        //        id propertyValue = [aObjc valueForKey:(NSString *)propertyName];
        //        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
