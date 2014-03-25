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

@interface UploadViewController ()

@end

@implementation UploadViewController
static int progressNum = 0;
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
    _images = [[NSMutableArray alloc]init];
    _bad = [[NSMutableArray alloc]init];
    _well = [[NSMutableArray alloc]init];
    
    self.data = @[@"选择产品类型"];
    _all = @[@"选择产品类型",@"选择适用人群",@"选择售后服务"];
    _other = @[@"选择产品类型",@"选择适用人群",@"选择售后服务"];
    _shoes = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择鞋子类型"];
    _watch = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择手表机芯",@"选择手表表带"];
    _bag = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择包包类型",@"选择产品品质"];
    _wallet = @[@"选择产品类型",@"选择适用人群",@"选择售后服务"];
    _silk = @[@"选择产品类型",@"选择适用人群",@"选择售后服务"];
    _belt = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择产品品质"];
    _clothes = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择服装类型"];
    _hat = @[@"选择产品类型",@"选择适用人群",@"选择售后服务"];
    _glasses = @[@"选择产品类型",@"选择适用人群",@"选择售后服务"];
    _jewelry = @[@"选择产品类型",@"选择适用人群",@"选择售后服务"];
    _cosmetics = @[@"选择产品类型",@"选择适用人群",@"选择售后服务",@"选择彩妆类型"];
    
    //**********************tableHeaderView****************************//
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    
    self.describeText = [[CDTextView alloc]initWithFrame:CGRectMake(5, 5, 310, 50)];
    self.describeText.backgroundColor = [UIColor clearColor];
    self.describeText.font = [UIFont systemFontOfSize:15];
    self.describeText.delegate = self;
    self.describeText.contentSize = [self.describeText.text sizeWithFont:self.describeText.font];
    self.describeText.placeholder = @"请在这里填写产品描述...";
    [headerView addSubview:self.describeText];
    
    self.lineOne = [[UIView alloc]initWithFrame:CGRectMake(5, 55, 310, 1)];
    self.lineOne.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:self.lineOne];

    headerView.frame = CGRectMake(0, 0, 320, 60);
    self.table.tableHeaderView = headerView;
    
    //************************tableFooterView**************************//
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor clearColor];
    
    self.address = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];
    self.address.font = [UIFont systemFontOfSize:15];
    self.address.tag = 1000;
    self.address.delegate = self;
    self.address.backgroundColor = [UIColor clearColor];
    self.address.placeholder = @"请在这里记录货源地址";
    [footerView addSubview:self.address];
    
    self.lineTwo = [[UIView alloc]initWithFrame:CGRectMake(5, 40, 310, 1)];
    self.lineTwo.backgroundColor = [UIColor lightGrayColor];
    [footerView addSubview:self.lineTwo];
    
    self.price = [[UITextField alloc]initWithFrame:CGRectMake(10, 45, 140, 30)];
    self.price.font = [UIFont systemFontOfSize:15];
    self.price.delegate = self;
    self.price.tag = 1001;
    self.price.backgroundColor = [UIColor clearColor];
    self.price.placeholder = @"输入进货价";
    //self.price.keyboardType = UIKeyboardTypeNumberPad;
    [footerView addSubview:self.price];
    
    self.lineThree = [[UIView alloc]initWithFrame:CGRectMake(5, 75, 148, 1)];
    self.lineThree.backgroundColor = [UIColor lightGrayColor];
    [footerView addSubview:self.lineThree];
    
    self.agentPrice = [[UITextField alloc]initWithFrame:CGRectMake(167, 45, 140, 30)];
    self.agentPrice.font = [UIFont systemFontOfSize:15];
    self.agentPrice.delegate = self;
    self.agentPrice.tag = 1002;
    self.agentPrice.backgroundColor = [UIColor clearColor];
    self.agentPrice.placeholder = @"输入代理价";
    //self.agentPrice.keyboardType = UIKeyboardTypeNumberPad;
    [footerView addSubview:self.agentPrice];
    
    self.lineFour = [[UIView alloc]initWithFrame:CGRectMake(162, 75, 148, 1)];
    self.lineFour.backgroundColor = [UIColor lightGrayColor];
    [footerView addSubview:self.lineFour];
    
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadBtn.frame = CGRectMake(5, 77, 310, 35);
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
    
