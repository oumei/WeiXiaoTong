//
//  TableCell.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-7.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  TableCellDelegate <NSObject>

- (void)seletedAction:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath;

@end

@interface TableCell : UITableViewCell
@property (copy, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<TableCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
