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
@interface GoodSearchViewController ()

@end

@implementation GoodSearchViewController

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
    
    [sender setSelected:YES];
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
