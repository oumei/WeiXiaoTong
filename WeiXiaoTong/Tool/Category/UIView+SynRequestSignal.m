//
//  UIView+SynRequestSignal.m
//  DuanQoo
//
//  Created by 5000 on 13-9-6.
//  Copyright (c) 2013年 5000. All rights reserved.
//

#import "UIView+SynRequestSignal.h"


#define TIP_WIDTH 200
#define TIP_HEIGHT 35
#define SPINNER_INDEX 0
#define TITLE_INDEX 1
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@implementation UIView (SynRequestSignal)

static UIView *tip = nil;

- (void)showWithType:(requestSignalType)aType Title:(NSString *)aTitle
{
    if (!tip) {
        
        tip = [[UIView alloc] init];
        tip.backgroundColor = [UIColor blackColor];
        tip.tag = 2000;
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        spinner.frame = CGRectMake(0, 0, 35, 35);
        [tip addSubview:spinner];
        spinner = nil;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 150, 35)];
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor whiteColor];
        title.adjustsFontSizeToFitWidth = YES;
        [tip addSubview:title];
        title = nil;
    }
    CGFloat tipY;
    switch (aType) {
        case 0:
            tipY = (SCREEN_HEIGHT - 44 - 216 - TIP_HEIGHT)/2;
            break;
        case 1:
            tipY = (SCREEN_HEIGHT - 44 - 20 - TIP_HEIGHT)/2;
            break;
        default:
            break;
    }
    tip.frame = CGRectMake((SCREEN_WIDTH - TIP_WIDTH)/2, tipY, TIP_WIDTH, TIP_HEIGHT);
    [(UILabel *)[[tip subviews] objectAtIndex:TITLE_INDEX] setText:aTitle];
    [(UIActivityIndicatorView *)[[tip subviews] objectAtIndex:SPINNER_INDEX] startAnimating];
    [self addSubview:tip];
}

- (void)endSynRequestSignal
{
    [(UIActivityIndicatorView *)[[tip subviews] objectAtIndex:SPINNER_INDEX] stopAnimating];
    
    [tip removeFromSuperview];
}

@end
