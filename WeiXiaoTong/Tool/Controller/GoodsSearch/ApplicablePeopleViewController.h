//
//  ApplicablePeopleViewController.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-7.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CommonViewController.h"
#import "ApplicablePeopleCell.h"
@protocol ApplicablePeopleViewControllerDelegate <NSObject>

-(void)changeTitle:(NSString *)aStr indexPath:(NSIndexPath *)indexPath apIndexPath:(NSIndexPath *)apIndexPath;

@end

@interface ApplicablePeopleViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ApplicablePeopleCellDelegate>
{
    NSArray *_contents;
}
@property (assign, nonatomic)id<ApplicablePeopleViewControllerDelegate> delegate;
@property (copy, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *back;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSArray *)data indexPath:(NSIndexPath *)indexPath title:(NSString *)title;

@end