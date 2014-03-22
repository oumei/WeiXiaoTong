//
//  MerchantsCell.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-4.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  MerchantsCellDelegate <NSObject>

- (void)deleted:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath;
- (void)note:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath;
- (void)selected:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath;

@end
@interface MerchantsCell : UITableViewCell
@property (copy, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<MerchantsCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *signature;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *noteBtn;


@end
