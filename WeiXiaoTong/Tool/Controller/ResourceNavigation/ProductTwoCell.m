//
//  ProductTwoCell.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-10.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "ProductTwoCell.h"

@implementation ProductTwoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)details:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkDetails:IndexPath:)])
    {
        [self.delegate performSelector:@selector(checkDetails:IndexPath:) withObject:sender withObject:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end