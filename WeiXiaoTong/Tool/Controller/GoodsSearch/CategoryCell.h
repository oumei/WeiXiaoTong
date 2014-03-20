//
//  CategoryCell.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-3.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  CategoryCellDelegate <NSObject>

- (void)selecte:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath;

@end

@interface CategoryCell : UITableViewCell
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<CategoryCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;

@end
