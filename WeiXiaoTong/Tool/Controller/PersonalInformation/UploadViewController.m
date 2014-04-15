//
//  UploadViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-11.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "UploadViewController.h"
#import "ObjectVo.h"
#import "UserEntity.h"
#import "UploadOperation.h"
#import "HttpService.h"
#import "JSON.h"
#import "ResultsModel.h"
#include <objc/runtime.h>

@interface UploadViewController ()

@end

@implementation UploadViewController
static int progressNum = 0;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil address:(NSString *)address
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.addressText = address;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    back.frame = CGRectMake(0, 0, 25, 25);
//    [back setImage:[UIImage imageNamed:@"back.png"] forState:0];
//    [back addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:back];
//    self.navigationItem.leftBarButtonItem = backButton;
    
    _images = [[NSMutableArray alloc]init];
    _bad = [[NSMutableArray alloc]init];
    _well = [[NSMutableArray alloc]init];
    
    self.data = @[@"选择产品类型"];
    _all = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择产品品牌"];
    _other = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择产品品牌"];
    _shoes = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择产品品牌",@"选择鞋子类型"];
    _watch = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择产品品牌",@"选择手表机芯",@"选择手表表带"];
    _bag = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择产品品牌",@"选择包包类型",@"选择产品品质"];
    _wallet = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择产品品牌"];
    _silk = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择产品品牌"];
    _belt = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择产品品牌",@"选择产品品质"];
    _clothes = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择产品品牌",@"选择服装类型"];
    _hat = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择产品品牌"];
    _glasses = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择产品品牌"];
    _jewelry = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择产品品牌"];
    _cosmetics = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择产品品牌",@"选择彩妆类型"];
    _gShoes = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择产品品牌",@"选择鞋子类型",@"选择鞋跟高度"];
    
    //**********************tableHeaderView****************************//
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    
    self.describeText = [[CDTextView alloc]initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width - 10, 50)];
    self.describeText.backgroundColor = [UIColor clearColor];
    self.describeText.font = [UIFont systemFontOfSize:15];
    self.describeText.delegate = self;
    self.describeText.contentSize = [self.describeText.text sizeWithFont:self.describeText.font];
    self.describeText.placeholder = @"请在这里填写产品描述...";
    [headerView addSubview:self.describeText];
    
    self.lineOne = [[UIView alloc]initWithFrame:CGRectMake(5, 55, [UIScreen mainScreen].bounds.size.width - 10, 1)];
    self.lineOne.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:self.lineOne];

    headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
    self.table.tableHeaderView = headerView;
    
    //************************tableFooterView**************************//
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor clearColor];
    
    self.address = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, 30)];
    self.address.font = [UIFont systemFontOfSize:15];
    self.address.tag = 1000;
    self.address.delegate = self;
    self.address.backgroundColor = [UIColor clearColor];
    self.address.placeholder = @"请在这里记录货源地址";
    [footerView addSubview:self.address];
    
    self.lineTwo = [[UIView alloc]initWithFrame:CGRectMake(5, 40, [UIScreen mainScreen].bounds.size.width - 10, 1)];
    self.lineTwo.backgroundColor = [UIColor lightGrayColor];
    [footerView addSubview:self.lineTwo];
    
    self.price = [[UITextField alloc]initWithFrame:CGRectMake(10, 45, [UIScreen mainScreen].bounds.size.width/2 - 20, 30)];
    self.price.font = [UIFont systemFontOfSize:15];
    self.price.delegate = self;
    self.price.tag = 1001;
    self.price.backgroundColor = [UIColor clearColor];
    self.price.placeholder = @"输入进货价";
    //self.price.keyboardType = UIKeyboardTypeNumberPad;
    [footerView addSubview:self.price];
    
    self.lineThree = [[UIView alloc]initWithFrame:CGRectMake(5, 75, self.price.frame.size.width + 8, 1)];
    self.lineThree.backgroundColor = [UIColor lightGrayColor];
    [footerView addSubview:self.lineThree];
    
    self.agentPrice = [[UITextField alloc]initWithFrame:CGRectMake(self.price.frame.size.width + 27, 45, [UIScreen mainScreen].bounds.size.width/2 - 20, 30)];
    self.agentPrice.font = [UIFont systemFontOfSize:15];
    self.agentPrice.delegate = self;
    self.agentPrice.tag = 1002;
    self.agentPrice.backgroundColor = [UIColor clearColor];
    self.agentPrice.placeholder = @"输入代理价";
    //self.agentPrice.keyboardType = UIKeyboardTypeNumberPad;
    [footerView addSubview:self.agentPrice];
    
    self.lineFour = [[UIView alloc]initWithFrame:CGRectMake(self.agentPrice.frame.origin.x - 5, 75, self.agentPrice.frame.size.width + 8, 1)];
    self.lineFour.backgroundColor = [UIColor lightGrayColor];
    [footerView addSubview:self.lineFour];
    
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadBtn.frame = CGRectMake(5, 77, [UIScreen mainScreen].bounds.size.width - 10, 35);
    [uploadBtn setTitle:@"        开始上传" forState:0];
    [uploadBtn setTitleColor:[UIColor blackColor] forState:0];
    [uploadBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [uploadBtn setBackgroundImage:[UIImage imageNamed:@"long_button.png"] forState:0];
    [uploadBtn setBackgroundImage:[UIImage imageNamed:@"long_button_over.png"] forState:UIControlStateHighlighted];
    [uploadBtn addTarget:self action:@selector(uploadImageAtion:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *uploadIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 25, 25)];
    uploadIcon.image = [UIImage imageNamed:@"up_icon.png"];
    [uploadBtn addSubview:uploadIcon];
    
    [footerView addSubview:uploadBtn];
    
    self.imagesView = [[UIView alloc]initWithFrame:CGRectMake(0, 115, 320, 200)];
    
    self.chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chooseBtn.frame = CGRectMake(5, 5, 60, 60);
    [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"icon_addpic_unfocused.png"] forState:0];
    [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"icon_addpic_focused.png"] forState:UIControlStateHighlighted];
    [self.chooseBtn addTarget:self action:@selector(chooseImages:) forControlEvents:UIControlEventTouchUpInside];
    [self.imagesView addSubview:self.chooseBtn];
    
    [footerView addSubview:self.imagesView];
    footerView.frame = CGRectMake(0, 0, 320, 320);
    self.table.tableFooterView = footerView;
    
}

