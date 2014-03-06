//
//  HomeViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "UINavigationBar+Custom.h"
#import "HWSDK.h"
#import "LoginViewController.h"
#import "UserEntity.h"
#import "HttpService.h"
#import "JSON.h"
#import "Friend.h"
#import "CheckApplicationViewController.h"
#import "AddMerchantsViewController.h"
#import "ApplyFriend.h"
#import "UIView+SynRequestSignal.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    _friendsMutArr = [[NSMutableArray alloc]init];
    UserEntity *user = [UserEntity shareCurrentUe];
    
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_FRIENDS,@"uname": user.userName,@"uuid": user.uuid} completionBlock:^(id object) {
        
        NSString *ovo = [object valueForKey:@"ovo"];
        NSDictionary *ovoDic = [ovo JSONValue];
//        NSLog(@"ovo = %@",ovo);
//        NSLog(@"ovoallkey = %@",[ovoDic allKeys]);
        if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
            NSArray *friends = [ovoDic valueForKey:@"friends"];
            NSMutableArray *mutArr = [[NSMutableArray alloc]init];
            for (int i = 0; i < friends.count; i++) {
                NSDictionary *dic = [friends objectAtIndex:i];
                Friend *friend = [[Friend alloc]init];
                for (NSString *key in [dic allKeys]) {
                    [friend setValue:[dic valueForKey:key] forKey:key];
                }
                [mutArr addObject:friend];
                friend = nil;
            }
            _friendsMutArr = mutArr;
            [self.table reloadData];
        }else{
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 350, 240, 20)];
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

- (IBAction)addNewMerchants:(id)sender
{
    UserEntity *ue = [UserEntity shareCurrentUe];
    if (ue.level > 0) {
        [self.view showWithType:0 Title:@"请求商家申请列表中..."];
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_APPLY_FRIENDS,@"uname": ue.userName,@"uuid": ue.uuid} completionBlock:^(id object) {
            NSLog(@"object = %@",object);
            NSString *ovo = [object valueForKey:@"ovo"];
            NSDictionary *ovoDic = [ovo JSONValue];
            if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
                NSArray *afs = [ovoDic valueForKey:@"afs"];
                if (afs.count > 0) {
                    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
                    for (int i = 0; i < afs.count; i++) {
                        NSDictionary *dic = [afs objectAtIndex:i];
                        ApplyFriend *af = [[ApplyFriend alloc]init];
                        for (NSString *key in [dic allKeys]) {
                            [af setValue:[dic valueForKey:key] forKey:key];
                        }
                        [mutArr addObject:af];
                        af = nil;
                    }
                    CheckApplicationViewController *checkApplicationViewController = [[CheckApplicationViewController alloc]initWithNibName:@"CheckApplicationViewController" bundle:nil afs:mutArr];
                    [checkApplicationViewController setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:checkApplicationViewController animated:YES];
                    [self.view endSynRequestSignal];
                    checkApplicationViewController = nil;
                    mutArr = nil;
                    afs = nil;
                }else{
                    [self.view endSynRequestSignal];
                    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 200, 120, 20)];
                    lable.backgroundColor = [UIColor blackColor];
                    lable.text = @"暂无商家申请！";
                    lable.textAlignment = NSTextAlignmentCenter;
                    lable.textColor = [UIColor whiteColor];
                    [self.view addSubview:lable];
                    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
                    lable = nil;
                }
            }else{
                [self.view endSynRequestSignal];
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
        
    }else if(ue.qx == 0){
        AddMerchantsViewController *addMerchantsViewController = [[AddMerchantsViewController alloc]initWithNibName:@"AddMerchantsViewController" bundle:nil];
        [addMerchantsViewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:addMerchantsViewController animated:YES];
        addMerchantsViewController = nil;
    }
}

