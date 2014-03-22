//
//  ResourceNavigationViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-24.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "ResourceNavigationViewController.h"
#import "UIViewController+AKTabBarController.h"
#import "NavigationViewController.h"
#import "ObjectVo.h"
#import "Link.h"
#import "AKTabBarController.h"

@interface ResourceNavigationViewController ()

@end

@implementation ResourceNavigationViewController
@synthesize bazaars = _bazaars;

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
    
    self.bazaars = [[[ObjectVo shareCurrentObjectVo] valueForKey:@"baseData"] valueForKey:@"bazaars"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (NSString *)tabImageName
{
	return @"市场行情-图标（黑）";
}

- (NSString *)tabTitle
{
	return nil;
}

#pragma mark - tableView delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bazaars.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"优质供货商";
        cell.detailTextLabel.text = @"此类供货商均为自行管理商品，一旦断货情况他们会及时更新产品状态。为广大用户提供更好的服务！";
        return cell;
    }
    cell.textLabel.text = [[self.bazaars objectAtIndex:indexPath.row - 1] valueForKey:@"name"];
    cell.detailTextLabel.text = [[self.bazaars objectAtIndex:indexPath.row - 1] valueForKey:@"address"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    if (indexPath.row == 0) {
        //
    }else{
        NSString *title = [[self.bazaars objectAtIndex:indexPath.row - 1] valueForKey:@"name"];
        NSArray *links = [[[ObjectVo shareCurrentObjectVo] valueForKey:@"baseData"] valueForKey:@"links"];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < links.count; i++) {
            if ([[[links objectAtIndex:i] valueForKey:@"name"] rangeOfString:title].location !=NSNotFound) {
                
                Link *link = [[Link alloc]init];
                link.Id = [[[links objectAtIndex:i] valueForKey:@"id"] intValue];
                link.link = [[links objectAtIndex:i] valueForKey:@"link"];
                link.name = [[links objectAtIndex:i] valueForKey:@"name"];
                [arr addObject:link];
                link = nil;
            }
        }
        if (arr.count == 0) {
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(110, 300, 100, 30)];
            lable.backgroundColor = [UIColor blackColor];
            lable.text = @"暂无数据！";
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [UIColor whiteColor];
            
            [self.view addSubview:lable];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideCollectionLable:) userInfo:lable repeats:NO];
            lable = nil;
            return;
        }
        NavigationViewController *navigationViewController = [[NavigationViewController alloc]initWithNibName:@"NavigationViewController" bundle:nil links:arr];
        [navigationViewController setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:navigationViewController animated:YES];
        navigationViewController = nil;
    }
}

- (void)hideCollectionLable:(NSTimer *)aTimer
{
    UILabel *lable = [aTimer userInfo];
    lable.hidden = YES;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//    [self.navigationController setHidesBottomBarWhenPushed:NO];
//}

- (void)dealloc
{
    self.table.delegate = nil;
    self.table.dataSource = nil;
    self.table = nil;
}

@end