- (void)uploadImageAtion:(UIButton *)sender
{
    if (![[self.describeText.text stringByReplacingOccurrencesOfString:@" " withString:@""]isEqualToString:@""] && ![[self.address.text stringByReplacingOccurrencesOfString:@" " withString:@""]isEqualToString:@""] && ![[self.price.text stringByReplacingOccurrencesOfString:@" " withString:@""]isEqualToString:@""] && ![[self.agentPrice.text stringByReplacingOccurrencesOfString:@" " withString:@""]isEqualToString:@""])
    {
        
        if (self.describeText.text.length < 15) {
            [self.view LabelTitle:@"产品描述过短！"];
            return;
        }
        for (int i = 0; i < self.data.count; i++) {
            if ([[self.data objectAtIndex:i] rangeOfString:@"产品类型"].location != NSNotFound) {
                if (_lx == nil) {
                    [self.view LabelTitle:@"请选择类型信息"];
                    return;
                }
            }else if ([[self.data objectAtIndex:i] rangeOfString:@"适用人群"].location != NSNotFound){
                if (_xb == nil) {
                    [self.view LabelTitle:@"请选择类型信息"];
                    return;
                }
            }else if ([[self.data objectAtIndex:i] rangeOfString:@"售后服务"].location != NSNotFound){
                if (_ss == nil) {
                    [self.view LabelTitle:@"请选择类型信息"];
                    return;
                }
            }else if ([[self.data objectAtIndex:i] rangeOfString:@"鞋子类型"].location != NSNotFound){
                if (_sts == nil) {
                    [self.view LabelTitle:@"请选择类型信息"];
                    return;
                }
            }else if ([[self.data objectAtIndex:i] rangeOfString:@"手表机芯"].location != NSNotFound){
                if (_cs == nil) {
                    [self.view LabelTitle:@"请选择类型信息"];
                    return;
                }
            }else if ([[self.data objectAtIndex:i] rangeOfString:@"手表表带"].location != NSNotFound){
                if (_ws == nil) {
                    [self.view LabelTitle:@"请选择类型信息"];
                    return;
                }
            }else if ([[self.data objectAtIndex:i] rangeOfString:@"包包类型"].location != NSNotFound){
                if (_bts == nil) {
                    [self.view LabelTitle:@"请选择类型信息"];
                    return;
                }
            }else if ([[self.data objectAtIndex:i] rangeOfString:@"产品品质"].location != NSNotFound){
                if (_bqs == nil) {
                    [self.view LabelTitle:@"请选择类型信息"];
                    return;
                }
            }else if ([[self.data objectAtIndex:i] rangeOfString:@"服装类型"].location != NSNotFound){
                if (_cts == nil) {
                    [self.view LabelTitle:@"请选择类型信息"];
                    return;
                }
            }else if ([[self.data objectAtIndex:i] rangeOfString:@"彩妆类型"].location != NSNotFound){
                if (_mts == nil) {
                    [self.view LabelTitle:@"请选择类型信息"];
                    return;
                }
            }else if ([[self.data objectAtIndex:i] rangeOfString:@"鞋跟高度"].location != NSNotFound){
                if (_shh == nil) {
                    [self.view LabelTitle:@"请选择类型信息"];
                    return;
                }
            }else if ([[self.data objectAtIndex:i] rangeOfString:@"产品品牌"].location != NSNotFound){
                if (_pps == nil) {
                    [self.view LabelTitle:@"请选择类型信息"];
                    return;
                }
            }
        }
        
        if ([self.price.text stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length >0 || [self.agentPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length >0) {
            [self.view LabelTitle:@"价格请输入纯数字"];
            return;
        }
        if (_images.count > 0) {
            NSDate *date = [NSDate date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSInteger interval = [zone secondsFromGMTForDate: date];
            NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
            NSString *timeSp = [NSString stringWithFormat:@"%.0f", [localeDate timeIntervalSince1970]*1000];
            NSLog(@"timeSp:%@",timeSp); //时间戳的值
            
            UserEntity *ue = [UserEntity shareCurrentUe];
            cpid = [NSString stringWithFormat:@"%@%d",timeSp,ue.Id];
            
            //数据要提交到此url
            _spinner = [self.view showSpinner:0 Title:[NSString stringWithFormat:@"正在上传 0/%d",_images.count]];
            queue = [[NSOperationQueue alloc]init];
            [queue setMaxConcurrentOperationCount:1];
            for (int i = 0; i < _images.count; i++) {
                NSString *url = [NSString stringWithFormat:@"http://115.28.17.18:8080/service/upload.do?cpid=%@&name=%d.jpg",cpid,i];
                UploadOperation *operation = [[UploadOperation alloc]initWithTarget:self selector:@selector(uploadFinish:) url:url image:[_images objectAtIndex:i]];
                [queue addOperation:operation];
            }
        }else{
            [self.view LabelTitle:@"请选择图片"];
            return;
        }
    }else{
        [self.view LabelTitle:@"信息不完整，请继续填写"];
    }
    
}

- (void)uploadFinish:(NSData *)data
{
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    progressNum = progressNum + 1;
    
    if ([str isEqualToString:@"ok"]) {
        [_well addObject:str];
        _spinner.text = [NSString stringWithFormat:@"正在上传 %d/%d",progressNum,_images.count];
    }else{
        [_bad addObject:str];
    }

    if (progressNum == _images.count) {
        ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
        if (_well.count == _images.count) {
            [_bad removeAllObjects];
            [_well removeAllObjects];
            progressNum = 0;
            NSString *text = @"";
            for (int i = 0; i < self.data.count; i++) {
                NSString *title = [self.data objectAtIndex:i];
                if ([title rangeOfString:@"售后服务"].location != NSNotFound) {
                    if (_ss != nil && [_ss intValue] != -1) {
                        if ([text isEqualToString:@""]) {
                            text = [NSString stringWithFormat:@"6_%@",_ss];
                        }else{
                            text = [NSString stringWithFormat:@"%@|6_%@",text,_ss];
                        }
                    }
                }else if ([title rangeOfString:@"鞋子类型"].location != NSNotFound) {
                    if (_sts != nil && [_sts intValue] != -1) {
                        if ([text isEqualToString:@""]) {
                            text = [NSString stringWithFormat:@"9_%@",_sts];
                        }else{
                            text = [NSString stringWithFormat:@"%@|9_%@",text,_sts];
                        }
                    }
                }else if ([title rangeOfString:@"手表机芯"].location != NSNotFound) {
                    if (_cs != nil && [_cs intValue] != -1) {
                        if ([text isEqualToString:@""]) {
                            text = [NSString stringWithFormat:@"3_%@",_cs];
                        }else{
                            text = [NSString stringWithFormat:@"%@|3_%@",text,_cs];
                        }
                    }
                }else if ([title rangeOfString:@"手表表带"].location != NSNotFound) {
                    if (_ws != nil && [_ws intValue] != -1) {
                        if ([text isEqualToString:@""]) {
                            text = [NSString stringWithFormat:@"10_%@",_ws];
                        }else{
                            text = [NSString stringWithFormat:@"%@|10_%@",text,_ws];
                        }
                    }
                }else if ([title rangeOfString:@"包包类型"].location != NSNotFound) {
                    if (_bts != nil && [_bts intValue] != -1) {
                        if ([text isEqualToString:@""]) {
                            text = [NSString stringWithFormat:@"2_%@",_bts];
                        }else{
                            text = [NSString stringWithFormat:@"%@|2_%@",text,_bts];
                        }
                    }
                }else if ([title rangeOfString:@"产品品质"].location != NSNotFound) {
                    if (_bqs != nil && [_bqs intValue] != -1) {
                        if ([text isEqualToString:@""]) {
                            text = [NSString stringWithFormat:@"1_%@",_bqs];
                        }else{
                            text = [NSString stringWithFormat:@"%@|1_%@",text,_bqs];
                        }
                    }
                }else if ([title rangeOfString:@"服装类型"].location != NSNotFound) {
                    if (_cts != nil && [_cts intValue] != -1) {
                        if ([text isEqualToString:@""]) {
                            text = [NSString stringWithFormat:@"4_%@",_cts];
                        }else{
                            text = [NSString stringWithFormat:@"%@|4_%@",text,_cts];
                        }
                    }
                }else if ([title rangeOfString:@"彩妆类型"].location != NSNotFound) {
                    if (_mts != nil && [_mts intValue] != -1) {
                        if ([text isEqualToString:@""]) {
                            text = [NSString stringWithFormat:@"12_%@",_mts];
                        }else{
                            text = [NSString stringWithFormat:@"%@|12_%@",text,_mts];
                        }
                    }
                }else if ([title rangeOfString:@"鞋跟高度"].location != NSNotFound) {
                    if (_shh != nil && [_shh intValue] != -1) {
                        if ([text isEqualToString:@""]) {
                            text = [NSString stringWithFormat:@"7_%@",_shh];
                        }else{
                            text = [NSString stringWithFormat:@"%@|7_%@",text,_shh];
                        }
                    }
                }
            }
            
            UserEntity *ue = [UserEntity shareCurrentUe];
            NSDictionary *params;
            if (self.addressText) {
                params = @{@"interface": UPLOAD_CHANPIN,@"code": @"1",@"tempId": cpid,@"uname": ue.userName,@"uuid": ue.uuid,@"miaoshu": self.describeText.text,@"pinpai": _pps,@"leixing": _lx,@"xingbie": _xb,@"jiage": self.price.text,@"pics": [NSString stringWithFormat:@"%d",_images.count],@"price": self.agentPrice.text,@"categorys": text,@"dangkou": self.address.text,@"dataVersions":ob.dataVersions};
            }else{
                params = @{@"interface": UPLOAD_CHANPIN,@"code": @"1",@"tempId": cpid,@"uname": ue.userName,@"uuid": ue.uuid,@"miaoshu": self.describeText.text,@"pinpai": _pps,@"leixing": _lx,@"xingbie": _xb,@"jiage": self.price.text,@"pics": [NSString stringWithFormat:@"%d",_images.count],@"price": self.agentPrice.text,@"categorys": text,@"dangkou": self.address.text,@"isSelf": @"1",@"dataVersions":ob.dataVersions};
            }
            [[HttpService sharedInstance]postRequestWithUrl:DEFAULT_URL params:params completionBlock:^(id object) {
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
                NSDictionary *objectVoDic = [ovo JSONValue];
                NSString *code = [objectVoDic valueForKey:@"code"];
//                NSLog(@"%@",[objectVoDic valueForKey:@"msg"]);
                if ([code intValue] == 0) {
                    [self.view LabelTitle:@"上传完成！"];
                    
                    self.describeText.text = nil;
                    self.price.text = nil;
                    self.agentPrice.text = nil;
                    [_images removeAllObjects];
                    [self.imagesView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    self.chooseBtn.frame = CGRectMake(5, 5, 60, 60);
                    [self.imagesView addSubview:self.chooseBtn];
                    [self.table reloadData];
                    [queue cancelAllOperations];
                    [self.view endSynRequestSignal];
                }else{
                    [self.view endSynRequestSignal];
                    [self.view LabelTitle:[objectVoDic valueForKey:@"msg"]];
//                    NSLog(@"msg=%@",[objectVoDic valueForKey:@"msg"]);
                }
            } failureBlock:^(NSError *error, NSString *responseString) {
//                NSLog(@"error = %@,%@",error.description,responseString);
                [self.view endSynRequestSignal];
                UIAlertView *alert;
                if ([error.description rangeOfString:@"Code=-1001"].location != NSNotFound) {
                    alert = [[UIAlertView alloc]initWithTitle:nil message:@"请求超时" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新上传", nil];
                }else if ([error.description rangeOfString:@"Code=-1004"].location != NSNotFound){
                    alert = [[UIAlertView alloc]initWithTitle:nil message:@"未连接服务器" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新上传", nil];
                }else{
                    alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络异常" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新上传", nil];
                }
                [alert show];
                alert = nil;
            }];
            
        }else{
            [self.view endSynRequestSignal];
            [_bad removeAllObjects];
            [_well removeAllObjects];
            _bad = nil;
            _well = nil;
            progressNum = 0;
            UserEntity *ue = [UserEntity shareCurrentUe];
            NSDictionary *params = @{@"interface": UPLOAD_CHANPIN,@"code": @"1",@"tempId": cpid,@"uname": ue.userName,@"uuid": ue.uuid,@"miaoshu": self.describeText.text,@"pinpai": @"0",@"leixing": _lx,@"xingbie": _xb,@"jiage": self.price.text,@"pics": [NSString stringWithFormat:@"%d",_images.count],@"price": self.agentPrice.text,@"categorys": @"",@"dangkou": self.address.text,@"dataVersions":ob.dataVersions};
            [[HttpService sharedInstance]postRequestWithUrl:DEFAULT_URL params:params completionBlock:^(id object) {
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
                NSDictionary *objectVoDic = [ovo JSONValue];
                NSString *code = [objectVoDic valueForKey:@"code"];
                
                if ([code intValue] == 0) {
                    [self.view LabelTitle:@"上传失败！"];
                }else{
                    [self.view LabelTitle:[objectVoDic valueForKey:@"msg"]];
                }
            } failureBlock:^(NSError *error, NSString *responseString) {
//                NSLog(@"_________er = %@,%@",error.description,responseString);
                UIAlertView *alert;
                if ([error.description rangeOfString:@"Code=-1001"].location != NSNotFound) {
                    alert = [[UIAlertView alloc]initWithTitle:nil message:@"请求超时" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新上传", nil];
                }else if ([error.description rangeOfString:@"Code=-1004"].location != NSNotFound){
                    alert = [[UIAlertView alloc]initWithTitle:nil message:@"未连接服务器" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新上传", nil];
                }else{
                    alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络异常" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新上传", nil];
                }
                [alert show];
                alert = nil;
            }];
        }
    }
}

- (void)chooseImages:(UIButton *)sender
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 9 - _images.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)deleteImage:(UIButton *)sender
{
    [self.imagesView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_images removeObjectAtIndex:sender.tag - 1000];
    
    for (int j = 0; j< _images.count; j++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (j < 4) {
            btn.frame = CGRectMake(5 + j%4*70, 5, 60, 60);
        }else if (j < 8){
            btn.frame = CGRectMake(5 + j%4*70, 5 + 65, 60, 60);
        }else{
            btn.frame = CGRectMake(5 + j%4*70, 5 + 130, 60, 60);
        }
        btn.tag = 1000 + j;
        [btn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[_images objectAtIndex:j] forState:0];
        [self.imagesView addSubview:btn];
    }
    if (_images.count < 9) {
        if (_images.count < 4) {
            self.chooseBtn.frame = CGRectMake(5 + _images.count%4*70, 5, 60, 60);
        }else if (_images.count < 8){
            self.chooseBtn.frame = CGRectMake(5 + _images.count%4*70, 5 + 65, 60, 60);
        }else{
            self.chooseBtn.frame = CGRectMake(5, 5 + 140, 60, 60);
        }
        [self.imagesView addSubview:self.chooseBtn];
    }
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [self.imagesView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //
        });
        
        for (int i=0; i < assets.count; i++) {
            ALAsset *asset=assets[i];
//            NSLog(@"%lld",asset.defaultRepresentation.size);//图片的大小
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [_images addObject:tempImg];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int j = 0; j< _images.count; j++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (j < 4) {
                    btn.frame = CGRectMake(5 + j%4*70, 5, 60, 60);
                }else if (j < 8){
                    btn.frame = CGRectMake(5 + j%4*70, 5 + 65, 60, 60);
                }else{
                    btn.frame = CGRectMake(5 + j%4*70, 5 + 130, 60, 60);
                }
                btn.tag = 1000 + j;
                [btn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundImage:[_images objectAtIndex:j] forState:0];
                [self.imagesView addSubview:btn];
                UIImageJPEGRepresentation(nil, 1.0);
            }
            if (_images.count < 9) {
                if (_images.count < 4) {
                    self.chooseBtn.frame = CGRectMake(5 + _images.count%4*70, 5, 60, 60);
                }else if (_images.count < 8){
                    self.chooseBtn.frame = CGRectMake(5 + _images.count%4*70, 5 + 65, 60, 60);
                }else{
                    self.chooseBtn.frame = CGRectMake(5, 5 + 140, 60, 60);
                }
                [self.imagesView addSubview:self.chooseBtn];
            }
        });
    });
}

