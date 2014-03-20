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
#import "UIView+SynRequestSignal.h"

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
    cell.userName.text = [NSString stringWithFormat:@"(%d)",af.applyId];
    cell.validationMsg.text = [NSString stringWithFormat:@"验证消息：%@",af.message];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[af.date floatValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    cell.time.text = [NSString stringWithFormat:@"时间：%@",[formatter stringFromDate:date]];
    formatter = nil;
    date = nil;
//    cell.userName.text = @"(136546)";
//    cell.uLabel.frame = CGRectMake(5+cell.userName.frame.size.width, cell.uLabel.frame.origin.y, cell.uLabel.frame.size.width, cell.uLabel.frame.size.height);
    return cell;
}

#pragma mark - checkApplication delegate -
- (void)refuse:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    [self.view showWithType:0 Title:@"正在拒绝好友请求..."];
    ApplyFriend *af = [self.afs objectAtIndex:indexPath.row];
    UserEntity *ue = [UserEntity shareCurrentUe];
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": DECLINE_FRIEND,@"afid":[NSString stringWithFormat:@"%d",af.Id],@"uname":ue.userName,@"uuid":ue.uuid} completionBlock:^(id object) {
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
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 200, 120, 20)];
            lable.backgroundColor = [UIColor blackColor];
            lable.text = @"操作成功";
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [UIColor whiteColor];
            [self.view addSubview:lable];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
            lable = nil;
            
        }else{
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 200, 240, 20)];
            lable.backgroundColor = [UIColor blackColor];
            lable.text = [ovoDic valueForKey:@"msg"];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [UIColor whiteColor];
            [self.view addSubview:lable];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
            lable = nil;
        }

    } failureBlock:^(NSError *error, NSString *responseString) {
        //
    }];
}

- (void)agree:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    [self.view showWithType:0 Title:@"正在同意好友请求..."];
    ApplyFriend *af = [self.afs objectAtIndex:indexPath.row];
    UserEntity *ue = [UserEntity shareCurrentUe];
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": ALLOW_FRIEND,@"afid":[NSString stringWithFormat:@"%d",af.Id],@"uname":ue.userName,@"uuid":ue.uuid} completionBlock:^(id object) {
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
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 200, 120, 20)];
            lable.backgroundColor = [UIColor blackColor];
            lable.text = @"操作成功";
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [UIColor whiteColor];
            [self.view addSubview:lable];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
            lable = nil;
            
        }else{
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 200, 240, 20)];
            lable.backgroundColor = [UIColor blackColor];
            lable.text = [ovoDic valueForKey:@"msg"];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [UIColor whiteColor];
            [self.view addSubview:lable];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
            lable = nil;
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

- (void)reloadTableData:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
