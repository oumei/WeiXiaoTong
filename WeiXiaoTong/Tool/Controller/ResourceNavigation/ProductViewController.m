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
//                chanPin.Id = [[[arr objectAtIndex:i] valueForKey:@"id"] intValue];
//                chanPin.miaoshu = [[arr objectAtIndex:i] valueForKey:@"miaoshu"];
//                chanPin.pinpai = [[[arr objectAtIndex:i] valueForKey:@"pinpai"] intValue];
//                chanPin.leixing = [[[arr objectAtIndex:i] valueForKey:@"leixing"] intValue];
//                chanPin.shijian = [[arr objectAtIndex:i] valueForKey:@"shijian"];
//                chanPin.dangkou = [[arr objectAtIndex:i] valueForKey:@"dangkou"];
//                chanPin.jiage = [[[arr objectAtIndex:i] valueForKey:@"jiage"] intValue];
//                chanPin.pics = [[[arr objectAtIndex:i] valueForKey:@"pics"] intValue];
//                chanPin.price = [[[arr objectAtIndex:i] valueForKey:@"price"] intValue];
//                chanPin.upload = [[[arr objectAtIndex:i] valueForKey:@"upload"] intValue];
//                chanPin.state = [[[arr objectAtIndex:i] valueForKey:@"state"] intValue];
//                chanPin.categorys = [[arr objectAtIndex:i] valueForKey:@"categorys"];
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
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
//    UserModel *user = [UserModel shareCurrentUser];
//    ChanPin *chanPin = [self.cpsArr objectAtIndex:indexPath.row];
//    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": COLLECT_CHANPIN,@"cpid": [NSString stringWithFormat:@"%d",chanPin.cpid],@"price": [NSString stringWithFormat:@"%d",chanPin.price],@"uname": user.uname,@"uuid": user.uuid} completionBlock:^(id object) {
//        //
//    } failureBlock:^(NSError *error, NSString *responseString) {
//        //
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