//    self.progress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
//    self.progress.frame=CGRectMake(60, 100, 200, 20);
//    [self.view addSubview:self.progress];
    
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
            if ([[self.data objectAtIndex:i] length] < 5) {
                [self.view LabelTitle:@"请选择类型信息"];
                return;
            }
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
            //NSLog(@"ti:%@",cpid);
            //数据要提交到此url
            _spinner = [self.view showSpinner:0 Title:[NSString stringWithFormat:@"正在上传 0/%d",_images.count]];
            for (int i = 0; i < _images.count; i++) {
                NSString *url = [NSString stringWithFormat:@"http://115.28.17.18:8080/service/upload.do?cpid=%@&name=%d.jpg",cpid,i];
                UploadOperation *operation = [[UploadOperation alloc]initWithTarget:self selector:@selector(uploadFinish:) url:url image:[_images objectAtIndex:i]];
                NSOperationQueue *queue = [[NSOperationQueue alloc]init];
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
    //self.progress.progress = progressNum/_images.count;
    //self.progress.hidden = YES;
    if ([str isEqualToString:@"ok"]) {
        [_well addObject:str];
        _spinner.text = [NSString stringWithFormat:@"正在上传 %d/%d",progressNum,_images.count];
    }else{
        [_bad addObject:str];
    }

    if (progressNum == _images.count) {
        ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
        if (_well.count == _images.count) {
            NSString *text = @"";
            if (_ss != nil && [_ss intValue] != -1) {
                if ([text isEqualToString:@""]) {
                    text = [NSString stringWithFormat:@"6_%@",_ss];
                }else{
                    text = [NSString stringWithFormat:@"%@|6_%@",text,_ss];
                }
            }
            if (_sts != nil && [_sts intValue] != -1) {
                if ([text isEqualToString:@""]) {
                    text = [NSString stringWithFormat:@"9_%@",_sts];
                }else{
                    text = [NSString stringWithFormat:@"%@|9_%@",text,_sts];
                }
            }
            if (_cs != nil && [_cs intValue] != -1) {
                if ([text isEqualToString:@""]) {
                    text = [NSString stringWithFormat:@"3_%@",_cs];
                }else{
                    text = [NSString stringWithFormat:@"%@|3_%@",text,_cs];
                }
            }
            if (_ws != nil && [_ws intValue] != -1) {
                if ([text isEqualToString:@""]) {
                    text = [NSString stringWithFormat:@"10_%@",_ws];
                }else{
                    text = [NSString stringWithFormat:@"%@|10_%@",text,_ws];
                }
            }
            if (_bts != nil && [_bts intValue] != -1) {
                if ([text isEqualToString:@""]) {
                    text = [NSString stringWithFormat:@"2_%@",_bts];
                }else{
                    text = [NSString stringWithFormat:@"%@|2_%@",text,_bts];
                }
            }
            if (_bqs != nil && [_bqs intValue] != -1) {
                if ([text isEqualToString:@""]) {
                    text = [NSString stringWithFormat:@"1_%@",_bqs];
                }else{
                    text = [NSString stringWithFormat:@"%@|1_%@",text,_bqs];
                }
            }
            if (_cts != nil && [_cts intValue] != -1) {
                if ([text isEqualToString:@""]) {
                    text = [NSString stringWithFormat:@"4_%@",_cts];
                }else{
                    text = [NSString stringWithFormat:@"%@|4_%@",text,_cts];
                }
            }
            if (_mts != nil && [_mts intValue] != -1) {
                if ([text isEqualToString:@""]) {
                    text = [NSString stringWithFormat:@"12_%@",_mts];
                }else{
                    text = [NSString stringWithFormat:@"%@|12_%@",text,_mts];
                }
            }
            UserEntity *ue = [UserEntity shareCurrentUe];
            NSDictionary *params = @{@"interface": UPLOAD_CHANPIN,@"code": @"1",@"tempId": cpid,@"uname": ue.userName,@"uuid": ue.uuid,@"miaoshu": self.describeText.text,@"pinpai": @"0",@"leixing": _lx,@"xingbie": _xb,@"jiage": self.price.text,@"pics": [NSString stringWithFormat:@"%d",_images.count],@"price": self.agentPrice.text,@"categorys": text,@"dangkou": self.address.text,@"isSelf": @"1",@"dataVersions":ob.dataVersions};
            [[HttpService sharedInstance]postRequestWithUrl:DEFAULT_URL params:params completionBlock:^(id object) {
                NSString *ovo = [object valueForKey:@"ovo"];
                NSDictionary *objectVoDic = [ovo JSONValue];
                NSString *code = [objectVoDic valueForKey:@"code"];
                NSLog(@"%@",[objectVoDic valueForKey:@"msg"]);
                if ([code intValue] == 0) {
                    [self.view LabelTitle:@"上传完成！"];
                    
                    self.describeText.text = nil;
                    self.address.text = nil;
                    self.price.text = nil;
                    self.agentPrice.text = nil;
                    _images = nil;
                    [_bad removeAllObjects];
                    [_well removeAllObjects];
                    _bad = nil;
                    _well = nil;
                    progressNum = 0;
                    [self.imagesView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    self.chooseBtn.frame = CGRectMake(5, 5, 60, 60);
                    [self.imagesView addSubview:self.chooseBtn];
                    [self.table reloadData];
                    [self.view endSynRequestSignal];
                }else{
                    [self.view endSynRequestSignal];
                    [self.view LabelTitle:[objectVoDic valueForKey:@"msg"]];
                }
            } failureBlock:^(NSError *error, NSString *responseString) {
                [self.view endSynRequestSignal];
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
                NSString *ovo = [object valueForKey:@"ovo"];
                NSDictionary *objectVoDic = [ovo JSONValue];
                NSString *code = [objectVoDic valueForKey:@"code"];
                //            NSLog(@"%@",[objectVoDic valueForKey:@"msg"]);
                if ([code intValue] == 0) {
                    [self.view LabelTitle:@"上传失败！"];
                }
            } failureBlock:^(NSError *error, NSString *responseString) {
                //
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
        [self.table reloadData];
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(tableViewControllerReloadData) userInfo:nil repeats:NO];
         ApplicablePeopleCell *cell = (ApplicablePeopleCell *)[self.table cellForRowAtIndexPath:indexPath];
        [cell.btn setTitle:aStr forState:0];
        
    }else{
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
        }
    }
}

- (void)tableViewControllerReloadData
{
    //[self.table reloadData];
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    NSDictionary *baseData = [ob valueForKey:@"baseData"];
    NSArray *cells = [self.table visibleCells];
    if (self.data.count > 3) {
        for (int i = 0; i < cells.count - 3; i ++) {
            ApplicablePeopleCell *cell = [cells objectAtIndex:i + 3];
            NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
            if ([cell.btn.titleLabel.text rangeOfString:@"鞋子类型"].location != NSNotFound && _sts != nil) {
                NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
                NSArray *sts = [baseData valueForKey:@"sts"];
                for (int i = 0; i < sts.count; i++) {
                    if ([[sts objectAtIndex:i] valueForKey:@"id"] == _sts && [_sts intValue] != -1) {
                        [cell.btn setTitle:[NSString stringWithFormat:@"  鞋子类型：%@",[[sts objectAtIndex:i] valueForKey:@"name"]] forState:0];
                    }
                }
//            }else if ([cell.btn.titleLabel.text rangeOfString:@"产品材质"].location != NSNotFound && _ms != nil) {
//                NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
//                NSArray *ms = [baseData valueForKey:@"ms"];
//                for (int i = 0; i < ms.count; i++) {
//                    if ([[ms objectAtIndex:i] valueForKey:@"id"] == _ms && [_ms intValue] != -1) {
//                        [cell.btn setTitle:[NSString stringWithFormat:@"  产品材质：%@",[[ms objectAtIndex:i] valueForKey:@"name"]] forState:0];
//                    }
//                }
//            }else if ([cell.btn.titleLabel.text rangeOfString:@"闭合方式"].location != NSNotFound && _bhs != nil) {
//                NSLog(@"cell.text = %@",cell.btn.titleLabel.text);
//                NSArray *bhs = [baseData valueForKey:@"bhs"];
//                for (int i = 0; i < bhs.count; i++) {
//                    if ([[bhs objectAtIndex:i] valueForKey:@"id"] == _bhs && [_bhs intValue] != -1) {
//                        [cell.btn setTitle:[NSString stringWithFormat:@"  闭合方式：%@",[[bhs objectAtIndex:i] valueForKey:@"name"]] forState:0];
//                    }
//                }
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
            }
        }
    }
    if (_xb != nil) {
        ApplicablePeopleCell *cell = [cells objectAtIndex:1];
        NSArray *xbs = [baseData valueForKey:@"xbs"];
        for (int i = 0; i < xbs.count; i++) {
            if ([[xbs objectAtIndex:i] valueForKey:@"id"] == _xb && [_xb intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  适用人群：%@",[[xbs objectAtIndex:i] valueForKey:@"name"]] forState:0];
            }
        }
    }
    if (_ss != nil) {
        ApplicablePeopleCell *cell = [cells objectAtIndex:2];
        NSArray *ss = [baseData valueForKey:@"ss"];
        for (int i = 0; i < ss.count; i++) {
            if ([[ss objectAtIndex:i] valueForKey:@"id"] == _ss && [_ss intValue] != -1) {
                [cell.btn setTitle:[NSString stringWithFormat:@"  售后服务：%@",[[ss objectAtIndex:i] valueForKey:@"name"]] forState:0];
            }
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
                if (self.data.count > 5) {
                    self.table.contentOffset = CGPointMake(0, 100);
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
                if (self.data.count > 4) {
                    self.table.contentOffset = CGPointMake(0, 100);
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
                if (self.data.count > 4) {
                    self.table.contentOffset = CGPointMake(0, 100);
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
    // Dispose of any resources that can be recreated.
}

@end
