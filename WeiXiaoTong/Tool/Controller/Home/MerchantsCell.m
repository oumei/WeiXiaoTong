//
//  MerchantsCell.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-4.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "MerchantsCell.h"

@implementation MerchantsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)deletedAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleted:IndexPath:)]) {
        [self.delegate performSelector:@selector(deleted:IndexPath:) withObject:sender withObject:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
