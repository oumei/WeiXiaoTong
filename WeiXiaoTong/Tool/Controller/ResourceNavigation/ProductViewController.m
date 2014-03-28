//
//  ProductViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-27.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "ProductViewController.h"
#import "HttpService.h"
#import "JSON.h"
#import "ChanPin.h"
#import "UIImageView+WebCache.h"
#import "UserEntity.h"
#import "ObjectVo.h"
#import "DownloadImageOperation.h"
#include<objc/runtime.h>
#import "Reachability.h"
#import "ResultsModel.h"


@interface ProductViewController ()

@end

@implementation ProductViewController
static int page = 1;
static int progressNum = 0;
static int pn = 0;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cpsArr:(NSMutableArray *)cps
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.cpsArr = cps;
        self.cpsArr = [NSMutableArray arrayWithArray:cps];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.cpsArr.count >= 50) {
        UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        UIButton *downMore = [UIButton buttonWithType:UIButtonTypeCustom];
        downMore.frame = CGRectMake(2, 2, 316, 46);
        [downMore setTitle:@"点击获取更多数据" forState:0];
        [downMore setTitleColor:[UIColor blackColor] forState:0];
        [downMore setBackgroundImage:[UIImage imageNamed:@"list_bg.png"] forState:0];
        [downMore addTarget:self action:@selector(downMoreData:) forControlEvents:UIControlEventTouchUpInside];
        [footview addSubview:downMore];
        self.table.tableFooterView = footview;
        downMore = nil;
        footview = nil;
    }
    
    [self.table reloadData];
}

