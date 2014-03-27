//
//  HomeViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "HWSDK.h"
#import "LoginViewController.h"
#import "UserEntity.h"
#import "HttpService.h"
#import "JSON.h"
#import "Friend.h"
#import "CheckApplicationViewController.h"
#import "AddMerchantsViewController.h"
#import "ApplyFriend.h"
#import "UploadViewController.h"
#import "CustomAlertView.h"
#import "ObjectVo.h"

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
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    icon.image = [UIImage imageNamed:@"up_icon.png"];
    [leftView addSubview:icon];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    leftView = nil;
    icon = nil;
    leftBarButton = nil;
    
    self.title = @"我的商家";
    UIImageView *refreshImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    refreshImage.image = [UIImage imageNamed:@"refrish_icon.png"];
    [self.refreshFriend addSubview:refreshImage];
    
    UIImageView *newImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    newImage.image = [UIImage imageNamed:@"new_icon.png"];
    [self.applicantList addSubview:newImage];
    
    UIImageView *addImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    addImage.image = [UIImage imageNamed:@"seach_icon.png"];
    [self.addFriend addSubview:addImage];

    _friendsMutArr = [[NSMutableArray alloc]init];
    UserEntity *user = [UserEntity shareCurrentUe];
    ObjectVo *ob= [ObjectVo shareCurrentObjectVo];
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_FRIENDS,@"uname": user.userName,@"uuid": user.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
        
        NSString *ovo = [object valueForKey:@"ovo"];
        NSDictionary *ovoDic = [ovo JSONValue];
//        NSLog(@"ovo = %@",ovo);
//        NSLog(@"ovoallkey = %@",[ovoDic allKeys]);
        if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
            NSArray *friends = [ovoDic valueForKey:@"friends"];
            NSMutableArray *mutArr = [[NSMutableArray alloc]init];
            for (int i = 0; i < friends.count; i++) {
                NSDictionary *dic = [friends objectAtIndex:i];
                NSLog(@"d = %@",dic);
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
            [self.view LabelTitle:[ovoDic valueForKey:@"msg"]];
        }
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        //
    }];
    
}

- (IBAction)checkApplicantList:(id)sender
{
    UserEntity *ue = [UserEntity shareCurrentUe];
    [self.view showWithType:0 Title:@"请求商家申请列表中..."];
    ObjectVo *ob= [ObjectVo shareCurrentObjectVo];
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_APPLY_FRIENDS,@"uname": ue.userName,@"uuid": ue.uuid, @"dataVersions":ob.dataVersions} completionBlock:^(id object) {
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
                [self.view LabelTitle:@"暂无商家申请！"];
            }
        }else{
            [self.view endSynRequestSignal];
            [self.view LabelTitle:[ovoDic valueForKey:@"msg"]];
        }
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [self.view endSynRequestSignal];
    }];
    
}

- (IBAction)refreshAction:(id)sender
{
    [self.view showWithType:0 Title:@"请求商家列表中..."];
    UserEntity *user = [UserEntity shareCurrentUe];
    ObjectVo *ob= [ObjectVo shareCurrentObjectVo];
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": GET_FRIENDS,@"uname": user.userName,@"uuid": user.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
        
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
            [self.view LabelTitle:[ovoDic valueForKey:@"msg"]];
        }
        [self.view LabelTitle:@"刷新完成"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [self.view endSynRequestSignal];
    }];
}

- (IBAction)addFriends:(id)sender
{
    AddMerchantsViewController *addMerchantsViewController = [[AddMerchantsViewController alloc]initWithNibName:@"AddMerchantsViewController" bundle:nil];
    [addMerchantsViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:addMerchantsViewController animated:YES];
    addMerchantsViewController = nil;
}

#pragma mark - tableView Delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _friendsMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserEntity *ue = [UserEntity shareCurrentUe];
    static NSString *identifier = @"merchantsCell";
    MerchantsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MerchantsCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    Friend *friend = [_friendsMutArr objectAtIndex:indexPath.row];
    cell.signature.text = [NSString stringWithFormat:@"签名：%@",friend.description];
    cell.name.text = [NSString stringWithFormat:@"ID:%d    %@",friend.fid,friend.fname];
    if (ue.tableName == friend.fid) {
        cell.name.textColor = [UIColor redColor];
        if (_lastIndexPath == nil) {
            _lastIndexPath = indexPath;
        }
    }
    if (![friend.remark isEqualToString:@""]) {
        cell.name.text = [NSString stringWithFormat:@"ID:%d    %@(%@)",friend.fid,friend.fname,friend.remark];
    }
    if ([friend.fname isEqualToString:@"阿里九九"]) {
        cell.deleteBtn.hidden = YES;
        cell.noteBtn.hidden = YES;
    }
    if ([friend.fname isEqualToString:friend.uname]) {
        [cell.deleteBtn setTitle:@"上传" forState:0];
        [cell.noteBtn setTitle:@"签名" forState:0];
    }
    return cell;
}

- (void)deleted:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    _friendIndexPath = indexPath;
    Friend *friend = [_friendsMutArr objectAtIndex:indexPath.row];
    if ([friend.fname isEqualToString:friend.uname]) {
        UploadViewController *uploadViewController = [[UploadViewController alloc]initWithNibName:@"UploadViewController" bundle:nil];
        [self.navigationController pushViewController:uploadViewController animated:YES];
        uploadViewController = nil;
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定要删除该商家？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        alert = nil;
    }
    //[self refreshAction:nil];
}

- (void)note:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    Friend *friend = [_friendsMutArr objectAtIndex:indexPath.row];
    _targetIndexPath = indexPath;
    if ([friend.fname isEqualToString:friend.uname]){
        [self label:@"输入个性签名" content:friend.description];
    }else{
        [self label:@"请输入好友备注" content:friend.remark];
    }
}

