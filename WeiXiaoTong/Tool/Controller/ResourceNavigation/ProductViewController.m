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
#import "DetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "UserEntity.h"
#import "UIView+SynRequestSignal.h"
#import "ObjectVo.h"
#import "DownloadImageOperation.h"
#include<objc/runtime.h>


@interface ProductViewController ()

@end

@implementation ProductViewController
static int page = 1;

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
    UserEntity *user = [UserEntity shareCurrentUe];
    if (self.title == nil) {
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_CHANPIN,@"page": [NSString stringWithFormat:@"%d",page],@"lx":self.lx,@"xb": self.xb,@"pp": @"-1",@"text": self.text,@"uname": user.userName,@"uuid": user.uuid,} completionBlock:^(id object) {
            NSLog(@"ob = %@",object);
            NSString *ovo = [object valueForKey:@"ovo"];
            NSDictionary *objectVoDic = [ovo JSONValue];
            NSMutableArray *cpsArr = [[NSMutableArray alloc]initWithArray:self.cpsArr];
            NSString *code = [objectVoDic valueForKey:@"code"];
            if ([code intValue] == 0) {
                NSArray *arr = [objectVoDic valueForKey:@"cps"];
                for (int i = 0; i < arr.count; i++) {
                    NSDictionary *dic = [arr objectAtIndex:i];
                    ChanPin *chanpin = [[ChanPin alloc]init];
                    for (NSString *key in dic) {
                        NSArray *cpArr = [self properties_aps:[ChanPin class] objc:chanpin];
                        for (NSString *k in cpArr) {
                            if ([key isEqualToString:k]) {
                                [chanpin setValue:[dic valueForKey:key] forKey:key];
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
        } failureBlock:^(NSError *error, NSString *responseString) {
            //
        }];
        
    }else if (self.isSelf != nil && self.title == nil){
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_CHANPIN,@"page": [NSString stringWithFormat:@"%d",page],@"lx":self.lx,@"xb": self.xb,@"pp": @"-1",@"text": self.text,@"isSelf": @"1",@"uname": user.userName,@"uuid": user.uuid,} completionBlock:^(id object) {
            NSLog(@"ob = %@",object);
            NSString *ovo = [object valueForKey:@"ovo"];
            NSDictionary *objectVoDic = [ovo JSONValue];
            NSMutableArray *cpsArr = [[NSMutableArray alloc]initWithArray:self.cpsArr];
            NSString *code = [objectVoDic valueForKey:@"code"];
            if ([code intValue] == 0) {
                NSArray *arr = [objectVoDic valueForKey:@"cps"];
                for (int i = 0; i < arr.count; i++) {
                    NSDictionary *dic = [arr objectAtIndex:i];
                    ChanPin *chanpin = [[ChanPin alloc]init];
                    for (NSString *key in dic) {
                        NSArray *cpArr = [self properties_aps:[ChanPin class] objc:chanpin];
                        for (NSString *k in cpArr) {
                            if ([key isEqualToString:k]) {
                                [chanpin setValue:[dic valueForKey:key] forKey:key];
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
        } failureBlock:^(NSError *error, NSString *responseString) {
            //
        }];
        
    }else{
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_CHANPIN_BY_DANGKOU,@"page":[NSString stringWithFormat:@"%d",page],@"dangkou":self.title,@"uname": user.userName,@"uuid": user.uuid} completionBlock:^(id object) {
            
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
        } failureBlock:^(NSError *error, NSString *responseString) {
            //
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
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    NSDictionary *baseData = [ob valueForKey:@"baseData"];
    static NSString *identifier = @"productCell";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell= (ProductCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"ProductCell" owner:self options:nil]  lastObject];
//        UIView *line = [[UIView alloc]init];
//        line.backgroundColor = [UIColor blackColor];
//        line.tag = 200;
//        [cell.name addSubview:line];
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
    
    [cell.name setTitle:chanPin.dangkou forState:0];
    cell.cost.text = [NSString stringWithFormat:@"进价：%d",chanPin.jiage];
    cell.describe.text = chanPin.miaoshu;
    cell.serialNum.text = [NSString stringWithFormat:@"编号：%d",chanPin.Id];
    cell.time.text = [NSString stringWithFormat:@"日期：%@",[chanPin.shijian substringToIndex:10]];
    
    NSArray *categorys = [chanPin.categorys componentsSeparatedByString:@"|"];
    NSArray *categoryArr = [[categorys objectAtIndex:0] componentsSeparatedByString:@"_"];
    if ([[categoryArr objectAtIndex:0] intValue] == 6) {
        for (int i = 0; i < [[baseData valueForKey:@"ss"] count]; i++) {
            if ([[[[baseData valueForKey:@"ss"] objectAtIndex:i] valueForKey:@"id"] intValue] == [[categoryArr objectAtIndex:1] intValue]) {
                cell.service.text = [[[baseData valueForKey:@"ss"] objectAtIndex:i] valueForKey:@"name"];
            }
        }
        //cell.service.text = [[[baseData valueForKey:@"ss"] objectAtIndex:[[categoryArr objectAtIndex:1] intValue]] valueForKey:@"name"];
        if ([cell.service.text rangeOfString:@"7天包退换"].location != NSNotFound) {
            cell.service.textColor = [UIColor orangeColor];
        }else if ([cell.service.text rangeOfString:@"支持换款"].location != NSNotFound){
            cell.service.textColor = [UIColor redColor];
        }else if ([cell.service.text rangeOfString:@"可换大小"].location != NSNotFound){
            cell.service.textColor = [UIColor cyanColor];
        }else if ([cell.service.text rangeOfString:@"不退不换"].location != NSNotFound){
            cell.service.textColor = [UIColor grayColor];
        }else if ([cell.service.text rangeOfString:@"质量包换"].location != NSNotFound){
            cell.service.textColor = [UIColor magentaColor];
        }
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[self docPath]]) {
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:[self docPath]];
        for (int i = 0; i < arr.count; i++) {
            int _Id = [[arr objectAtIndex:i] intValue];
            if (_Id == chanPin.Id) {
                [cell.collection setTitle:@"已收藏" forState:0];
            }}}
    
//    if (ue.level == 0) {
//        cell.collection.hidden = YES;
//    }else{}
    
    if (user.qx == 2) {
//        UIView *line = [cell.name viewWithTag:200];
//        CGSize size = [cell.name.titleLabel.text sizeWithFont:cell.name.titleLabel.font];
//        line.frame = CGRectMake(0, 18, size.width, 1);
        cell.type.hidden = YES;
        cell.applicablePeople.hidden = YES;
    }else{
        cell.name.hidden = YES;
        cell.type.text = [NSString stringWithFormat:@"类型：%@",[[[baseData valueForKey:@"lxs"] objectAtIndex:chanPin.leixing] valueForKey:@"name"]];
        cell.cost.text = [NSString stringWithFormat:@"类型：%@",[[[baseData valueForKey:@"lxs"] objectAtIndex:chanPin.leixing] valueForKey:@"name"]];
        cell.cost.textColor = [UIColor blackColor];
        cell.collection.hidden = YES;
        cell.applicablePeople.text = [NSString stringWithFormat:@"适用人群：%@",[[[baseData valueForKey:@"xbs"] objectAtIndex:chanPin.xingbie] valueForKey:@"name"]];
    }
    
    return cell;
        
//    }else {
//        static NSString *identifier = @"productTwoCell";
//        ProductTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (cell == nil) {
//            cell= (ProductTwoCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"ProductTwoCell" owner:self options:nil]  lastObject];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.delegate = self;
//        cell.indexPath = indexPath;
//        ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
//        NSDictionary *baseData = [ob valueForKey:@"baseData"];
//        
//        ChanPin *chanPin = [self.cpsArr objectAtIndex:indexPath.row];
//        [cell.image setImageWithURL:[NSURL URLWithString:IMAGE_URL(chanPin.Id)]];
//        cell.type.text = [NSString stringWithFormat:@"类型：%@",[[[baseData valueForKey:@"lxs"] objectAtIndex:chanPin.leixing] valueForKey:@"name"]];
//        cell.type2.text = [NSString stringWithFormat:@"类型：%@",[[[baseData valueForKey:@"lxs"] objectAtIndex:chanPin.leixing] valueForKey:@"name"]];
//        NSArray *categorys = [chanPin.categorys componentsSeparatedByString:@"|"];
//        NSArray *categoryArr = [[categorys objectAtIndex:0] componentsSeparatedByString:@"_"];
//        if ([[categoryArr objectAtIndex:0] intValue] == 6) {
//            for (int i = 0; i < [[baseData valueForKey:@"ss"] count]; i++) {
//                if ([[[[baseData valueForKey:@"ss"] objectAtIndex:i] valueForKey:@"id"] intValue] == [[categoryArr objectAtIndex:1] intValue]) {
//                    cell.service.text = [[[baseData valueForKey:@"ss"] objectAtIndex:i] valueForKey:@"name"];
//                }
//            }
//            //cell.service.text = [[[baseData valueForKey:@"ss"] objectAtIndex:[[categoryArr objectAtIndex:1] intValue]] valueForKey:@"name"];
//            if ([cell.service.text rangeOfString:@"7天包退换"].location != NSNotFound) {
//                cell.service.textColor = [UIColor orangeColor];
//            }else if ([cell.service.text rangeOfString:@"支持换款"].location != NSNotFound){
//                cell.service.textColor = [UIColor redColor];
//            }else if ([cell.service.text rangeOfString:@"可换大小"].location != NSNotFound){
//                cell.service.textColor = [UIColor cyanColor];
//            }else if ([cell.service.text rangeOfString:@"不退不换"].location != NSNotFound){
//                cell.service.textColor = [UIColor grayColor];
//            }else if ([cell.service.text rangeOfString:@"质量包换"].location != NSNotFound){
//                cell.service.textColor = [UIColor magentaColor];
//            }
//        }
//        cell.applicablePeople.text = [NSString stringWithFormat:@"适用人群：%@",[[[baseData valueForKey:@"xbs"] objectAtIndex:chanPin.xingbie] valueForKey:@"name"]];
//        cell.describe.text = chanPin.miaoshu;
//        cell.serialNum.text = [NSString stringWithFormat:@"编号：%d",chanPin.Id];
//        cell.time.text = [NSString stringWithFormat:@"日期：%@",[chanPin.shijian substringToIndex:10]];
//        
//        return cell;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChanPin *chanPin = [self.cpsArr objectAtIndex:indexPath.row];
    self.imageCount = chanPin.pics;
    for (int i = 0; i < chanPin.pics; i++) {
        NSString *url = IMAGE_URL_ID(chanPin.Id, i);
        DownloadImageOperation *operation = [[DownloadImageOperation alloc]initWithTarget:self selector:@selector(shareAction:) url:url];
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [queue addOperation:operation];
        operation = nil;
        queue = nil;
    }
    
}

- (void)shareAction:(NSData *)data
{
    if (data) {
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
            [self.imageArr removeAllObjects];
        }
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
    NSDictionary *dic = @{@"Id": [NSString stringWithFormat:@"%d",chanPin.Id],@"miaoshu": chanPin.miaoshu,@"pinpai": [NSString stringWithFormat:@"%d",chanPin.pinpai],@"leixing": [NSString stringWithFormat:@"%d",chanPin.leixing],@"xingbie": [NSString stringWithFormat:@"%d",chanPin.xingbie],@"shijian": chanPin.shijian,@"dangkou": chanPin.dangkou,@"jiage": [NSString stringWithFormat:@"%d",chanPin.jiage],@"pics": [NSString stringWithFormat:@"%d",chanPin.pics],@"price":[NSString stringWithFormat:@"%d", chanPin.price],@"upload": [NSString stringWithFormat:@"%d",chanPin.upload],@"state": [NSString stringWithFormat:@"%d",chanPin.state],@"categorys": chanPin.categorys,@"address": chanPin.address};
    DetailsViewController *detailsViewController = [[DetailsViewController alloc]initWithNibName:@"DetailsViewController" bundle:nil chanPin:dic];
    [detailsViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailsViewController animated:YES];
    detailsViewController = nil;
    chanPin = nil;
    dic = nil;
}

- (void)collection:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    ProductCell *cell = (ProductCell *)[self.table cellForRowAtIndexPath:indexPath];
    ChanPin *chanPin = [self.cpsArr objectAtIndex:indexPath.row];
     UserEntity *user = [UserEntity shareCurrentUe];
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
        [self.view showWithType:0 Title:@"正在收藏产品..."];
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": COLLECT_CHANPIN,@"cpid": [NSString stringWithFormat:@"%d",chanPin.Id],@"price": [NSString stringWithFormat:@"%d",chanPin.price],@"uname": user.userName,@"uuid": user.uuid} completionBlock:^(id object) {
            NSDictionary *ovoDic = [[object valueForKey:@"ovo"] JSONValue];
            ObjectVo *ob = [[ObjectVo alloc]init];
            for (NSString *key in [ovoDic allKeys]) {
                [ob setValue:[ovoDic valueForKey:key] forKey:key];
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
                UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 350, 120, 20)];
                lable.backgroundColor = [UIColor blackColor];
                lable.text = @"收藏成功";
                lable.textAlignment = NSTextAlignmentCenter;
                lable.textColor = [UIColor whiteColor];
                
                [self.view addSubview:lable];
                [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
                lable = nil;
            }else if ([[ovoDic valueForKey:@"code"] intValue] == -1){
                [self.view endSynRequestSignal];
                UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 350, 120, 20)];
                lable.backgroundColor = [UIColor blackColor];
                lable.text = ob.msg;
                lable.textAlignment = NSTextAlignmentCenter;
                lable.textColor = [UIColor whiteColor];
                
                [self.view addSubview:lable];
                [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
                lable = nil;
            }else{
                [self.view endSynRequestSignal];
                UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 350, 120, 20)];
                lable.backgroundColor = [UIColor blackColor];
                lable.text = @"收藏失败";
                lable.textAlignment = NSTextAlignmentCenter;
                lable.textColor = [UIColor whiteColor];
                
                [self.view addSubview:lable];
                [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
                lable = nil;
            }
        } failureBlock:^(NSError *error, NSString *responseString) {
            [self.view endSynRequestSignal];
        }];
    }
}