- (void)downMoreData:(id)sender
{
    UserEntity *user = [UserEntity shareCurrentUe];
    [self.view showWithType:0 Title:@"正在加载..."];
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    if (self.title == nil) {
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_CHANPIN,@"page": [NSString stringWithFormat:@"%d",page],@"lx":self.lx,@"xb": self.xb,@"pp": @"-1",@"text": self.text,@"uname": user.userName,@"uuid": user.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
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
                ob.baseData = [object valueForKey:@"baseData"];
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
            NSDictionary *objectVoDic = [ovo JSONValue];
            NSMutableArray *cpsArr = [[NSMutableArray alloc]initWithArray:self.cpsArr];
            NSString *code = [objectVoDic valueForKey:@"code"];
            if ([code intValue] == 0) {
                NSArray *arr = [objectVoDic valueForKey:@"cps"];
                if (arr.count < 50) {
                    self.table.tableFooterView = nil;
                }
                for (int i = 0; i < arr.count; i++) {
                    NSDictionary *dic = [arr objectAtIndex:i];
                    ChanPin *chanpin = [[ChanPin alloc]init];
                    for (NSString *key in dic) {
                        NSArray *cpArr = [self properties_aps:[ChanPin class] objc:chanpin];
                        for (NSString *k in cpArr) {
                            if ([key isEqualToString:k]) {
                                [chanpin setValue:[dic valueForKey:key] forKey:key];
                            }
                            if ([key isEqualToString:@"id"]) {
                                [chanpin setValue:[dic valueForKey:key] forKey:@"Id"];
                                break;
                            }
                        }
                    }
                    [cpsArr addObject:chanpin];
                    chanpin = nil;
                }
                page++;
                self.cpsArr = nil;
                self.cpsArr = cpsArr;
                [self.view endSynRequestSignal];
                if (arr.count == 0) {
                    [self.view LabelTitle:@"没有更多数据"];
                }
                [self.table reloadData];
            }else{
                [self.view endSynRequestSignal];
                [self.view LabelTitle:[objectVoDic valueForKey:@"msg"]];
            }
        } failureBlock:^(NSError *error, NSString *responseString) {
            [self.view endSynRequestSignal];
        }];
    }else if (self.isSelf != nil && self.title == nil){
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_CHANPIN,@"page": [NSString stringWithFormat:@"%d",page],@"lx":self.lx,@"xb": self.xb,@"pp": @"-1",@"text": self.text,@"isSelf": @"1",@"uname": user.userName,@"uuid": user.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
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
                ob.baseData = [object valueForKey:@"baseData"];
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
            NSDictionary *objectVoDic = [ovo JSONValue];
            NSMutableArray *cpsArr = [[NSMutableArray alloc]initWithArray:self.cpsArr];
            NSString *code = [objectVoDic valueForKey:@"code"];
            if ([code intValue] == 0) {
                NSArray *arr = [objectVoDic valueForKey:@"cps"];
                if (arr.count < 50) {
                    self.table.tableFooterView = nil;
                }
                for (int i = 0; i < arr.count; i++) {
                    NSDictionary *dic = [arr objectAtIndex:i];
                    ChanPin *chanpin = [[ChanPin alloc]init];
                    for (NSString *key in dic) {
                        NSArray *cpArr = [self properties_aps:[ChanPin class] objc:chanpin];
                        for (NSString *k in cpArr) {
                            if ([key isEqualToString:k]) {
                                [chanpin setValue:[dic valueForKey:key] forKey:key];
                            }
                            if ([key isEqualToString:@"id"]) {
                                [chanpin setValue:[dic valueForKey:key] forKey:@"Id"];
                                break;
                            }
                        }
                    }
                    [cpsArr addObject:chanpin];
                    chanpin = nil;
                }
                page++;
                self.cpsArr = nil;
                self.cpsArr = cpsArr;
                [self.view endSynRequestSignal];
                if (arr.count == 0) {
                    [self.view LabelTitle:@"没有更多数据"];
                }
                [self.table reloadData];
            }else{
                [self.view endSynRequestSignal];
                [self.view LabelTitle:[objectVoDic valueForKey:@"msg"]];
            }
            
        } failureBlock:^(NSError *error, NSString *responseString) {
            [self.view endSynRequestSignal];
        }];
    }else{
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_CHANPIN_BY_DANGKOU,@"page":[NSString stringWithFormat:@"%d",page],@"dangkou":self.title,@"uname": user.userName,@"uuid": user.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
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
                ob.baseData = [object valueForKey:@"baseData"];
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
            NSDictionary *ovoDic = [[object valueForKey:@"ovo"] JSONValue];
            if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
                NSMutableArray *cpsArr = [[NSMutableArray alloc]initWithArray:self.cpsArr];
                NSArray *arr = [[NSArray alloc]init];
                arr = [ovoDic valueForKey:@"cps"];
                if (arr.count < 50) {
                    self.table.tableFooterView = nil;
                }
                for (int i = 0; i < arr.count; i++) {
                    ChanPin *chanPin = [[ChanPin alloc]init];
                    for (NSString *key in [[arr objectAtIndex:i] allKeys]) {
                        NSArray *cpArr = [self properties_aps:[ChanPin class] objc:chanPin];
                        for (NSString *k in cpArr) {
                            if ([key isEqualToString:k]) {
                                [chanPin setValue:[[arr objectAtIndex:i] valueForKey:key] forKey:key];
                            }
                            if ([key isEqualToString:@"id"]) {
                                [chanPin setValue:[[arr objectAtIndex:i] valueForKey:key] forKey:@"Id"];
                                break;
                            }
                        } 
                    }
                    [cpsArr addObject:chanPin];
                    chanPin = nil;
                    
                }
                page++;
                self.cpsArr = nil;
                self.cpsArr = cpsArr;
                cpsArr = nil;
                arr = nil;
                if (arr.count == 0) {
                    [self.view LabelTitle:@"没有更多数据"];
                }
                [self.view endSynRequestSignal];
                [self.table reloadData];
            }else{
                [self.view endSynRequestSignal];
                [self.view LabelTitle:[ovoDic valueForKey:@"msg"]];
            }
        } failureBlock:^(NSError *error, NSString *responseString) {
            [self.view endSynRequestSignal];
        }];
    }
}

