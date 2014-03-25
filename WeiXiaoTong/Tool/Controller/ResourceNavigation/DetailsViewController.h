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

@protocol DetailsViewControllerDelegate <NSObject>

- (void)deleteChanpin:(ChanPin *)chanpin;

@end

@interface DetailsViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIAlertViewDelegate>
{
    ChanPin *_chanpin;
    NSMutableArray *_contents;
}
@property (weak, nonatomic) IBOutlet UIScrollView *HeaderScrollView;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) ChanPin *chanPin;
@property (weak, nonatomic) IBOutlet StyledPageControl *sPageControl;
@property (weak, nonatomic) id<DetailsViewControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil chanPin:(ChanPin *)chanPin;


@end