#pragma mark - tableView -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    ApplicablePeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ApplicablePeopleCell" owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell.btn setTitle:[NSString stringWithFormat:@"  %@",[self.data objectAtIndex:indexPath.row]] forState:0];
    
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    NSDictionary *baseData = [ob valueForKey:@"baseData"];
    if ([cell.btn.titleLabel.text rangeOfString:@"鞋子类型"].location != NSNotFound && _sts != nil) {
        NSArray *sts = [baseData valueForKey:@"sts"];
        for (int i = 0; i < sts.count; i++) {
            if ([[sts objectAtIndex:i] valueForKey:@"id"] == _sts && [_sts intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  鞋子类型：%@",[[sts objectAtIndex:i] valueForKey:@"name"]] forState:0];
            }
        }
    }else if ([cell.btn.titleLabel.text rangeOfString:@"手表机芯"].location != NSNotFound && _cs != nil) {
        NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
        NSArray *cs = [baseData valueForKey:@"cs"];
        for (int i = 0; i < cs.count; i++) {
            if ([[cs objectAtIndex:i] valueForKey:@"id"] == _cs && [_cs intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  手表机芯：%@",[[cs objectAtIndex:i] valueForKey:@"name"]] forState:0];
            }
        }
    }else if ([cell.btn.titleLabel.text rangeOfString:@"手表表带"].location != NSNotFound && _ws != nil) {
        NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
        NSArray *ws = [baseData valueForKey:@"ws"];
        for (int i = 0; i < ws.count; i++) {
            if ([[ws objectAtIndex:i] valueForKey:@"id"] == _ws && [_ws intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  手表表带：%@",[[ws objectAtIndex:i] valueForKey:@"name"]] forState:0];
            }
        }
    }else if ([cell.btn.titleLabel.text rangeOfString:@"包包类型"].location != NSNotFound && _bts != nil) {
        NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
        NSArray *bts = [baseData valueForKey:@"bts"];
        for (int i = 0; i < bts.count; i++) {
            if ([[bts objectAtIndex:i] valueForKey:@"id"] == _bts && [_bts intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  包包类型：%@",[[bts objectAtIndex:i] valueForKey:@"name"]] forState:0];
            }
        }
    }else if ([cell.btn.titleLabel.text rangeOfString:@"产品品质"].location != NSNotFound && _bqs != nil) {
        NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
        NSArray *bqs = [baseData valueForKey:@"bqs"];
        for (int i = 0; i < bqs.count; i++) {
            if ([[bqs objectAtIndex:i] valueForKey:@"id"] == _bqs && [_bqs intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  产品品质：%@",[[bqs objectAtIndex:i] valueForKey:@"name"]] forState:0];
            }
        }
    }else if ([cell.btn.titleLabel.text rangeOfString:@"服装类型"].location != NSNotFound && _cts != nil) {
        NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
        NSArray *cts = [baseData valueForKey:@"cts"];
        for (int i = 0; i < cts.count; i++) {
            if ([[cts objectAtIndex:i] valueForKey:@"id"] == _cts && [_cts intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  服装类型：%@",[[cts objectAtIndex:i] valueForKey:@"name"]] forState:0];
            }
        }
    }else if ([cell.btn.titleLabel.text rangeOfString:@"彩妆类型"].location != NSNotFound && _mts != nil) {
        NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
        NSArray *mts = [baseData valueForKey:@"mts"];
        for (int i = 0; i < mts.count; i++) {
            if ([[mts objectAtIndex:i] valueForKey:@"id"] == _mts && [_mts intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  彩妆类型：%@",[[mts objectAtIndex:i] valueForKey:@"name"]] forState:0];
            }
        }
    }else if ([cell.btn.titleLabel.text rangeOfString:@"鞋跟高度"].location != NSNotFound && _shh != nil) {
        NSLog(@"cell.text = %@,%@",cell.btn.titleLabel.text,_shh);
        NSArray *shh = [baseData valueForKey:@"shhs"];
        for (int i = 0; i < shh.count; i++) {
            if ([[shh objectAtIndex:i] valueForKey:@"id"] == _shh && [_shh intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  鞋跟高度：%@",[[shh objectAtIndex:i] valueForKey:@"name"]] forState:0];
            }
        }
    }else if ([cell.btn.titleLabel.text rangeOfString:@"产品类型"].location != NSNotFound && _lx != nil) {
        NSArray *lxs = [baseData valueForKey:@"lxs"];
        for (int i = 0; i < lxs.count; i++) {
            if ([[lxs objectAtIndex:i] valueForKey:@"id"] == _lx && [_lx intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  产品类型：%@",[[lxs objectAtIndex:i] valueForKey:@"name"]] forState:0];
            }
        }
    }else if ([cell.btn.titleLabel.text rangeOfString:@"适用人群"].location != NSNotFound && _xb != nil) {
        NSArray *xbs = [baseData valueForKey:@"xbs"];
        for (int i = 0; i < xbs.count; i++) {
            if ([[xbs objectAtIndex:i] valueForKey:@"id"] == _xb && [_xb intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  适用人群：%@",[[xbs objectAtIndex:i] valueForKey:@"name"]] forState:0];
            }
        }
    }else if ([cell.btn.titleLabel.text rangeOfString:@"售后服务"].location != NSNotFound && _ss != nil) {
        NSArray *ss = [baseData valueForKey:@"ss"];
        for (int i = 0; i < ss.count; i++) {
            if ([[ss objectAtIndex:i] valueForKey:@"id"] == _ss && [_ss intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  售后服务：%@",[[ss objectAtIndex:i] valueForKey:@"name"]] forState:0];
            }
        }
    }else if ([cell.btn.titleLabel.text rangeOfString:@"产品品牌"].location != NSNotFound &&_pps != nil) {
        NSArray *pps = [baseData valueForKey:@"pps"];
        for (int i = 0; i < pps.count; i++) {
            if ([[pps objectAtIndex:i] valueForKey:@"id"] == _pps && [_pps intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  产品品牌：%@(%@)",[[pps objectAtIndex:i] valueForKey:@"ename"],[[pps objectAtIndex:i] valueForKey:@"cname"]] forState:0];
            }
        }
    }

    return cell;
}

- (void)seletedAction:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    NSDictionary *baseData = [ob valueForKey:@"baseData"];
    NSArray *arr = [baseData valueForKey:@"lxs"];
    NSMutableArray *contents = [[NSMutableArray alloc]init];
    if (indexPath.row == 0) {
        for (int i = 0; i < arr.count; i++) {
            [contents addObject:[[arr objectAtIndex:i] valueForKey:@"name"]];
        }
    }else{
        if ([[self.data objectAtIndex:indexPath.row] isEqualToString:@"选择适用人群"]) {
            _contentsArr = [baseData valueForKey:@"xbs"];
        }else if ([[self.data objectAtIndex:indexPath.row] isEqualToString:@"选择售后服务"]){
            _contentsArr = [baseData valueForKey:@"ss"];
        }else if ([[self.data objectAtIndex:indexPath.row] isEqualToString:@"选择鞋子类型"]){
            _contentsArr = [baseData valueForKey:@"sts"];
        }else if ([[self.data objectAtIndex:indexPath.row] isEqualToString:@"选择产品材质"]){
            _contentsArr =[baseData valueForKey:@"ms"];
        }else if ([[self.data objectAtIndex:indexPath.row] isEqualToString:@"选择闭合方式"]){
            _contentsArr =[baseData valueForKey:@"bhs"];
        }else if ([[self.data objectAtIndex:indexPath.row] isEqualToString:@"选择手表机芯"]){
            _contentsArr =[baseData valueForKey:@"cs"];
        }else if ([[self.data objectAtIndex:indexPath.row] isEqualToString:@"选择手表表带"]){
            _contentsArr =[baseData valueForKey:@"ws"];
        }else if ([[self.data objectAtIndex:indexPath.row] isEqualToString:@"选择包包类型"]){
            _contentsArr =[baseData valueForKey:@"bts"];
        }else if ([[self.data objectAtIndex:indexPath.row] isEqualToString:@"选择产品品质"]){
            _contentsArr =[baseData valueForKey:@"bqs"];
        }else if ([[self.data objectAtIndex:indexPath.row] isEqualToString:@"选择服装类型"]){
            _contentsArr =[baseData valueForKey:@"cts"];
        }else if ([[self.data objectAtIndex:indexPath.row] isEqualToString:@"选择彩妆类型"]){
            _contentsArr =[baseData valueForKey:@"mts"];
        }else if ([[self.data objectAtIndex:indexPath.row] isEqualToString:@"选择鞋跟高度"]){
            _contentsArr =[baseData valueForKey:@"shhs"];
        }else if ([[self.data objectAtIndex:indexPath.row] isEqualToString:@"选择产品品牌"]){
            _contentsArr =[baseData valueForKey:@"pps"];
            for (int i = 0; i < _contentsArr.count; i++) {
                NSString *str = [NSString stringWithFormat:@"%@(%@)",[[_contentsArr objectAtIndex:i] valueForKey:@"ename"],[[_contentsArr objectAtIndex:i] valueForKey:@"cname"]];
                [contents addObject:str];
            }
            ApplicablePeopleViewController *applicablePeopleViewController = [[ApplicablePeopleViewController alloc]initWithNibName:@"ApplicablePeopleViewController" bundle:nil data:contents indexPath:indexPath title:[self.data objectAtIndex:indexPath.row]];
            [applicablePeopleViewController setHidesBottomBarWhenPushed:YES];
            applicablePeopleViewController.delegate = self;
            [self.navigationController pushViewController:applicablePeopleViewController animated:YES];
            applicablePeopleViewController = nil;
            return;
        }
        for (int i = 0; i < _contentsArr.count; i++) {
            NSString *str = [[_contentsArr objectAtIndex:i] valueForKey:@"name"];
            [contents addObject:str];
        }
    }
    
    ApplicablePeopleViewController *applicablePeopleViewController = [[ApplicablePeopleViewController alloc]initWithNibName:@"ApplicablePeopleViewController" bundle:nil data:contents indexPath:indexPath title:[self.data objectAtIndex:indexPath.row]];
    [applicablePeopleViewController setHidesBottomBarWhenPushed:YES];
    applicablePeopleViewController.delegate = self;
    [self.navigationController pushViewController:applicablePeopleViewController animated:YES];
    applicablePeopleViewController = nil;
}

#pragma mark - ApplicablePeopleViewControllerDelegate -
- (void)changeTitle:(NSString *)aStr indexPath:(NSIndexPath *)indexPath apIndexPath:(NSIndexPath *)apIndexPath
{
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    NSDictionary *baseData = [ob valueForKey:@"baseData"];
    NSArray *arr = [baseData valueForKey:@"lxs"];
    if (indexPath.row == 0) {
        _lx = [[arr objectAtIndex:apIndexPath.row] valueForKey:@"id"];
        
        if ([aStr rangeOfString:@"其他"].location != NSNotFound) {
            self.data = _other;
        }else if ([aStr rangeOfString:@"鞋子"].location != NSNotFound){
            self.data = _shoes;
        }else if ([aStr rangeOfString:@"手表"].location != NSNotFound){
            self.data = _watch;
        }else if ([aStr rangeOfString:@"包包"].location != NSNotFound){
            self.data = _bag;
        }else if ([aStr rangeOfString:@"皮夹"].location != NSNotFound){
            self.data = _wallet;
        }else if ([aStr rangeOfString:@"丝巾"].location != NSNotFound){
            self.data = _silk;
        }else if ([aStr rangeOfString:@"皮带"].location != NSNotFound){
            self.data = _belt;
        }else if ([aStr rangeOfString:@"衣服"].location != NSNotFound){
            self.data = _clothes;
        }else if ([aStr rangeOfString:@"帽子"].location != NSNotFound){
            self.data = _hat;
        }else if ([aStr rangeOfString:@"眼镜"].location != NSNotFound){
            self.data = _glasses;
        }else if ([aStr rangeOfString:@"首饰"].location != NSNotFound){
            self.data = _jewelry;
        }else if ([aStr rangeOfString:@"护肤彩妆"].location != NSNotFound){
            self.data = _cosmetics;
        }
        if ([_xb intValue] == 3 && [aStr rangeOfString:@"鞋子"].location != NSNotFound) {
            self.data = _gShoes;
        }
        [self.table reloadData];
        //[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(tableViewControllerReloadData) userInfo:nil repeats:NO];
         ApplicablePeopleCell *cell = (ApplicablePeopleCell *)[self.table cellForRowAtIndexPath:indexPath];
        [cell.btn setTitle:aStr forState:0];
        
    }else{
        if (indexPath.row == 1) {
            if ([_lx intValue] == 1) {
                if ([_lx intValue] == 1 && [aStr rangeOfString:@"女士"].location != NSNotFound) {
                    self.data = _gShoes;
                    [self.table reloadData];
                    //[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(tableViewControllerReloadData) userInfo:nil repeats:NO];
                }else{
                    self.data = _shoes;
                    [self.table reloadData];
                    //[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(tableViewControllerReloadData) userInfo:nil repeats:NO];
                }
            }
        }
        
        NSMutableArray *_ids = [[NSMutableArray alloc]init];
        for (int i = 0; i < _contentsArr.count; i++) {
            NSString *str = [[_contentsArr objectAtIndex:i] valueForKey:@"id"];
            [_ids addObject:str];
        }
        ApplicablePeopleCell *cell = (ApplicablePeopleCell *)[self.table cellForRowAtIndexPath:indexPath];
        
        if ([[_ids objectAtIndex:apIndexPath.row] intValue] == -1) {
            NSString *title;
            if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"适用人群"].location != NSNotFound) {
                title = @"  选择适用人群";
            }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"售后服务"].location != NSNotFound){
                title = @"  选择售后服务";
            }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"鞋子类型"].location != NSNotFound){
                title = @"  选择鞋子类型";
            }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"材质"].location != NSNotFound){
                title = @"  选择产品材质";
            }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"闭合方式"].location != NSNotFound){
                title = @"  选择闭合方式";
            }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"机芯"].location != NSNotFound){
                title = @"  选择手表机芯";
            }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"表带"].location != NSNotFound){
                title = @"  选择手表表带";
            }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"包包类型"].location != NSNotFound){
                title = @"  选择包包类型";
            }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"品质"].location != NSNotFound){
                title = @"  选择产品品质";
            }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"服装类型"].location != NSNotFound){
                title = @"  选择服装类型";
            }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"彩妆类型"].location != NSNotFound){
                title = @"  选择彩妆类型";
            }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"鞋跟高度"].location != NSNotFound){
                title = @"  选择鞋跟高度";
            }else if ([[[_contentsArr objectAtIndex:apIndexPath.row] valueForKey:@"name"] rangeOfString:@"产品品牌"].location != NSNotFound){
                title = @"  选择产品品牌";
            }
            
            [cell.btn setTitle:title forState:0];
        }else{
            [cell.btn setTitle:aStr forState:0];
        }
        
        if ([cell.btn.titleLabel.text rangeOfString:@"适用人群"].location != NSNotFound) {
            _xb = [_ids objectAtIndex:apIndexPath.row];
        }else if ([cell.btn.titleLabel.text rangeOfString:@"售后服务"].location != NSNotFound){
            _ss = [_ids objectAtIndex:apIndexPath.row];
        }else if ([cell.btn.titleLabel.text rangeOfString:@"鞋子类型"].location != NSNotFound){
            _sts = [_ids objectAtIndex:apIndexPath.row];
        }else if ([cell.btn.titleLabel.text rangeOfString:@"手表机芯"].location != NSNotFound){
            _cs = [_ids objectAtIndex:apIndexPath.row];
        }else if ([cell.btn.titleLabel.text rangeOfString:@"手表表带"].location != NSNotFound){
            _ws = [_ids objectAtIndex:apIndexPath.row];
        }else if ([cell.btn.titleLabel.text rangeOfString:@"包包类型"].location != NSNotFound){
            _bts = [_ids objectAtIndex:apIndexPath.row];
        }else if ([cell.btn.titleLabel.text rangeOfString:@"产品品质"].location != NSNotFound){
            _bqs = [_ids objectAtIndex:apIndexPath.row];
        }else if ([cell.btn.titleLabel.text rangeOfString:@"服装类型"].location != NSNotFound){
            _cts = [_ids objectAtIndex:apIndexPath.row];
        }else if ([cell.btn.titleLabel.text rangeOfString:@"彩妆类型"].location != NSNotFound){
            _mts = [_ids objectAtIndex:apIndexPath.row];
        }else if ([cell.btn.titleLabel.text rangeOfString:@"鞋跟高度"].location != NSNotFound){
            _shh = [_ids objectAtIndex:apIndexPath.row];
        }else if ([cell.btn.titleLabel.text rangeOfString:@"产品品牌"].location != NSNotFound){
            _pps = [_ids objectAtIndex:apIndexPath.row];
        }
    }
}