#pragma mark - tableview delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cpsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserEntity *user = [UserEntity shareCurrentUe];
    static NSString *identifier = @"productCell";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell= (ProductCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"ProductCell" owner:self options:nil]  lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    ChanPin *chanPin = [self.cpsArr objectAtIndex:indexPath.row];
    cell.image.clipsToBounds = YES;
    cell.image.contentMode = UIViewContentModeScaleAspectFill;
    if (chanPin.address) {
        cell.name.hidden = YES;
        [cell.image setImageWithURL:[NSURL URLWithString:IMAGE_URL(chanPin.address)]];
    }else{
        NSString *str = [NSString stringWithFormat:@"%d",chanPin.Id];
        [cell.image setImageWithURL:[NSURL URLWithString:IMAGE_URL(str)]];
    }
    cell.nameWeb.opaque = NO;
    cell.serviceWeb.opaque = NO;
    cell.nameWeb.scrollView.bounces = NO;
    cell.serviceWeb.scrollView.bounces = NO;
    [cell.nameWeb loadHTMLString:chanPin.title baseURL:[[NSBundle mainBundle] bundleURL]];
    [cell.serviceWeb loadHTMLString:chanPin.attrebute baseURL:[[NSBundle mainBundle] bundleURL]];
    cell.describe.text = chanPin.miaoshu;
    cell.serialNum.text = [NSString stringWithFormat:@"编号：%d",chanPin.Id];
    cell.time.text = [NSString stringWithFormat:@"日期：%@",[chanPin.shijian substringToIndex:10]];
    [cell.collection setTitle:@"收藏" forState:0];

    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *upload_id = [NSString stringWithFormat:@"%d_%d",chanPin.upload,chanPin.Id];
    if ([fm fileExistsAtPath:[self docPath]]) {
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:[self docPath]];
        for (int i = 0; i < arr.count; i++) {
            NSString *str = [arr objectAtIndex:i];
            if ([str isEqualToString:upload_id]) {
                [cell.collection setTitle:@"已收藏" forState:0];
                break;
            }
        }
    }
    if (user.Id == chanPin.upload) {
        [cell.collection setTitle:@"改价" forState:0];
    }
    if ([fm fileExistsAtPath:[self sharePath]]) {
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:[self sharePath]];
        for (int i = 0; i < arr.count; i++) {
            NSString *str = [arr objectAtIndex:i];
            if ([str isEqualToString:upload_id]) {
                [cell.nameWeb loadHTMLString:[NSString stringWithFormat:@"<font color=#ff0000>%@</font>",chanPin.title] baseURL:[[NSBundle mainBundle] bundleURL]];
                break;
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable && [Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable)
    {
        [self.view LabelTitle:@"无网络连接！"];
        return;
    }
    UserEntity *ue = [UserEntity shareCurrentUe];
    ChanPin *chanPin = [self.cpsArr objectAtIndex:indexPath.row];
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    _spinner = [self.view showSpinner:0 Title:[NSString stringWithFormat:@"正在下载 0/%d",chanPin.pics]];
//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSString *upload_id = [NSString stringWithFormat:@"%d_%d",chanPin.upload,chanPin.Id];
//    if ([fm fileExistsAtPath:[self sharePath]]) {
//        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:[self sharePath]];
//        for (int i = 0; i < arr.count; i++) {
//            NSString *str = [arr objectAtIndex:i];
//            if ([str isEqualToString:upload_id]) {
//                _spinner.text = [NSString stringWithFormat:@"正在下载 %d/%d",self.imageCount,self.imageCount];
//                [self.view endSynRequestSignal];
//                [WXApi openWXApp];
//                ProductCell *cell = (ProductCell *)[self.table cellForRowAtIndexPath:indexPath];
//                [cell.nameWeb loadHTMLString:[NSString stringWithFormat:@"<font color=#ff0000>%@</font>",chanPin.title] baseURL:[[NSBundle mainBundle] bundleURL]];
//                return;
//            }
//        }
//    }
    
    shareIndexPath = indexPath;
    
    self.imageCount = chanPin.pics;
    NSLog(@"pics = %d",chanPin.pics);
    if (chanPin.pics > 0) {
        
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": DOWNLOAD,@"cpid": [NSString stringWithFormat:@"%d",chanPin.Id],@"uname":ue.userName,@"uuid":ue.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
            ResultsModel *results = [[ResultsModel alloc]init];
            for (NSString *obkey in [object allKeys]) {
                NSArray *res = [self properties_aps:[ResultsModel class] objc:results];
                for (NSString *rekey in res) {
                    if ([obkey isEqualToString:rekey]) {
                        [results setValue:[object valueForKey:obkey] forKey:obkey];
                    }
                }
            }
            if (results.msg) {
                [self.view endSynRequestSignal];
                [self.view LabelTitle:results.msg];
            }else{
                
                NSDictionary *ovoDic = [[object valueForKey:@"ovo"] JSONValue];
                if ([[ovoDic valueForKey:@"code"] intValue] == 0){
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = chanPin.miaoshu;
                    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
                    for (int i = 0; i < chanPin.pics; i++) {
                        NSString *url;
                        if (chanPin.address) {
                            NSFileManager *fm = [NSFileManager defaultManager];
                            NSString *syStr = [NSString stringWithFormat:@"&syStr=%d-%d",ue.tableName,chanPin.Id];
                            if ([fm fileExistsAtPath:[self syPath]]){
                                NSString *sy = [NSString stringWithContentsOfFile:[self syPath] encoding:4 error:nil];
                                if ([sy isEqualToString:@"sy=1"]){
                                    url = IMAGE_URL_ADDRESS_SY(chanPin.address, i,syStr);
                                }else{
                                    url = IMAGE_URL_ADDRESS(chanPin.address, i,syStr);
                                }
                            }else{
                                url = IMAGE_URL_ADDRESS(chanPin.address, i,syStr);
                            }
                        }else{
                            NSString *str = [NSString stringWithFormat:@"%d",chanPin.Id];
                            NSFileManager *fm = [NSFileManager defaultManager];
                            if ([fm fileExistsAtPath:[self syPath]]){
                                NSString *sy = [NSString stringWithContentsOfFile:[self syPath] encoding:4 error:nil];
                                if ([sy isEqualToString:@"sy=1"]){
                                    url = IMAGE_URL_ADDRESS_SY(str, i,@"");
                                }else{
                                    url = IMAGE_URL_ADDRESS(str, i,@"");
                                }
                            }else{
                                url = IMAGE_URL_ADDRESS(str, i,@"");
                            }
                        }
                        DownloadImageOperation *operation = [[DownloadImageOperation alloc]initWithTarget:self selector:@selector(shareAction:) url:url];
                        [queue addOperation:operation];
                        operation = nil;
                        
                    }
                    queue = nil;
                }
                if (results.baseData) {
                    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
                    ob.baseData = results.baseData;
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
            }
        } failureBlock:^(NSError *error, NSString *responseString) {
            [self.view endSynRequestSignal];
        }];
        
    }else{
        [self.view endSynRequestSignal];
        [self.view LabelTitle:@"无图片分享！"];
    }
}

