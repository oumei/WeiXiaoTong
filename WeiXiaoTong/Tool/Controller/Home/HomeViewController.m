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
#import "ObjectVo.h"
#import "UserEntity.h"
#import "HttpService.h"
#import "UserModel.h"
#import "JSON.h"
#import "Friend.h"
#import "CheckApplicationViewController.h"

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
    UserModel *user = [UserModel shareCurrentUser];
    
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_FRIENDS,@"uname": user.uname,@"uuid": user.uuid} completionBlock:^(id object) {
        
        NSString *ovo = [object valueForKey:@"ovo"];
        NSDictionary *ovoDic = [ovo JSONValue];
        NSLog(@"ovo = %@",ovo);
        NSLog(@"ovoallkey = %@",[ovoDic allKeys]);
        if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
            NSArray *friends = [ovoDic valueForKey:@"friends"];
            //NSArray *friendsArr = [friends JSONValue];
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
    ObjectVo *object = [ObjectVo shareCurrentObjectVo];
    NSLog(@"ue=%@",[object valueForKey:@"ue"]);
    UserEntity *ue = [[UserEntity alloc]init];
    for (NSString *key in [[object valueForKey:@"ue"] allKeys]) {
        [ue setValue:[[object valueForKey:@"ue"] valueForKey:key] forKey:key];
    }
    if (ue.level > 0) {
        CheckApplicationViewController *checkApplicationViewController = [[CheckApplicationViewController alloc]initWithNibName:@"CheckApplicationViewController" bundle:nil];
        [checkApplicationViewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:checkApplicationViewController animated:YES];
        checkApplicationViewController = nil;
    }
}

- (IBAction)refreshAction:(id)sender
{
    
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
    Friend *friend = [_friendsMutArr objectAtIndex:indexPath.row];
    cell.name.text = friend.userName;
    cell.Id.text = [NSString stringWithFormat:@"用户ID：%d",friend.Id];
    cell.xzCount.text = [NSString stringWithFormat:@"下载数量：%d",friend.xzCount];
    return cell;
}

- (void)deleted:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    [_friendsMutArr removeObjectAtIndex:indexPath.row];
    [self.table reloadData];
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
    ObjectVo *object = [ObjectVo shareCurrentObjectVo];
    NSLog(@"ue=%@",[object valueForKey:@"ue"]);
    UserEntity *ue = [[UserEntity alloc]init];
    for (NSString *key in [[object valueForKey:@"ue"] allKeys]) {
        [ue setValue:[[object valueForKey:@"ue"] valueForKey:key] forKey:key];
    }
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
