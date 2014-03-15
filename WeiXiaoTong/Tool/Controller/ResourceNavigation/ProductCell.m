//
//  ProductCell.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-27.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
    }
    return self;
}

- (IBAction)collection:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(collection:IndexPath:)])
    {
        [self.delegate performSelector:@selector(collection:IndexPath:) withObject:sender withObject:self.indexPath];
    }
}

- (IBAction)details:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkDetail:IndexPath:)])
    {
        [self.delegate performSelector:@selector(checkDetail:IndexPath:) withObject:sender withObject:self.indexPath];
    }
}
- (IBAction)dangkouPush:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dangkou:IndexPath:)])
    {
        [self.delegate performSelector:@selector(dangkou:IndexPath:) withObject:sender withObject:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
