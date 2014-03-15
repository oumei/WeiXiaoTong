//
//  ApplicablePeopleViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-7.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "ApplicablePeopleViewController.h"

@interface ApplicablePeopleViewController ()

@end

@implementation ApplicablePeopleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSArray *)data indexPath:(NSIndexPath *)indexPath title:(NSString *)title
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _contents = data;
        self.indexPath = indexPath;
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.table reloadData];
    _changeData = [[NSArray alloc]initWithArray:_contents];
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 20, 20)];
    backImage.image = [UIImage imageNamed:@"clear_icon.png"];
    [self.back addSubview:backImage];
    backImage = nil;
}

#pragma mark - tableview - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contents.count;
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
    [cell.btn setTitle:[NSString stringWithFormat:@"  %@",[_contents objectAtIndex:indexPath.row]] forState:0];
    return cell;
}

- (IBAction)backAction:(id)sender
{
    NSString *str;
    if ([self.title isEqualToString:@"选择适用人群"]) {
        str = @"  选择适用人群";
    }else if ([self.title isEqualToString:@"选择售后服务"]){
        str = @"  选择售后服务";
    }else if ([self.title isEqualToString:@"选择鞋子类型"]){
        str = @"  选择鞋子类型";
    }else if ([self.title isEqualToString:@"选择产品材质"]){
        str = @"  选择产品材质";
    }else if ([self.title isEqualToString:@"选择闭合方式"]){
        str = @"  选择闭合方式";
    }else if ([self.title isEqualToString:@"选择手表机芯"]){
        str = @"  选择手表机芯";
    }else if ([self.title isEqualToString:@"选择手表表带"]){
        str = @"  选择手表表带";
    }else if ([self.title isEqualToString:@"选择包包类型"]){
        str = @"  选择包包类型";
    }else if ([self.title isEqualToString:@"选择产品品质"]){
        str = @"  选择产品品质";
    }else if ([self.title isEqualToString:@"选择服装类型"]){
        str = @"  选择服装类型";
    }else if ([self.title isEqualToString:@"选择彩妆类型"]){
        str = @"  选择彩妆类型";
    }else if ([self.title isEqualToString:@"选择产品类型"]){
        str = @"  选择产品类型";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clear:indexPath:)]) {
        [self.delegate performSelector:@selector(clear:indexPath:) withObject:str withObject:self.indexPath];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textField -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.back.frame = CGRectMake(self.back.frame.origin.x, self.back.frame.origin.y + 216, self.back.frame.size.width, self.back.frame.size.height);
    }];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        self.back.frame = CGRectMake(self.back.frame.origin.x, self.back.frame.origin.y - 216, self.back.frame.size.width, self.back.frame.size.height);
    }];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _time = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changedata) userInfo:nil repeats:YES];
    return YES;
}

- (void)changedata{
    if ([[self.searchText.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        _contents = _changeData;
    }else{
        NSMutableArray *data = [[NSMutableArray alloc]init];
        for (int i = 0; i < _changeData.count; i++) {
            if ([[_changeData objectAtIndex:i] rangeOfString:self.searchText.text].location != NSNotFound) {
                [data addObject:[_changeData objectAtIndex:i]];
            }
        }
        _contents = data;
    }
    [self.table reloadData];
}

#pragma mark - applicablePeopleCellDelegate -
- (void)seletedAction:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    [_time invalidate];
    NSString *str;
    if ([self.title isEqualToString:@"选择适用人群"]) {
        str = [NSString stringWithFormat:@"  适用人群：%@",[_contents objectAtIndex:indexPath.row]];
    }else if ([self.title isEqualToString:@"选择售后服务"]){
        str = [NSString stringWithFormat:@"  售后服务：%@",[_contents objectAtIndex:indexPath.row]];
    }else if ([self.title isEqualToString:@"选择鞋子类型"]){
        str = [NSString stringWithFormat:@"  鞋子类型：%@",[_contents objectAtIndex:indexPath.row]];
    }else if ([self.title isEqualToString:@"选择产品材质"]){
        str = [NSString stringWithFormat:@"  产品材质：%@",[_contents objectAtIndex:indexPath.row]];
    }else if ([self.title isEqualToString:@"选择闭合方式"]){
        str = [NSString stringWithFormat:@"  闭合方式：%@",[_contents objectAtIndex:indexPath.row]];
    }else if ([self.title isEqualToString:@"选择手表机芯"]){
        str = [NSString stringWithFormat:@"  手表机芯：%@",[_contents objectAtIndex:indexPath.row]];
    }else if ([self.title isEqualToString:@"选择手表表带"]){
        str = [NSString stringWithFormat:@"  手表表带：%@",[_contents objectAtIndex:indexPath.row]];
    }else if ([self.title isEqualToString:@"选择包包类型"]){
        str = [NSString stringWithFormat:@"  包包类型：%@",[_contents objectAtIndex:indexPath.row]];
    }else if ([self.title isEqualToString:@"选择产品品质"]){
        str = [NSString stringWithFormat:@"  产品品质：%@",[_contents objectAtIndex:indexPath.row]];
    }else if ([self.title isEqualToString:@"选择服装类型"]){
        str = [NSString stringWithFormat:@"  服装类型：%@",[_contents objectAtIndex:indexPath.row]];
    }else if ([self.title isEqualToString:@"选择彩妆类型"]){
        str = [NSString stringWithFormat:@"  彩妆类型：%@",[_contents objectAtIndex:indexPath.row]];
    }else if ([self.title isEqualToString:@"选择产品类型"]){
        str = [NSString stringWithFormat:@"  产品类型：%@",[_contents objectAtIndex:indexPath.row]];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeTitle:indexPath:apIndexPath:)]) {
        [self.delegate changeTitle:str indexPath:self.indexPath apIndexPath:indexPath];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