- (void)shareAction:(NSData *)data
{
    if (data) {
        progressNum = progressNum + 1;
        _spinner.text = [NSString stringWithFormat:@"正在下载 %d/%d",progressNum,self.imageCount];
        [self performSelectorOnMainThread:@selector(saveTheImage:) withObject:[UIImage imageWithData:data] waitUntilDone:NO];
    }else{
        progressNum = 0;
        [self.view endSynRequestSignal];
        [self.view LabelTitle:@"图片下载失败"];
    }
    if (progressNum == self.imageCount) {
        progressNum = 0;
        //[self.view endSynRequestSignal];
    }
}

#pragma mark - 保存拍摄的图片
- (void)saveTheImage:(UIImage *)image {
    //将图片存储到系统相册
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
        NSLog(@"msg= %@",error.description);
        [self performSelectorOnMainThread:@selector(saveTheImage:) withObject:image waitUntilDone:NO];
    }
    else {
        pn = pn + 1;
        msg = @"保存图片成功" ;
        NSLog(@"msg= %@",msg);
        if (pn == self.imageCount) {
            ChanPin *chanPin = [self.cpsArr objectAtIndex:shareIndexPath.row];
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:[self sharePath]]) {
                NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:[self sharePath]];
                [arr addObject:[NSString stringWithFormat:@"%d_%d",chanPin.upload,chanPin.Id]];
                [arr writeToFile:[self sharePath] atomically:YES];
            }else{
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                [arr addObject:[NSString stringWithFormat:@"%d_%d",chanPin.upload,chanPin.Id]];
                [arr writeToFile:[self sharePath] atomically:YES];
            }
            ProductCell *cell = (ProductCell *)[self.table cellForRowAtIndexPath:shareIndexPath];
            [cell.nameWeb loadHTMLString:[NSString stringWithFormat:@"<font color=#ff0000>%@</font>",chanPin.title] baseURL:[[NSBundle mainBundle] bundleURL]];
            [WXApi openWXApp];
            [self.view endSynRequestSignal];
            progressNum = 0;
            pn = 0;
        }
    }
    
}

