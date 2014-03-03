//
//  DetailsViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-28.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"
#import "ChanPin.h"
#import "StyledPageControl.h"

@interface DetailsViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    ChanPin *_chanpin;
    NSMutableArray *_contents;
}
@property (weak, nonatomic) IBOutlet UIScrollView *HeaderScrollView;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (copy, nonatomic) NSDictionary *chanPin;
@property (weak, nonatomic) IBOutlet StyledPageControl *sPageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil chanPin:(NSDictionary *)chanPin;


@end
