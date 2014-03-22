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
- (IBAction)noteAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(note:IndexPath:)]) {
        [self.delegate performSelector:@selector(note:IndexPath:) withObject:sender withObject:self.indexPath];
    }
}

- (IBAction)selected:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selected:IndexPath:)]) {
        [self.delegate performSelector:@selector(selected:IndexPath:) withObject:sender withObject:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
