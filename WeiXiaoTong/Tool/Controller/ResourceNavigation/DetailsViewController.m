//
//  DetailsViewController.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-28.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

///**人群*/
//public final static int RenQun=100;
//
//public final static int PinPai=101;
//
///**包包品质*/
//public final static int BagQuality=1;
///**包包类型*/
//public final static int BagType=2;
///**手表机芯*/
//public final static int Chip=3;
///**服饰类型*/
//public final static int ClothingType=4;
///**皮质材料*/
//public final static int Material=5;
///**售后服务*/
//public final static int Service=6;
///**鞋跟高度*/
//public final static int ShoesHeelHeight=7;
///**鞋跟粗细*/
//public final static int ShoesHeelSize=8;
///**鞋子类型*/
//public final static int ShoesType=9;
///**手表表带*/
//public final static int Watchband=10;
///**鞋子闭合方式*/
//public final static int ShoesBiHe=11;
///**护肤彩妆类型*/
//public final static int MakeupType=12;


#import "DetailsViewController.h"
#import "DetailsCell.h"
#import "UIImageView+WebCache.h"
#import "ObjectVo.h"
#import "BaseData.h"


@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil chanPin:(NSDictionary *)chanPin
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.chanPin = chanPin;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _contents = [[NSMutableArray alloc]init];
    
    _chanpin = [[ChanPin alloc]init];
    for (NSString *key in [self.chanPin allKeys]) {
        if ([[self.chanPin valueForKey:key] isKindOfClass:[NSString class]]) {
            [_chanpin setValue:[self.chanPin valueForKey:key] forKey:key];
        }else{
            [_chanpin setValue:[NSString stringWithFormat:@"%d",[[self.chanPin valueForKey:key] intValue]] forKey:key];
        }
    }
    
    [self.sPageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.sPageControl setBackgroundColor:[UIColor clearColor]];
    [self.sPageControl setPageControlStyle:PageControlStyleThumb];
    [self.sPageControl setThumbImage:[UIImage imageNamed:@"feature_point.png"]];
    [self.sPageControl setSelectedThumbImage:[UIImage imageNamed:@"feature_point_cur.png"]];
    [self.sPageControl setNumberOfPages:_chanpin.pics];
    
    self.HeaderScrollView.contentSize = CGSizeMake(320 * (_chanpin.pics + 2), self.HeaderScrollView.frame.size.height);
    self.HeaderScrollView.delegate = self;
    self.HeaderScrollView.pagingEnabled = YES;
    self.HeaderScrollView.showsHorizontalScrollIndicator = NO;
    self.HeaderScrollView.showsVerticalScrollIndicator = NO;
    self.HeaderScrollView.contentOffset = CGPointMake(320, self.HeaderScrollView.frame.origin.y);
    CGFloat h = [UIScreen mainScreen].bounds.size.height/4 * 3;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    int tableName = [[[ob valueForKey:@"ue"] valueForKey:@"tableName"] intValue];
    ;
    
    for (int i = 0; i < (_chanpin.pics + 2); i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(1+(320*i), 0, 318, self.HeaderScrollView.frame.size.height)];
        imageView.image = [UIImage imageNamed:@"loading.png"];
        if (i == 0) {
            if (_chanpin.cpid != 0) {
                [imageView setImageWithURL:[NSURL URLWithString:IMAGE_URL_BY_CPID(_chanpin.cpid, w, h, _chanpin.pics - 1)]];
            }else if (tableName == 1){
                [imageView setImageWithURL:[NSURL URLWithString:IMAGE_URL_BY_TN(_chanpin.Id, w, h, _chanpin.pics - 1)]];
            }else{
                [imageView setImageWithURL:[NSURL URLWithString:IMAGE_URL_BY_TN_ID(tableName, _chanpin.Id, w, h, _chanpin.pics - 1)]];
            }
            
        }else if (i == _chanpin.pics + 1){
            if (_chanpin.cpid != 0) {
                [imageView setImageWithURL:[NSURL URLWithString:IMAGE_URL_BY_CPID(_chanpin.cpid, w, h, 0)]];
            }else if (tableName == 1){
                [imageView setImageWithURL:[NSURL URLWithString:IMAGE_URL_BY_TN(_chanpin.Id, w, h, 0)]];
            }else{
                [imageView setImageWithURL:[NSURL URLWithString:IMAGE_URL_BY_TN_ID(tableName, _chanpin.Id, w, h, 0)]];
            }
        }else{
            if (_chanpin.cpid != 0) {
                [imageView setImageWithURL:[NSURL URLWithString:IMAGE_URL_BY_CPID(_chanpin.cpid, w, h, i - 1)]];
            }else if (tableName == 1){
                [imageView setImageWithURL:[NSURL URLWithString:IMAGE_URL_BY_TN(_chanpin.Id, w, h, i - 1)]];
            }else{
                [imageView setImageWithURL:[NSURL URLWithString:IMAGE_URL_BY_TN_ID(tableName, _chanpin.Id, w, h, i)]];
            }
        }
        
        [self.HeaderScrollView addSubview:imageView];
        imageView = nil;
    }
    
    BaseData *baseData = [[BaseData alloc]init];
    for (NSString *key in [[ob valueForKey:@"baseData"] allKeys]) {
        [baseData setValue:[[ob valueForKey:@"baseData"] valueForKey:key] forKey:key];
        NSLog(@"bd = %@",[[ob valueForKey:@"baseData"] valueForKey:key]);
    }
    for (int i = 0; i < baseData.xbs.count; i++) {
        int _ID = [[[baseData.xbs objectAtIndex:i] valueForKey:@"id"] intValue];
        if (_ID == _chanpin.xingbie) {
            NSString *str = [NSString stringWithFormat:@"适应人群：%@",[[baseData.xbs objectAtIndex:i] valueForKey:@"name"]];
            [_contents addObject:str];
        }
    }
    for (int i = 0; i < baseData.pps.count; i++) {
        int _ID = [[[baseData.pps objectAtIndex:i] valueForKey:@"id"] intValue];
        if (_ID == _chanpin.pinpai) {
            NSString *str = [NSString stringWithFormat:@"产品品牌：%@",[[baseData.pps objectAtIndex:i] valueForKey:@"cname"]];
            [_contents addObject:str];
        }
    }

    NSArray *categorys = [_chanpin.categorys componentsSeparatedByString:@"|"];
