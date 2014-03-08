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
#import "UIImageView+downLoadImage.h"
#import "ChanPin.h"
#import "DetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "UserEntity.h"
#import "UIView+SynRequestSignal.h"

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
                        [chanpin setValue:[dic valueForKey:key] forKey:key];
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
                        [chanPin setValue:[[arr objectAtIndex:i] valueForKey:key] forKey:key];
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
    static NSString *identifier = @"productCell";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell= (ProductCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"ProductCell" owner:self options:nil]  lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    ChanPin *chanPin = [self.cpsArr objectAtIndex:indexPath.row];
    [cell.image setImageWithURL:[NSURL URLWithString:IMAGE_URL(chanPin.Id)]];
    cell.name.text = chanPin.dangkou;
    cell.cost.text = [NSString stringWithFormat:@"拿货价：%d",chanPin.jiage];
    cell.describe.text = chanPin.miaoshu;
    cell.serialNum.text = [NSString stringWithFormat:@"编号：%d",chanPin.Id];
    cell.time.text = [NSString stringWithFormat:@"日期：%@",[chanPin.shijian substringToIndex:10]];
    
    UserEntity *ue = [UserEntity shareCurrentUe];
    if (ue.level == 0) {
        cell.collection.hidden = YES;
    }else{
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:[self docPath]]) {
            NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:[self docPath]];
            for (int i = 0; i < arr.count; i++) {
                int _Id = [[arr objectAtIndex:i] intValue];
                if (_Id == chanPin.Id) {
                    [cell.collection setTitle:@"已收藏" forState:0];
                }}}
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //ChanPin *chanPin = [self.cpsArr objectAtIndex:indexPath.row];
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
    NSDictionary *dic = @{@"Id": [NSString stringWithFormat:@"%d",chanPin.Id],@"miaoshu": chanPin.miaoshu,@"pinpai": [NSString stringWithFormat:@"%d",chanPin.pinpai],@"leixing": [NSString stringWithFormat:@"%d",chanPin.leixing],@"xingbie": [NSString stringWithFormat:@"%d",chanPin.xingbie],@"shijian": chanPin.shijian,@"dangkou": chanPin.dangkou,@"jiage": [NSString stringWithFormat:@"%d",chanPin.jiage],@"pics": [NSString stringWithFormat:@"%d",chanPin.pics],@"price":[NSString stringWithFormat:@"%d", chanPin.price],@"upload": [NSString stringWithFormat:@"%d",chanPin.upload],@"state": [NSString stringWithFormat:@"%d",chanPin.state],@"categorys": chanPin.categorys,@"cpid": [NSString stringWithFormat:@"%d",chanPin.cpid]};
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

- (void)hideCollectionLable:(NSTimer *)aTimer
{
    UILabel *lable = [aTimer userInfo];
    lable.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
