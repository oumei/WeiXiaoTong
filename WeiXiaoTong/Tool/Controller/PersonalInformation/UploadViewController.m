//
//  UploadViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-11.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "UploadViewController.h"
#import "ObjectVo.h"

@interface UploadViewController ()

@end

@implementation UploadViewController

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
    
    self.data = @[@"选择产品类型"];
    _all = @[@"选择适用人群",@"选择售后服务"];
    _other = @[@"选择适用人群",@"选择售后服务"];
    _shoes = @[@"选择适用人群",@"选择售后服务",@"选择鞋子类型",@"选择产品材质",@"选择闭合方式"];
    _watch = @[@"选择适用人群",@"选择售后服务",@"选择手表机芯",@"选择手表表带"];
    _bag = @[@"选择适用人群",@"选择售后服务",@"选择包包类型",@"选择产品品质",@"选择产品材质"];
    _wallet = @[@"选择适用人群",@"选择售后服务"];
    _silk = @[@"选择适用人群",@"选择售后服务",@"选择产品材质"];
    _belt = @[@"选择适用人群",@"选择售后服务",@"选择产品品质",@"选择产品材质"];
    _clothes = @[@"选择适用人群",@"选择售后服务",@"选择服装类型"];
    _hat = @[@"选择适用人群",@"选择售后服务"];
    _glasses = @[@"选择适用人群",@"选择售后服务"];
    _jewelry = @[@"选择适用人群",@"选择售后服务"];
    _cosmetics = @[@"选择适用人群",@"选择售后服务",@"选择彩妆类型"];
    
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
//    self.describeText = nil;
//    self.lineOne = nil;
//    headerView = nil;
    
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
    self.price.keyboardType = UIKeyboardTypeNumberPad;
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
    self.agentPrice.keyboardType = UIKeyboardTypeNumberPad;
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
    
    UIImageView *uploadIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 25, 25)];
    uploadIcon.image = [UIImage imageNamed:@"up_icon.png"];
    [uploadBtn addSubview:uploadIcon];
    
    [footerView addSubview:uploadBtn];
    
    UIButton *uploadImage = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadImage.frame = CGRectMake(5, 115, 60, 60);
    [uploadImage setBackgroundImage:[UIImage imageNamed:@"icon_addpic_unfocused.png"] forState:0];
    [uploadImage setBackgroundImage:[UIImage imageNamed:@"icon_addpic_focused.png"] forState:UIControlStateHighlighted];
    [footerView addSubview:uploadImage];
    
    
    footerView.frame = CGRectMake(0, 0, 320, 320);
    self.table.tableFooterView = footerView;
//    self.address = nil;
//    self.price = nil;
//    self.agentPrice = nil;
//    self.lineTwo = nil;
//    self.lineThree = nil;
//    self.lineFour = nil;
//    uploadBtn = nil;
//    uploadIcon = nil;
//    uploadImage = nil;
//    footerView = nil;
    
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
    NSMutableArray *lxs = [[NSMutableArray alloc]init];
    for (int i = 0; i < arr.count; i++) {
        [lxs addObject:[[arr objectAtIndex:i] valueForKey:@"name"]];
    }
    ApplicablePeopleViewController *applicablePeopleViewController = [[ApplicablePeopleViewController alloc]initWithNibName:@"ApplicablePeopleViewController" bundle:nil data:lxs indexPath:indexPath title:[self.data objectAtIndex:indexPath.row]];
    [applicablePeopleViewController setHidesBottomBarWhenPushed:YES];
    applicablePeopleViewController.delegate = self;
    [self.navigationController pushViewController:applicablePeopleViewController animated:YES];
    applicablePeopleViewController = nil;
}

#pragma mark - ApplicablePeopleViewControllerDelegate -
- (void)changeTitle:(NSString *)aStr indexPath:(NSIndexPath *)indexPath apIndexPath:(NSIndexPath *)apIndexPath
{
    if (indexPath.row == 0) {
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
    }
    ApplicablePeopleCell *cell = (ApplicablePeopleCell *)[self.table cellForRowAtIndexPath:indexPath];
    [cell.btn setTitle:aStr forState:0];
    
}

#pragma mark - textField -
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1000) {
        self.lineTwo.backgroundColor = [UIColor blueColor];
        self.lineOne.backgroundColor = [UIColor lightGrayColor];
        self.lineThree.backgroundColor = [UIColor lightGrayColor];
        self.lineFour.backgroundColor = [UIColor lightGrayColor];
    }else if (textField.tag == 1001){
        self.lineTwo.backgroundColor = [UIColor lightGrayColor];
        self.lineOne.backgroundColor = [UIColor lightGrayColor];
        self.lineThree.backgroundColor = [UIColor blueColor];
        self.lineFour.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.lineTwo.backgroundColor = [UIColor lightGrayColor];
        self.lineOne.backgroundColor = [UIColor lightGrayColor];
        self.lineThree.backgroundColor = [UIColor lightGrayColor];
        self.lineFour.backgroundColor = [UIColor blueColor];
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
