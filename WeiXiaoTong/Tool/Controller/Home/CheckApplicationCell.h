//
//  CheckApplicationCell.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-4.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  CheckApplicationCellDelegate <NSObject>

- (void)refuse:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath;
- (void)agree:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath;

@end

@interface CheckApplicationCell : UITableViewCell
@property (copy, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<CheckApplicationCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *uLabel;
@property (weak, nonatomic) IBOutlet UILabel *validationMsg;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *refuse;
@property (weak, nonatomic) IBOutlet UIButton *agree;

@end
