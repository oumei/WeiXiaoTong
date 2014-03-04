//
//  CheckApplicationViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-4.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CheckApplicationViewController.h"

@interface CheckApplicationViewController ()

@end

@implementation CheckApplicationViewController

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
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - tableview delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"checkApplicationCell";
    CheckApplicationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CheckApplicationCell" owner:self options:nil] lastObject];
    }
//    cell.userName.text = @"(136546)";
//    cell.uLabel.frame = CGRectMake(5+cell.userName.frame.size.width, cell.uLabel.frame.origin.y, cell.uLabel.frame.size.width, cell.uLabel.frame.size.height);
    return cell;
}

#pragma mark - checkApplication delegate -
- (void)refuse:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)agree:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
