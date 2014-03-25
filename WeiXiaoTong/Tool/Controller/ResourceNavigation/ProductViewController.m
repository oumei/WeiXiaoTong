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


@interface ProductViewController ()

@end

@implementation ProductViewController
static int page = 1;
static int progressNum = 0;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cpsArr:(NSMutableArray *)cps
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cpsArr = cps;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageArr = [NSMutableArray array];

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
//    params = @{@"interface": GET_CHANPIN,@"page": @"0",@"lx":_lx,@"xb": _xb,@"pp": @"-1",@"text": text,@"uname": ue.userName,@"uuid": ue.uuid};
    UserEntity *user = [UserEntity shareCurrentUe];
    [self.view showWithType:0 Title:@"正在加载..."];
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    if (self.title == nil) {
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_CHANPIN,@"page": [NSString stringWithFormat:@"%d",page],@"lx":self.lx,@"xb": self.xb,@"pp": @"-1",@"text": self.text,@"uname": user.userName,@"uuid": user.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
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
            }
            [self.table reloadData];
            [self.view endSynRequestSignal];
        } failureBlock:^(NSError *error, NSString *responseString) {
            [self.view endSynRequestSignal];
        }];
        [self.view endSynRequestSignal];
    }else if (self.isSelf != nil && self.title == nil){
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_CHANPIN,@"page": [NSString stringWithFormat:@"%d",page],@"lx":self.lx,@"xb": self.xb,@"pp": @"-1",@"text": self.text,@"isSelf": @"1",@"uname": user.userName,@"uuid": user.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
//            NSLog(@"ob = %@",object);
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
            }
            [self.table reloadData];
            [self.view endSynRequestSignal];
        } failureBlock:^(NSError *error, NSString *responseString) {
            [self.view endSynRequestSignal];
        }];
        [self.view endSynRequestSignal];
    }else{
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_CHANPIN_BY_DANGKOU,@"page":[NSString stringWithFormat:@"%d",page],@"dangkou":self.title,@"uname": user.userName,@"uuid": user.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
            
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
            }
            [self.table reloadData];
            [self.view endSynRequestSignal];
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

    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[self docPath]]) {
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:[self docPath]];
        for (int i = 0; i < arr.count; i++) {
            int _Id = [[arr objectAtIndex:i] intValue];
            if (_Id == chanPin.Id) {
                [cell.collection setTitle:@"已收藏" forState:0];
            }
        }
    }
    if (user.Id == chanPin.upload) {
        [cell.collection setTitle:@"改价" forState:0];
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
    
    ChanPin *chanPin = [self.cpsArr objectAtIndex:indexPath.row];
    self.imageCount = chanPin.pics;
    if (self.imageCount > 0) {
        _spinner = [self.view showSpinner:0 Title:[NSString stringWithFormat:@"正在下载 0/%d",self.imageCount]];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = chanPin.miaoshu;
        for (int i = 0; i < chanPin.pics; i++) {
            NSString *url;
            if (chanPin.address) {
                url = IMAGE_URL_ID(chanPin.address, i);
            }else{
                NSString *str = [NSString stringWithFormat:@"%d",chanPin.Id];
                url = IMAGE_URL_ID(str, i);
            }
            DownloadImageOperation *operation = [[DownloadImageOperation alloc]initWithTarget:self selector:@selector(shareAction:) url:url];
            NSOperationQueue *queue = [[NSOperationQueue alloc]init];
            [queue addOperation:operation];
            operation = nil;
            queue = nil;
        }
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
        [self.imageArr addObject:data];
        if (self.imageArr.count == self.imageCount) {
            //发送内容给微信
            WXMediaMessage *message = [WXMediaMessage message];
            [message setThumbImage:nil];
            
            WXImageObject *ext = [WXImageObject object];
            ext.imageData = data;
            
            message.mediaObject = ext;
            
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene = 1;
            
            [WXApi sendReq:req];
            req = nil;
            progressNum = 0;
            [self.imageArr removeAllObjects];
            [self.view endSynRequestSignal];
        }
    }else{
        progressNum = 0;
        [self.imageArr removeAllObjects];
        [self.view endSynRequestSignal];
        [self.view LabelTitle:@"图片下载失败"];
    }
}

-(NSString *)docPath
{
    NSString *homePath=NSHomeDirectory();
    homePath=[homePath stringByAppendingPathComponent:@"Documents/chanpinID.txt"];
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
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 350, 120, 20)];
        lable.backgroundColor = [UIColor blackColor];
        lable.text = @"已收藏";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        
        [self.view addSubview:lable];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
        lable = nil;
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
    textMsg = nil;
    alertView = nil;
}

- (void)modifyAction:(UIButton *)sender
{
    alertView.hidden = YES;
    [self textFieldShouldReturn:textMsg];
    ChanPin *chanPin = [self.cpsArr objectAtIndex:targetIndexPath.row];
    UserEntity *user = [UserEntity shareCurrentUe];
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    if (chanPin.upload == user.Id) {
        [self.view showWithType:0 Title:@"正在修改价格..."];
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": UPDATE_SELF_CHANPIN_PRICE,@"cpid": [NSString stringWithFormat:@"%d",chanPin.Id],@"price": [NSString stringWithFormat:@"%d",[textMsg.text intValue]],@"uname": user.userName,@"uuid": user.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
            NSDictionary *ovoDic = [[object valueForKey:@"ovo"] JSONValue];
            ObjectVo *obje = [[ObjectVo alloc]init];
            for (NSString *key in [ovoDic allKeys]) {
                [obje setValue:[ovoDic valueForKey:key] forKey:key];
            }
            if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
                [self.view endSynRequestSignal];
                [self.view LabelTitle:@"修改成功"];
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
            NSDictionary *ovoDic = [[object valueForKey:@"ovo"] JSONValue];
            ObjectVo *obje = [[ObjectVo alloc]init];
            for (NSString *key in [ovoDic allKeys]) {
                [obje setValue:[ovoDic valueForKey:key] forKey:key];
            }
            if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
                NSFileManager *fm = [NSFileManager defaultManager];
                if ([fm fileExistsAtPath:[self docPath]]) {
                    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:[self docPath]];
                    [arr addObject:[NSString stringWithFormat:@"%d",chanPin.Id]];
                    [arr writeToFile:[self docPath] atomically:YES];
                }else{
                    NSMutableArray *arr = [[NSMutableArray alloc]init];
                    [arr addObject:[NSString stringWithFormat:@"%d",chanPin.Id]];
                    [arr writeToFile:[self docPath] atomically:YES];
                }
                [self.table reloadData];
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
    textMsg = nil;
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
