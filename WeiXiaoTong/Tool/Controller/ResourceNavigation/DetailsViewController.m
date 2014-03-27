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
#import "UserEntity.h"
#include<objc/runtime.h>
#import "HttpService.h"
#import "JSON.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController
@synthesize chanPin = _chanpin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil chanPin:(ChanPin *)chanPin
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
//    NSLog(@"%d,%@,%@",self.chanPin.pics,self.chanPin.address,self.chanPin.attrebute);
    _contents = [[NSMutableArray alloc]init];
    
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
    CGFloat h = 240*2;
    CGFloat w = [UIScreen mainScreen].bounds.size.width*2;
    
    
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    for (int i = 0; i < (_chanpin.pics + 2); i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(1+(320*i), 0, 318, self.HeaderScrollView.frame.size.height)];
        imageView.image = [UIImage imageNamed:@"loading.png"];
        if (i == 0) {
            if (_chanpin.address) {
                [imageView setImageWithURL:[NSURL URLWithString:IMAGE_URL_BY_CPID(_chanpin.address, w, h, _chanpin.pics - 1)]];
            }else{
                NSString *str = [NSString stringWithFormat:@"%d",_chanpin.Id];
                [imageView setImageWithURL:[NSURL URLWithString:IMAGE_URL_BY_CPID(str, w, h, _chanpin.pics - 1)]];
            }
            
        }else if (i == _chanpin.pics + 1){
            if (_chanpin.address) {
                [imageView setImageWithURL:[NSURL URLWithString:IMAGE_URL_BY_CPID(_chanpin.address, w, h, 0)]];
            }else{
                NSString *str = [NSString stringWithFormat:@"%d",_chanpin.Id];
                [imageView setImageWithURL:[NSURL URLWithString:IMAGE_URL_BY_CPID(str, w, h, 0)]];
            }
        }else{
            if (_chanpin.address) {
                [imageView setImageWithURL:[NSURL URLWithString:IMAGE_URL_BY_CPID(_chanpin.address, w, h, i - 1)]];
            }else{
                NSString *str = [NSString stringWithFormat:@"%d",_chanpin.Id];
                [imageView setImageWithURL:[NSURL URLWithString:IMAGE_URL_BY_CPID(str, w, h, i - 1)]];
            }
        }
        
        [self.HeaderScrollView addSubview:imageView];
        imageView = nil;
    }
    
    BaseData *baseData = [[BaseData alloc]init];
    for (NSString *key in [[ob valueForKey:@"baseData"] allKeys]) {
        [baseData setValue:[[ob valueForKey:@"baseData"] valueForKey:key] forKey:key];
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
    }
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
    
    NSString *weixin;
    for (int i = 0; i < baseData.links.count; i++) {
        NSDictionary *dic = [baseData.links objectAtIndex:i];
        if ([self.chanPin.dangkou isEqualToString:[dic valueForKey:@"name"]]) {
            weixin = [dic valueForKey:@"link"];
        }
    }
    
    UIButton *copy = [UIButton buttonWithType:UIButtonTypeCustom];
    copy.frame = CGRectMake(0, hight + 40, 320, 40);
    if (weixin) {
        [copy setTitle:[NSString stringWithFormat:@" 点击复制供货商%@",weixin] forState:0];
    }else{
        [copy setTitle:@" 供货商未知" forState:0];
    }
    [copy setTitleColor:[UIColor blueColor] forState:0];
    UserEntity *ue = [UserEntity shareCurrentUe];
    if (self.chanPin.upload == ue.Id) {
        [copy setTitle:@" 点击删除此款商产品" forState:0];
        [copy setTitleColor:[UIColor redColor] forState:0];
    }
    [copy setBackgroundImage:[UIImage imageNamed:@"button_noborder_on.png"] forState:0];
    [copy setBackgroundImage:[UIImage imageNamed:@"button_noborder_over.png"] forState:UIControlStateHighlighted];
    [copy setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];//设置button的title靠左
    [copy addTarget:self action:@selector(copyContact:) forControlEvents:UIControlEventTouchUpInside];
    
    if (ue.qx == 2 && self.chanPin.address == nil) {
        [headerView addSubview:copy];
        copy = nil;
        headerView.frame = CGRectMake(0, 0, 320, hight + 40 + 40);
        
    }else if([copy.titleLabel.text rangeOfString:@"点击删除此款商产品"].location != NSNotFound){
        [headerView addSubview:copy];
        copy = nil;
        headerView.frame = CGRectMake(0, 0, 320, hight + 40 + 40);
    }else{
        copy = nil;
        headerView.frame = CGRectMake(0, 0, 320, hight + 40);
    }
    self.table.tableHeaderView = headerView;
    headerView = nil;
    
}

- (CGFloat)getHightFromText:(NSString *)text
{
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(310, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
    //NSLog(@"%f%f",size.height,size.width);
    return size.height;
}

- (void)copyContact:(UIButton *)sender
{
    if ([sender.titleLabel.text rangeOfString:@"点击删除此款商产品"].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定要删除此款产品吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        alert = nil;
    }else{
        if (sender.titleLabel.text.length > 7) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [sender.titleLabel.text substringWithRange:NSMakeRange(8, sender.titleLabel.text.length - 8)];
            [self.view LabelTitle:@"已复制"];
        }else{
            [self.view LabelTitle:@"供货商未知"];
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UserEntity *ue = [UserEntity shareCurrentUe];
    ObjectVo *ob = [ObjectVo shareCurrentObjectVo];
    if (buttonIndex == 1) {
        [self.view showWithType:0 Title:@"正在删除..."];
        [[HttpService sharedInstance] postRequestWithUrl:DEFAULT_URL params:@{@"interface": DELETE_CHANPIN,@"cpid": [NSString stringWithFormat:@"%d",self.chanPin.Id],@"uuid": ue.uuid,@"uname": ue.userName,@"dataVersions":ob.dataVersions} completionBlock:^(id object) {
            NSString *ovo = [object valueForKey:@"ovo"];
            NSDictionary *objectVoDic = [ovo JSONValue];
            NSString *code = [objectVoDic valueForKey:@"code"];
            if ([code intValue] == 0){
                [self.view endSynRequestSignal];
                [self.view LabelTitle:@"删除成功"];
                if (self.delegate && [self.delegate respondsToSelector:@selector(deleteChanpin:)]) {
                    [self.delegate performSelector:@selector(deleteChanpin:) withObject:self.chanPin];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view endSynRequestSignal];
                [self.view LabelTitle:[objectVoDic valueForKey:@"msg"]];
            }
        } failureBlock:^(NSError *error, NSString *responseString) {
            [self.view endSynRequestSignal];
        }];
    }
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