- (void)selected:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    UserEntity *ue = [UserEntity shareCurrentUe];
    Friend *friend = [_friendsMutArr objectAtIndex:indexPath.row];
    [self.view showWithType:0 Title:@"切换商家中..."];
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": CHANGE_TABLE,@"fname": friend.fname,@"uname": ue.userName,@"uuid": ue.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
        NSLog(@"ob=%@",object);
        NSString *ovo = [object valueForKey:@"ovo"];
        NSDictionary *ovoDic = [ovo JSONValue];
        if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
            [self.view endSynRequestSignal];
            
            if (_lastIndexPath == nil) {
                _lastIndexPath = indexPath;
            }else{
                MerchantsCell *cell = (MerchantsCell *)[self.table cellForRowAtIndexPath:_lastIndexPath];
                cell.name.textColor = [UIColor blackColor];
                _lastIndexPath = indexPath;
            }
            MerchantsCell *cell = (MerchantsCell *)[self.table cellForRowAtIndexPath:indexPath];
            cell.name.textColor = [UIColor redColor];
            
            [self.view LabelTitle:@"切换成功，现在可以查询Ta的商品！"];
            ue.tableName = friend.fid;
            [UserEntity clearCurrrentUe];
            // 将个人信息全部持久化到documents中，可通过ue的单例获取登录了的用户的个人信息
            NSMutableData *mData = [[NSMutableData alloc]init];
            NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
            [archiver encodeObject:ue forKey:@"ueInfo"];
            [archiver finishEncoding];
            NSString *ueInfoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ueInfo.txt"];
            [mData writeToFile:ueInfoPath atomically:YES];
            mData = nil;
            self.tabBarController.selectedIndex = 1;
        }else{
            [self.view endSynRequestSignal];
            [self.view LabelTitle:[ovoDic valueForKey:@"msg"]];
        }
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [self.view endSynRequestSignal];
    }];

}


- (void)label:(NSString *)title content:(NSString *)content
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
    textMsg.text = content;
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
    [modify setTitle:@"修改" forState:0];
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
    UserEntity *ue = [UserEntity shareCurrentUe];
    ObjectVo *ob= [ObjectVo shareCurrentObjectVo];
    Friend *friend = [_friendsMutArr objectAtIndex:_targetIndexPath.row];
    if ([friend.fname isEqualToString:friend.uname]){
        NSLog(@"%@",textMsg.text);
        [self.view showWithType:0 Title:@"修改签名中..."];
        
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": UPDATE_DESCRIPTION,@"description": textMsg.text,@"uname": ue.userName,@"uuid": ue.uuid,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
            NSLog(@"ob=%@",object);
            NSString *ovo = [object valueForKey:@"ovo"];
            NSDictionary *ovoDic = [ovo JSONValue];
            if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
                [self.view endSynRequestSignal];
                [self.view LabelTitle:@"修改成功！"];
            }else{
                [self.view endSynRequestSignal];
                [self.view LabelTitle:[ovoDic valueForKey:@"msg"]];
            }
            
        } failureBlock:^(NSError *error, NSString *responseString) {
            [self.view endSynRequestSignal];
        }];
    }else{
        [self.view showWithType:0 Title:@"修改备注中..."];
        NSDictionary *params = @{@"interface": REMARK_FRIENDS,@"uname": ue.userName,@"uuid": ue.uuid,@"remark": textMsg.text,@"fid": [NSString stringWithFormat:@"%d",friend.Id],@"dataVersions":ob.dataVersions};
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:params completionBlock:^(id object) {
            NSString *ovo = [object valueForKey:@"ovo"];
            NSDictionary *ovoDic = [ovo JSONValue];
            if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
                [self.view endSynRequestSignal];
                [self.view LabelTitle:@"修改成功！"];
            }else{
                [self.view endSynRequestSignal];
                [self.view LabelTitle:[ovoDic valueForKey:@"msg"]];
            }
        } failureBlock:^(NSError *error, NSString *responseString) {
            [self.view endSynRequestSignal];
        }];
    }
    [self refreshAction:nil];
    textMsg = nil;
    alertView = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

#pragma mark - alert delegate -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    Friend *friend = [_friendsMutArr objectAtIndex:_friendIndexPath.row];
    if (buttonIndex == 1) {
        [self.view showWithType:0 Title:@"正在删除商家信息中..."];
        UserEntity *user = [UserEntity shareCurrentUe];
        ObjectVo *ob= [ObjectVo shareCurrentObjectVo];
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": DELETE_FRIENDS,@"fname":friend.fname,@"uname": user.userName,@"uuid":user.uuid, @"dataVersions":ob.dataVersions} completionBlock:^(id object) {
            NSString *ovo = [object valueForKey:@"ovo"];
            NSDictionary *ovoDic = [ovo JSONValue];
            if ([[ovoDic valueForKey:@"code"] intValue] == 0) {
                NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_friendsMutArr];
                [arr removeObjectAtIndex:_friendIndexPath.row];
                _friendsMutArr = arr;
                [self.table reloadData];
                [self.view endSynRequestSignal];
                [self.view LabelTitle:@"删除成功"];
                arr = nil;
            }else{
                [self.view endSynRequestSignal];
                [self.view LabelTitle:[ovoDic valueForKey:@"msg"]];
            }
        } failureBlock:^(NSError *error, NSString *responseString) {
            [self.view endSynRequestSignal];
        }];
    }
}

#pragma mark - Private Methods
- (NSString *)tabImageName
{
	return @"friends_on.png";
}

- (NSString *)tabTitle
{
	return nil;
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

@end