- (IBAction)refreshAction:(id)sender
{
    [self.view showWithType:0 Title:@"请求商家列表中..."];
    UserEntity *user = [UserEntity shareCurrentUe];
    
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_FRIENDS,@"uname": user.userName,@"uuid": user.uuid} completionBlock:^(id object) {
        
        NSString *ovo = [object valueForKey:@"ovo"];
        NSDictionary *ovoDic = [ovo JSONValue];
        if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
            NSArray *friends = [ovoDic valueForKey:@"friends"];
            NSMutableArray *mutArr = [[NSMutableArray alloc]init];
            for (int i = 0; i < friends.count; i++) {
                NSDictionary *dic = [friends objectAtIndex:i];
                Friend *friend = [[Friend alloc]init];
                for (NSString *key in [dic allKeys]) {
                    [friend setValue:[dic valueForKey:key] forKey:key];
                }
                [mutArr addObject:friend];
                friend = nil;
            }
            _friendsMutArr = mutArr;
            [self.table reloadData];
            [self.view endSynRequestSignal];
        }else{
            [self.view endSynRequestSignal];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 350, 240, 20)];
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

#pragma mark - tableView Delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _friendsMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"merchantsCell";
    MerchantsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MerchantsCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    Friend *friend = [_friendsMutArr objectAtIndex:indexPath.row];
    cell.name.text = friend.userName;
    cell.Id.text = [NSString stringWithFormat:@"用户ID：%d",friend.Id];
    cell.xzCount.text = [NSString stringWithFormat:@"下载数量：%d",friend.xzCount];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserEntity *ue = [UserEntity shareCurrentUe];
    Friend *friend = [_friendsMutArr objectAtIndex:indexPath.row];
    if (ue.qx > 0) {
        [self.view showWithType:0 Title:@"切换商家中..."];
        
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": CHANGE_TABLE,@"fid": [NSString stringWithFormat:@"%d",friend.Id],@"uname": ue.userName,@"uuid": ue.uuid} completionBlock:^(id object) {
            
            NSString *ovo = [object valueForKey:@"ovo"];
            NSDictionary *ovoDic = [ovo JSONValue];
            if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
                [self.view endSynRequestSignal];
                
                if (_lastIndexPath == nil) {
                    _lastIndexPath = indexPath;
                }else{
                    MerchantsCell *cell = (MerchantsCell *)[tableView cellForRowAtIndexPath:_lastIndexPath];
                    cell.name.textColor = [UIColor blackColor];
                    _lastIndexPath = indexPath;
                }
                MerchantsCell *cell = (MerchantsCell *)[tableView cellForRowAtIndexPath:indexPath];
                cell.name.textColor = [UIColor redColor];
                
                UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 350, 120, 20)];
                lable.backgroundColor = [UIColor blackColor];
                lable.text = @"切换商家成功！";
                lable.textAlignment = NSTextAlignmentCenter;
                lable.textColor = [UIColor whiteColor];
                
                [self.view addSubview:lable];
                [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
                lable = nil;
            }else{
                [self.view endSynRequestSignal];
                UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 350, 240, 20)];
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
}

- (void)deleted:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    [self.view showWithType:0 Title:@"正在删除商家信息中..."];
    UserEntity *user = [UserEntity shareCurrentUe];
     Friend *friend = [_friendsMutArr objectAtIndex:indexPath.row];
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": DELETE_FRIENDS,@"fname":friend.userName,@"uname": user.userName,@"uuid":user.uuid} completionBlock:^(id object) {
        NSString *ovo = [object valueForKey:@"ovo"];
        NSDictionary *ovoDic = [ovo JSONValue];
        if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
            NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_friendsMutArr];
            [arr removeObjectAtIndex:indexPath.row];
            _friendsMutArr = arr;
            [self.table reloadData];
            [self.view endSynRequestSignal];
            arr = nil;
        }else{
            [self.view endSynRequestSignal];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(50, 200, 220, 20)];
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
//    [_friendsMutArr removeObjectAtIndex:indexPath.row];
//    [self.table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [self setView:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    UserEntity *ue = [UserEntity shareCurrentUe];
    if (ue.level > 0) {
        [self.addNewMer setTitle:@"  查看用户申请列表" forState:0];
    }
}

#pragma mark - Private Methods
- (NSString *)tabImageName
{
	return @"首页-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}
//- (IBAction)pushaction:(id)sender
//{
//    LoginViewController *lo = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
//    [self presentViewController:lo animated:YES completion:^{
//        //
//    }];
//    lo = nil;
//}

- (void)initUI
{
    
    [self.navigationController.navigationBar setBackgroundImage:[self image]];
    
}

- (UIImage *)image
{
    CGSize imageSize = CGSizeMake(320, 44);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[UIColor blackColor] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}

@end