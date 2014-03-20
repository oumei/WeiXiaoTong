//
//  ProductTwoCell.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-10.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ProductTwoCellDelegate <NSObject>

- (void)checkDetails:(UIButton *)sender IndexPath:(NSIndexPath *)indexPath;

@end


@interface ProductTwoCell : UITableViewCell
@property (copy, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<ProductTwoCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *applicablePeople;
@property (weak, nonatomic) IBOutlet UILabel *service;
@property (weak, nonatomic) IBOutlet UILabel *describe;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *serialNum;
@property (weak, nonatomic) IBOutlet UIButton *detail;
@property (weak, nonatomic) IBOutlet UILabel *type2;

@end