- (void)clear:(NSString *)aStr indexPath:(NSIndexPath *)indexPath
{
    ApplicablePeopleCell *cell = (ApplicablePeopleCell *)[self.table cellForRowAtIndexPath:indexPath];
    [cell.btn setTitle:aStr forState:0];
    if ([cell.btn.titleLabel.text rangeOfString:@"适用人群"].location != NSNotFound) {
        _xb = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"售后服务"].location != NSNotFound){
        _ss = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"鞋子类型"].location != NSNotFound){
        _sts = nil;
//    }else if ([cell.btn.titleLabel.text rangeOfString:@"产品材质"].location != NSNotFound){
//        _ms = nil;
//    }else if ([cell.btn.titleLabel.text rangeOfString:@"闭合方式"].location != NSNotFound){
//        _bhs = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"手表机芯"].location != NSNotFound){
        _cs = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"手表表带"].location != NSNotFound){
        _ws = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"包包类型"].location != NSNotFound){
        _bts = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"产品品质"].location != NSNotFound){
        _bqs = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"服装类型"].location != NSNotFound){
        _cts = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"彩妆类型"].location != NSNotFound){
        _mts = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"产品类型"].location != NSNotFound){
        _lx = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"鞋跟高度"].location != NSNotFound){
        _shh = nil;
    }else if ([cell.btn.titleLabel.text rangeOfString:@"产品品牌"].location != NSNotFound){
        _pps = nil;
    }

}