-(NSString *)docPath
{
    NSString *homePath=NSHomeDirectory();
    homePath=[homePath stringByAppendingPathComponent:@"Documents/chanpinID.txt"];
    return homePath;
}

-(NSString *)syPath
{
    NSString *homePath=NSHomeDirectory();
    homePath=[homePath stringByAppendingPathComponent:@"Documents/sy.txt"];
    return homePath;
}

-(NSString *)sharePath
{
    NSString *homePath=NSHomeDirectory();
    homePath=[homePath stringByAppendingPathComponent:@"Documents/shareChanpin.txt"];
    return homePath;
}

#pragma mark - ProductCellDelegate -
- (void)checkDetail:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    ChanPin *chanPin = [self.cpsArr objectAtIndex:indexPath.row];
    DetailsViewController *detailsViewController = [[DetailsViewController alloc]initWithNibName:@"DetailsViewController" bundle:nil chanPin:chanPin];
    detailsViewController.delegate = self;
    [detailsViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailsViewController animated:YES];
    detailsViewController = nil;
    chanPin = nil;
}

- (void)deleteChanpin:(ChanPin *)chanpin
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.cpsArr.count; i++) {
        ChanPin *cp = [self.cpsArr objectAtIndex:i];
        if (cp.Id == chanpin.Id) {
            //
        }else{
            [arr addObject:cp];
        }
    }
    self.cpsArr = arr;
    [self.table reloadData];
    arr = nil;
}

- (void)collection:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    ProductCell *cell = (ProductCell *)[self.table cellForRowAtIndexPath:indexPath];
    targetIndexPath = indexPath;
    
    if ([cell.collection.titleLabel.text isEqualToString:@"已收藏"]) {
        [self.view LabelTitle:@"已收藏"];
    }else{
        [self label:@"输入代理价格"];
    }
}

