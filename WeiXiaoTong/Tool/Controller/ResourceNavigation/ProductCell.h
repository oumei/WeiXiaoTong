//
//  ProductCell.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-27.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductCellDelegate <NSObject>

- (void)checkDetail:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath;
- (void)collection:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath;
- (void)dangkou:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath;
@end

@interface ProductCell : UITableViewCell
@property (copy, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<ProductCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *name;
@property (weak, nonatomic) IBOutlet UIWebView *nameWeb;
@property (weak, nonatomic) IBOutlet UIWebView *serviceWeb;
@property (weak, nonatomic) IBOutlet UILabel *describe;
@property (weak, nonatomic) IBOutlet UILabel *serialNum;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *collection;
@property (weak, nonatomic) IBOutlet UIButton *detail;

@end
