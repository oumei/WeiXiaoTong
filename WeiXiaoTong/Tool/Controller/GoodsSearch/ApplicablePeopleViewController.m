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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSArray *)data indexPath:(NSIndexPath *)indexPath
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _contents = data;
        self.indexPath = indexPath;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.table reloadData];
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

#pragma mark - applicablePeopleCellDelegate -
- (void)seletedAction:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    NSString *str;
    if (self.indexPath.row == 0) {
        str = [NSString stringWithFormat:@"  适用人群：%@",[_contents objectAtIndex:indexPath.row]];
    }else if (self.indexPath.row == 1){
        str = [NSString stringWithFormat:@"  售后服务：%@",[_contents objectAtIndex:indexPath.row]];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeTitle:indexPath:)]) {
        [self.delegate performSelector:@selector(changeTitle:indexPath:) withObject:str withObject:self.indexPath];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