- (void)dangkou:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    UserEntity *user = [UserEntity shareCurrentUe];
    ChanPin *chanPin = [self.cpsArr objectAtIndex:indexPath.row];
    [self.view showWithType:0 Title:@"正在获取商品列表..."];
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_CHANPIN_BY_DANGKOU,@"page":@"0",@"dangkou":chanPin.dangkou,@"uname": user.userName,@"uuid": user.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
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
            ob.baseData = [object valueForKey:@"baseData"];
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
        NSDictionary *ovoDic = [[object valueForKey:@"ovo"] JSONValue];
        if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
            [self.view endSynRequestSignal];
            NSMutableArray *cpsArr = [[NSMutableArray alloc]init];
            NSArray *arr = [[NSArray alloc]init];
            arr = [ovoDic valueForKey:@"cps"];
            for (int i = 0; i < arr.count; i++) {
                ChanPin *chanPin = [[ChanPin alloc]init];
                for (NSString *key in [[arr objectAtIndex:i] allKeys]) {
                    NSArray *cpArr = [self properties_aps:[ChanPin class] objc:chanPin];
                    for (NSString *k in cpArr) {
                        if ([key isEqualToString:k]) {
                            [chanPin setValue:[[arr objectAtIndex:i] valueForKey:key] forKey:key];
                        }
                        if ([key isEqualToString:@"id"]) {
                            [chanPin setValue:[[arr objectAtIndex:i] valueForKey:key] forKey:@"Id"];
                            break;
                        }
                    }
                }
                [cpsArr addObject:chanPin];
                chanPin = nil;
            }
            
            if (cpsArr.count > 0) {
                ProductViewController *productViewController = [[ProductViewController alloc]initWithNibName:@"ProductViewController" bundle:nil cpsArr:cpsArr];
                productViewController.title = chanPin.dangkou;
                [productViewController setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:productViewController animated:YES];
                productViewController = nil;
            }else{
                [self.view LabelTitle:@"暂无数据"];
            }
            cpsArr = nil;
            arr = nil;
        }
        [self.view endSynRequestSignal];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [self.view endSynRequestSignal];
    }];

}

#pragma mark - 收藏 －
- (void)label:(NSString *)title
{
    alertView.hidden = NO;
    alertView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    alertView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_transparent.png"]];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(20, 70, 280, 120)];
    backgroundView.layer.borderWidth = 1.0;
    backgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backgroundView.layer.cornerRadius = 6.0;
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    image.image = [UIImage imageNamed:@"ic_launcher.png"];
    [backgroundView addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 220, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blueColor];
    label.text = title;
    [backgroundView addSubview:label];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 280, 1)];
    line.backgroundColor = [UIColor blueColor];
    [backgroundView addSubview:line];
    
    textMsg = [[UITextField alloc]initWithFrame:CGRectMake(15, 50, 250, 30)];
    textMsg.backgroundColor = [UIColor clearColor];
    textMsg.delegate = self;
    textMsg.placeholder = @"请输入...";
    [backgroundView addSubview:textMsg];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 85, 280, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:line2];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.backgroundColor = [UIColor clearColor];
    cancel.frame = CGRectMake(0, 90, 140, 30);
    [cancel setTitle:@"取消" forState:0];
    cancel.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancel setTitleColor:[UIColor blackColor] forState:0];
    [cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:cancel];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(140, 85, 1, 35)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:line3];
    
    UIButton *modify = [UIButton buttonWithType:UIButtonTypeCustom];
    modify.backgroundColor = [UIColor clearColor];
    modify.frame = CGRectMake(141, 90, 139, 30);
    [modify setTitle:@"确定" forState:0];
    modify.titleLabel.font = [UIFont systemFontOfSize:14];
    [modify setTitleColor:[UIColor blackColor] forState:0];
    [modify addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:modify];
    
    [alertView addSubview:backgroundView];
    [self.view addSubview:alertView];
    [self.view bringSubviewToFront:alertView];
    
    backgroundView = nil;
    image = nil;
    label = nil;
    line = nil;
    line2 = nil;
    line3 = nil;
    cancel = nil;
    modify = nil;
}

- (void)cancelAction:(UIButton *)sender
{
    [self textFieldShouldReturn:textMsg];
    alertView.hidden = YES;
    textMsg.text = nil;
    alertView = nil;
}