- (void)dangkou:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    UserEntity *user = [UserEntity shareCurrentUe];
    ChanPin *chanPin = [self.cpsArr objectAtIndex:indexPath.row];
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_CHANPIN_BY_DANGKOU,@"page":@"0",@"dangkou":chanPin.dangkou,@"uname": user.userName,@"uuid": user.uuid} completionBlock:^(id object) {
        
        NSDictionary *ovoDic = [[object valueForKey:@"ovo"] JSONValue];
        if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
            NSMutableArray *cpsArr = [[NSMutableArray alloc]init];
            NSArray *arr = [[NSArray alloc]init];
            arr = [ovoDic valueForKey:@"cps"];
            for (int i = 0; i < arr.count; i++) {
                ChanPin *chanPin = [[ChanPin alloc]init];
                chanPin.Id = [[[arr objectAtIndex:i] valueForKey:@"id"] intValue];
                chanPin.miaoshu = [[arr objectAtIndex:i] valueForKey:@"miaoshu"];
                chanPin.pinpai = [[[arr objectAtIndex:i] valueForKey:@"pinpai"] intValue];
                chanPin.leixing = [[[arr objectAtIndex:i] valueForKey:@"leixing"] intValue];
                chanPin.shijian = [[arr objectAtIndex:i] valueForKey:@"shijian"];
                chanPin.dangkou = [[arr objectAtIndex:i] valueForKey:@"dangkou"];
                chanPin.jiage = [[[arr objectAtIndex:i] valueForKey:@"jiage"] intValue];
                chanPin.pics = [[[arr objectAtIndex:i] valueForKey:@"pics"] intValue];
                chanPin.price = [[[arr objectAtIndex:i] valueForKey:@"price"] intValue];
                chanPin.upload = [[[arr objectAtIndex:i] valueForKey:@"upload"] intValue];
                chanPin.state = [[[arr objectAtIndex:i] valueForKey:@"state"] intValue];
                chanPin.categorys = [[arr objectAtIndex:i] valueForKey:@"categorys"];
                [cpsArr addObject:chanPin];
                chanPin = nil;
            }
            
            if (cpsArr.count > 0) {
                ProductViewController *productViewController = [[ProductViewController alloc]initWithNibName:@"ProductViewController" bundle:nil cpsArr:cpsArr];
                productViewController.title = chanPin.dangkou;
                [productViewController setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:productViewController animated:YES];
                productViewController = nil;
            }
            cpsArr = nil;
            arr = nil;
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        //
    }];

}

- (void)hideCollectionLable:(NSTimer *)aTimer
{
    UILabel *lable = [aTimer userInfo];
    lable.hidden = YES;
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