#pragma mark - textField -
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1000) {
        self.lineTwo.backgroundColor = [UIColor blueColor];
        self.lineOne.backgroundColor = [UIColor lightGrayColor];
        self.lineThree.backgroundColor = [UIColor lightGrayColor];
        self.lineFour.backgroundColor = [UIColor lightGrayColor];
        if (self.data.count > 2) {
            if ([UIScreen mainScreen].bounds.size.height > 480) {
                if ([UIScreen mainScreen].bounds.size.height < 600) {
                    if (self.data.count > 5) {
                        self.table.contentOffset = CGPointMake(0, 70);
                    }
                }
            }else{
                self.table.contentOffset = CGPointMake(0, 200);
            }
        }
    }else if (textField.tag == 1001){
        self.lineTwo.backgroundColor = [UIColor lightGrayColor];
        self.lineOne.backgroundColor = [UIColor lightGrayColor];
        self.lineThree.backgroundColor = [UIColor blueColor];
        self.lineFour.backgroundColor = [UIColor lightGrayColor];
        if (self.data.count > 1) {
            if ([UIScreen mainScreen].bounds.size.height > 480) {
                if ([UIScreen mainScreen].bounds.size.height < 600) {
                    if (self.data.count > 4) {
                        self.table.contentOffset = CGPointMake(0, 70);
                    }
                }
            }else{
                self.table.contentOffset = CGPointMake(0, 200);
            }
        }
    }else{
        self.lineTwo.backgroundColor = [UIColor lightGrayColor];
        self.lineOne.backgroundColor = [UIColor lightGrayColor];
        self.lineThree.backgroundColor = [UIColor lightGrayColor];
        self.lineFour.backgroundColor = [UIColor blueColor];
        if (self.data.count > 1) {
            if ([UIScreen mainScreen].bounds.size.height > 480) {
                if ([UIScreen mainScreen].bounds.size.height < 600) {
                    if (self.data.count > 4) {
                        self.table.contentOffset = CGPointMake(0, 70);
                    }
                }
            }else{
                self.table.contentOffset = CGPointMake(0, 200);
            }
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1000) {
        self.lineTwo.backgroundColor = [UIColor lightGrayColor];
    }else if (textField.tag == 1001){
        self.lineThree.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.lineFour.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.lineOne.backgroundColor = [UIColor blueColor];
    self.lineFour.backgroundColor = [UIColor lightGrayColor];
    self.lineThree.backgroundColor = [UIColor lightGrayColor];
    self.lineTwo.backgroundColor = [UIColor lightGrayColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.lineOne.backgroundColor = [UIColor lightGrayColor];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //[queue cancelAllOperations];
    
    if ([self.view window] == nil)// 是否是正在使用的视图
    {
        // Add code to preserve data stored in the views that might be
        // needed later.
        
        // Add code to clean up other strong references to the view in
        // the view hierarchy.
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.addressText) {
        self.address.text = self.addressText;
        self.address.enabled = NO;
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self uploadImageAtion:nil];
    }
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

- (void)dealloc
{
    [queue cancelAllOperations];
    queue = nil;
    _lx = nil;
    _xb = nil;
    _ss = nil;
    _sts = nil;
    _cs = nil;
    _ws = nil;
    _bts = nil;
    _bqs = nil;
    _cts = nil;
    _mts = nil;
    _shh = nil;
    _pps = nil;
    _contentsArr = nil;
    _all = nil;
    _other = nil;
    _shoes = nil;
    _watch = nil;
    _bag = nil;
    _wallet = nil;
    _silk = nil;
    _belt = nil;
    _clothes = nil;
    _hat = nil;
    _glasses = nil;
    _jewelry = nil;
    _cosmetics = nil;
    _gShoes = nil;
    
    _images = nil;
    _bad = nil;
    _well = nil;
    cpid = nil;
    _spinner = nil;
    
    self.data = nil;
    self.describeText = nil;
    self.address = nil;
    self.price = nil;
    self.agentPrice = nil;
    self.lineOne = nil;
    self.lineTwo = nil;
    self.lineThree = nil;
    self.lineFour = nil;
    self.chooseBtn = nil;
    self.addressText = nil;
    
    [self setView:nil];
}

@end
