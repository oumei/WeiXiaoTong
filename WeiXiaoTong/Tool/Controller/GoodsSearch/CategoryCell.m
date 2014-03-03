//
//  CategoryCell.m
//  WeiXiaoTong
//
//  Created by 李世明 on 14-3-3.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)selecteCategory:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selecte:IndexPath:)]) {
        [self.delegate performSelector:@selector(selecte:IndexPath:) withObject:sender withObject:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