//    NSLog(@"c:%@",_chanpin.categorys);
//    NSLog(@"ca = %@",categorys);
    for (int i = 0; i < categorys.count; i++) {
        NSArray *categoryArr = [[categorys objectAtIndex:i] componentsSeparatedByString:@"_"];
        if ([[categoryArr objectAtIndex:0] intValue] == 1) {
            for (int j = 0; j < baseData.bqs.count; j++) {
                int _ID = [[[baseData.bqs objectAtIndex:j] valueForKey:@"id"] intValue];
                if (_ID == [[categoryArr objectAtIndex:1] intValue]) {
                    NSString *str = [NSString stringWithFormat:@"包包品质：%@",[[baseData.bqs objectAtIndex:j] valueForKey:@"name"]];
                    [_contents addObject:str];
                }
            }
        }else if ([[categoryArr objectAtIndex:0] intValue] == 2){
            for (int j = 0; j < baseData.bts.count; j++) {
                int _ID = [[[baseData.bts objectAtIndex:j] valueForKey:@"id"] intValue];
                if (_ID == [[categoryArr objectAtIndex:1] intValue]) {
                    NSString *str = [NSString stringWithFormat:@"包包类型：%@",[[baseData.bts objectAtIndex:j] valueForKey:@"name"]];
                    [_contents addObject:str];
                }
            }
        }else if ([[categoryArr objectAtIndex:0] intValue] == 3){
            for (int j = 0; j < baseData.cs.count; j++) {
                int _ID = [[[baseData.cs objectAtIndex:j] valueForKey:@"id"] intValue];
                if (_ID == [[categoryArr objectAtIndex:1] intValue]) {
                    NSString *str = [NSString stringWithFormat:@"手表机芯：%@",[[baseData.cs objectAtIndex:j] valueForKey:@"name"]];
                    [_contents addObject:str];
                }
            }
        }else if ([[categoryArr objectAtIndex:0] intValue] == 4){
            for (int j = 0; j < baseData.cts.count; j++) {
                int _ID = [[[baseData.cts objectAtIndex:j] valueForKey:@"id"] intValue];
                if (_ID == [[categoryArr objectAtIndex:1] intValue]) {
                    NSString *str = [NSString stringWithFormat:@"服饰类型：%@",[[baseData.cts objectAtIndex:j] valueForKey:@"name"]];
                    [_contents addObject:str];
                }
            }
        }else if ([[categoryArr objectAtIndex:0] intValue] == 5){
            for (int j = 0; j < baseData.ms.count; j++) {
                int _ID = [[[baseData.ms objectAtIndex:j] valueForKey:@"id"] intValue];
                if (_ID == [[categoryArr objectAtIndex:1] intValue]) {
                    NSString *str = [NSString stringWithFormat:@"皮质材料：%@",[[baseData.ms objectAtIndex:j] valueForKey:@"name"]];
                    [_contents addObject:str];
                }
            }
        }else if ([[categoryArr objectAtIndex:0] intValue] == 6){
            for (int j = 0; j < baseData.ss.count; j++) {
                int _ID = [[[baseData.ss objectAtIndex:j] valueForKey:@"id"] intValue];
                if (_ID == [[categoryArr objectAtIndex:1] intValue]) {
                    NSString *str = [NSString stringWithFormat:@"售后服务：%@",[[baseData.ss objectAtIndex:j] valueForKey:@"name"]];
                    [_contents addObject:str];
                }
            }
        }else if ([[categoryArr objectAtIndex:0] intValue] == 7){
            for (int j = 0; j < baseData.shhs.count; j++) {
                int _ID = [[[baseData.shhs objectAtIndex:j] valueForKey:@"id"] intValue];
                if (_ID == [[categoryArr objectAtIndex:1] intValue]) {
                    NSString *str = [NSString stringWithFormat:@"鞋跟高度：%@",[[baseData.shhs objectAtIndex:j] valueForKey:@"name"]];
                    [_contents addObject:str];
                }
            }
        }else if ([[categoryArr objectAtIndex:0] intValue] == 8){
            for (int j = 0; j < baseData.shss.count; j++) {
                int _ID = [[[baseData.shss objectAtIndex:j] valueForKey:@"id"] intValue];
                if (_ID == [[categoryArr objectAtIndex:1] intValue]) {
                    NSString *str = [NSString stringWithFormat:@"鞋跟粗细：%@",[[baseData.shss objectAtIndex:j] valueForKey:@"name"]];
                    [_contents addObject:str];
                }
            }
        }else if ([[categoryArr objectAtIndex:0] intValue] == 9){
            for (int j = 0; j < baseData.sts.count; j++) {
                int _ID = [[[baseData.sts objectAtIndex:j] valueForKey:@"id"] intValue];
                if (_ID == [[categoryArr objectAtIndex:1] intValue]) {
                    NSString *str = [NSString stringWithFormat:@"鞋子类型：%@",[[baseData.sts objectAtIndex:j] valueForKey:@"name"]];
                    [_contents addObject:str];
                }
            }
        }else if ([[categoryArr objectAtIndex:0] intValue] == 10){
            for (int j = 0; j < baseData.ws.count; j++) {
                int _ID = [[[baseData.ws objectAtIndex:j] valueForKey:@"id"] intValue];
                if (_ID == [[categoryArr objectAtIndex:1] intValue]) {
                    NSString *str = [NSString stringWithFormat:@"手表表带：%@",[[baseData.ws objectAtIndex:j] valueForKey:@"name"]];
                    [_contents addObject:str];
                }
            }
        }else if ([[categoryArr objectAtIndex:0] intValue] == 11){
            for (int j = 0; j < baseData.bhs.count; j++) {
                int _ID = [[[baseData.bhs objectAtIndex:j] valueForKey:@"id"] intValue];
                if (_ID == [[categoryArr objectAtIndex:1] intValue]) {
                    NSString *str = [NSString stringWithFormat:@"闭合方式：%@",[[baseData.bhs objectAtIndex:j] valueForKey:@"name"]];
                    [_contents addObject:str];
                }
            }
        }else if ([[categoryArr objectAtIndex:0] intValue] == 12){
            for (int j = 0; j < baseData.mts.count; j++) {
                int _ID = [[[baseData.mts objectAtIndex:j] valueForKey:@"id"] intValue];
                if (_ID == [[categoryArr objectAtIndex:1] intValue]) {
                    NSString *str = [NSString stringWithFormat:@"彩妆类型：%@",[[baseData.mts objectAtIndex:j] valueForKey:@"name"]];
                    [_contents addObject:str];
                }
            }
        }
        
        //
    }
    NSLog(@"_con = %@",_contents);
    [self.table reloadData];
    
    UIView *headerView = [[UIView alloc]init];
    UILabel *describe = [[UILabel alloc]init];
    describe.backgroundColor = [UIColor clearColor];
    describe.font = [UIFont systemFontOfSize:11];
    describe.numberOfLines = 0;
    describe.lineBreakMode = UILineBreakModeCharacterWrap;
    describe.text = _chanpin.miaoshu;
    CGFloat hight = [self getHightFromText:describe.text];
    describe.frame = CGRectMake(5, 5, 310, hight);
    [headerView addSubview:describe];
    describe = nil;
    
    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(5, hight + 10, 310, 30)];
    price.backgroundColor = [UIColor clearColor];
    price.font = [UIFont boldSystemFontOfSize:18];
    price.text = [NSString stringWithFormat:@"代理价格：¥%d",_chanpin.price];
    price.textColor = [UIColor redColor];
    [headerView addSubview:price];
    price = nil;
    
    UIButton *copy = [UIButton buttonWithType:UIButtonTypeCustom];
    copy.frame = CGRectMake(0, hight + 40, 320, 40);
    [copy setTitle:[NSString stringWithFormat:@" 点击复制供货商微信%d",86452852] forState:0];
    [copy setTitleColor:[UIColor blueColor] forState:0];
    [copy setBackgroundImage:[UIImage imageNamed:@"button_noborder_on.png"] forState:0];
    [copy setBackgroundImage:[UIImage imageNamed:@"button_noborder_over.png"] forState:UIControlStateHighlighted];
    [copy setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];//设置button的title靠左
    [headerView addSubview:copy];
    copy = nil;
    
    headerView.frame = CGRectMake(0, 0, 320, hight + 40 + 40);
    self.table.tableHeaderView = headerView;
    headerView = nil;
    
}

- (CGFloat)getHightFromText:(NSString *)text
{
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(310, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
    //NSLog(@"%f%f",size.height,size.width);
    return size.height;
}

#pragma UIScrollView delegate
//只要scrollview是滑动的，都会执行这个方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 2000) {
        if (scrollView.contentOffset.x == scrollView.contentSize.width - 320) {
            [scrollView setContentOffset:CGPointMake(320, scrollView.frame.origin.y) animated:NO];
        }else if (scrollView.contentOffset.x == 0){
            [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width - 320 * 2, scrollView.frame.origin.y) animated:NO];
        }
         _sPageControl.currentPage=fabs(scrollView.contentOffset.x/scrollView.frame.size.width) - 1;
    }
}


#pragma mark - tableView -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"detailsCell";
    DetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DetailsCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.content.text = [_contents objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
