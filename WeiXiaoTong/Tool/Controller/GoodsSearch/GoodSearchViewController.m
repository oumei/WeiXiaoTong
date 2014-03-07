//
//  GoodSearchViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "GoodSearchViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "UINavigationBar+Custom.h"
#import "TableCell.h"
#import "ObjectVo.h"

@interface GoodSearchViewController ()

@end

@implementation GoodSearchViewController
@synthesize tableViewController = _tableViewController;

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
    
    [self.navigationController.navigationBar setBackgroundImage:[self image]];
    _categorys = [[NSArray alloc]initWithObjects:@"全部", @"其他",@"鞋子",@"手表",@"包包",@"皮夹",@"丝巾",@"皮带",@"衣服",@"帽子",@"眼镜",@"首饰",@"护肤彩妆",nil];
    
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
    
    _categoryArr = [[NSArray alloc]initWithObjects:_all,_other,_shoes,_watch,_bag,_wallet,_silk,_belt,_clothes,_hat,_glasses,_jewelry,_cosmetics, nil];
    
    _tableViewController = [[TableViewController alloc]initWithNibName:@"TableViewController" bundle:nil data:_all];
    _tableViewController.delegate = self;
    //[_tableViewController.view setFrame:CGRectMake(0, 0, 320, 568)];
    [self.view insertSubview:_tableViewController.view atIndex:0];
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

- (IBAction)cancelAction:(id)sender
{
    //
}

#pragma mark - tableView delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _categorys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"categoryCell";
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoryCell" owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell.categoryBtn setTitle:[_categorys objectAtIndex:indexPath.row] forState:0];
    return cell;
}

- (void)selecte:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    if (_lastIndexPath == nil) {
        _lastIndexPath = indexPath;
    }else{
        CategoryCell *cell = (CategoryCell *)[self.table cellForRowAtIndexPath:_lastIndexPath];
        [cell.categoryBtn setSelected:NO];
        _lastIndexPath = nil;
        _lastIndexPath = indexPath;
    }
    [sender setSelected:YES];
    _tableViewController.dataArr = [_categoryArr objectAtIndex:indexPath.row];
    [_tableViewController.table reloadData];
}

#pragma mark - tableViewController delegate -
- (void)seletedCell:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath
{
    //NSArray *contents = [[NSArray alloc]initWithObjects:@"其他",@"通用",@"男士",@"女士",@"儿童", nil];
//    TableCell *cell = (TableCell *)[_tableViewController.table cellForRowAtIndexPath:indexPath];
//    NSString *title = [cell.btn.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableArray *contents = [[NSMutableArray alloc]init];
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    NSDictionary *baseData = [ob valueForKey:@"baseData"];
    if ([[_tableViewController.dataArr objectAtIndex:indexPath.row] isEqualToString:@"选择适用人群"]) {
        NSArray *arr =[baseData valueForKey:@"xbs"];
        for (int i = 0; i < arr.count; i++) {
            NSString *str = [[arr objectAtIndex:i] valueForKey:@"name"];
            [contents addObject:str];
        }
    }else if ([[_tableViewController.dataArr objectAtIndex:indexPath.row] isEqualToString:@"选择售后服务"]){
        NSArray *arr =[baseData valueForKey:@"ss"];
        for (int i = 0; i < arr.count; i++) {
            NSString *str = [[arr objectAtIndex:i] valueForKey:@"name"];
            [contents addObject:str];
        }
    }
    ApplicablePeopleViewController *applicablePeopleViewController = [[ApplicablePeopleViewController alloc]initWithNibName:@"ApplicablePeopleViewController" bundle:nil data:contents indexPath:indexPath];
    [applicablePeopleViewController setHidesBottomBarWhenPushed:YES];
    applicablePeopleViewController.delegate = self;
    [self.navigationController pushViewController:applicablePeopleViewController animated:YES];
    applicablePeopleViewController = nil;
}

- (void)queryGoods:(id)sender
{
    //
}

- (void)queryMyGoods:(id)sender
{
    //
}

- (void)removeSelectedAttributes:(id)sender
{
    //
}

#pragma mark - ApplicablePeopleCellDelegate -
- (void)changeTitle:(NSString *)aStr indexPath:(NSIndexPath *)indexPath
{
    TableCell *cell = (TableCell *)[_tableViewController.table cellForRowAtIndexPath:indexPath];
    [cell.btn setTitle:aStr forState:0];
}

#pragma mark - textField -
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

- (NSString *)tabImageName
{
	return @"茶叶超市-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}



@end
