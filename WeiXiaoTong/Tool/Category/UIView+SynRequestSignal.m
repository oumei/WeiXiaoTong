//
//  UIView+SynRequestSignal.m
//  DuanQoo
//
//  Created by 5000 on 13-9-6.
//  Copyright (c) 2013年 5000. All rights reserved.
//

#import "UIView+SynRequestSignal.h"


#define TIP_WIDTH 200
#define TIP_HEIGHT 70
#define TITLE_INDEX 1
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@implementation UIView (SynRequestSignal)

static UIView *tip = nil;
static UILabel *label = nil;
static UIView *spinner = nil;

- (void)showWithType:(requestSignalType)aType Title:(NSString *)aTitle
{
    if (!tip) {
        
        tip = [[UIView alloc] init];
        tip.layer.cornerRadius = 6.0;
        tip.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tip.layer.borderWidth = 1.0;
        tip.backgroundColor = [UIColor whiteColor];
        tip.tag = 2000;
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 60, 60)];
        icon.image = [UIImage imageNamed:@"ic_launcher.png"];
        [tip addSubview:icon];
        icon = nil;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 130, 40)];
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:16];
        title.lineBreakMode = UILineBreakModeWordWrap;
        title.numberOfLines = 2;
        title.textColor = [UIColor blackColor];
        //title.adjustsFontSizeToFitWidth = YES;
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
    [self addSubview:tip];
}

- (void)endSynRequestSignal
{
    [tip removeFromSuperview];
    [spinner removeFromSuperview];
}

- (UILabel *)showSpinner:(requestSignalType)aType Title:(NSString *)aTitle
{
    if (!spinner) {
        
        spinner = [[UIView alloc] init];
        spinner.layer.cornerRadius = 6.0;
        spinner.layer.borderColor = [UIColor lightGrayColor].CGColor;
        spinner.layer.borderWidth = 1.0;
        spinner.backgroundColor = [UIColor whiteColor];
        spinner.tag = 2000;
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 60, 60)];
        icon.image = [UIImage imageNamed:@"ic_launcher.png"];
        [spinner addSubview:icon];
        icon = nil;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 130, 40)];
        title.backgroundColor = [UIColor clearColor];
        title.font = [UIFont systemFontOfSize:16];
        title.lineBreakMode = UILineBreakModeWordWrap;
        title.numberOfLines = 2;
        title.textColor = [UIColor blackColor];
        //title.adjustsFontSizeToFitWidth = YES;
        [spinner addSubview:title];
        title = nil;
    }
    CGFloat tipY;
    switch (aType) {
        case 0:
            tipY = (SCREEN_HEIGHT - 44 - 216 - TIP_HEIGHT + 100)/2;
            break;
        case 1:
            tipY = (SCREEN_HEIGHT - 44 - 20 - TIP_HEIGHT + 100)/2;
            break;
        default:
            break;
    }
    spinner.frame = CGRectMake((SCREEN_WIDTH - TIP_WIDTH)/2, tipY, TIP_WIDTH, TIP_HEIGHT);
    [(UILabel *)[[spinner subviews] objectAtIndex:TITLE_INDEX] setText:aTitle];
    [self addSubview:spinner];
    return (UILabel *)[[spinner subviews] objectAtIndex:TITLE_INDEX];
}

- (void)LabelTitle:(NSString *)aTitle
{
    if (!label) {
        
        label = [[UILabel alloc] init];
        label.layer.cornerRadius = 4.0;
        label.backgroundColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14];
        label.text = aTitle;
        CGSize size = [label.text sizeWithFont:label.font];
        if (size.width < 250) {
            label.frame = CGRectMake((320 - size.width)/2, 300, size.width, 30);
        }else{
            label.frame = CGRectMake(60, 300, 250, 30);
        }
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(hideCollectionLable:) userInfo:label repeats:NO];
        label = nil;
    }
}

- (void)hideCollectionLable:(NSTimer *)aTimer
{
    UILabel *la = [aTimer userInfo];
    [la removeFromSuperview];
}


@end