- (void)modifyAction:(UIButton *)sender
{
    alertView.hidden = YES;
    [self textFieldShouldReturn:textMsg];
    if ([textMsg.text stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length >0) {
        [self.view LabelTitle:@"请输入纯数字"];
        textMsg = nil;
        alertView = nil;
        return;
    }
    ChanPin *chanPin = [self.cpsArr objectAtIndex:targetIndexPath.row];
    UserEntity *user = [UserEntity shareCurrentUe];
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    if (chanPin.upload == user.Id) {
        [self.view showWithType:0 Title:@"正在修改价格..."];
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": UPDATE_SELF_CHANPIN_PRICE,@"cpid": [NSString stringWithFormat:@"%d",chanPin.Id],@"price": [NSString stringWithFormat:@"%d",[textMsg.text intValue]],@"uname": user.userName,@"uuid": user.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
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
                ob.baseData = [object valueForKey:@"baseData"];
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
            NSDictionary *ovoDic = [[object valueForKey:@"ovo"] JSONValue];
            ObjectVo *obje = [[ObjectVo alloc]init];
            for (NSString *key in [ovoDic allKeys]) {
                [obje setValue:[ovoDic valueForKey:key] forKey:key];
            }
            if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
                NSMutableArray *cpArray = [NSMutableArray arrayWithArray:self.cpsArr];
                [self.view endSynRequestSignal];
                [self.view LabelTitle:@"修改成功"];
                [chanPin setValue:textMsg.text forKey:@"price"];
                [cpArray replaceObjectAtIndex:targetIndexPath.row withObject:chanPin];
                self.cpsArr = nil;
                self.cpsArr = [NSMutableArray arrayWithArray:cpArray];
                textMsg = nil;
            }else if ([[ovoDic valueForKey:@"code"] intValue] == -1){
                [self.view endSynRequestSignal];
                [self.view LabelTitle:obje.msg];
            }else{
                [self.view endSynRequestSignal];
                [self.view LabelTitle:@"修改失败"];
            }
        } failureBlock:^(NSError *error, NSString *responseString) {
            [self.view endSynRequestSignal];
        }];
    }else{
        [self.view showWithType:0 Title:@"正在收藏产品..."];
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": COLLECT_CHANPIN,@"cpid": [NSString stringWithFormat:@"%d",chanPin.Id],@"price": [NSString stringWithFormat:@"%d",[textMsg.text intValue]],@"uname": user.userName,@"uuid": user.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
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
                ob.baseData = [object valueForKey:@"baseData"];
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
            NSDictionary *ovoDic = [[object valueForKey:@"ovo"] JSONValue];
            ObjectVo *obje = [[ObjectVo alloc]init];
            for (NSString *key in [ovoDic allKeys]) {
                [obje setValue:[ovoDic valueForKey:key] forKey:key];
            }
            if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
                NSFileManager *fm = [NSFileManager defaultManager];
                if ([fm fileExistsAtPath:[self docPath]]) {
                    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:[self docPath]];
                    [arr addObject:[NSString stringWithFormat:@"%d_%d",chanPin.upload,chanPin.Id]];
                    [arr writeToFile:[self docPath] atomically:YES];
                }else{
                    NSMutableArray *arr = [[NSMutableArray alloc]init];
                    [arr addObject:[NSString stringWithFormat:@"%d_%d",chanPin.upload,chanPin.Id]];
                    [arr writeToFile:[self docPath] atomically:YES];
                }
                NSArray *array = [NSArray arrayWithObject:targetIndexPath];
                [self.table reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.view endSynRequestSignal];
                [self.view LabelTitle:@"收藏成功"];
            }else if ([[ovoDic valueForKey:@"code"] intValue] == -1){
                [self.view endSynRequestSignal];
                [self.view LabelTitle:obje.msg];
            }else{
                [self.view endSynRequestSignal];
                [self.view LabelTitle:@"收藏失败"];
            }
        } failureBlock:^(NSError *error, NSString *responseString) {
            [self.view endSynRequestSignal];
        }];
    }
    alertView = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}


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
