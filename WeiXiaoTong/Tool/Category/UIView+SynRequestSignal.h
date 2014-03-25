//
//  UIView+SynRequestSignal.h
//  DuanQoo
//
//  Created by 5000 on 13-9-6.
//  Copyright (c) 2013年 5000. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    includeKeyBoard = 0,
    noKeyBoard
} requestSignalType;

@interface UIView (SynRequestSignal)

- (void)showWithType:(requestSignalType)aType Title:(NSString *)aTitle;
- (void)endSynRequestSignal;
- (void)LabelTitle:(NSString *)aTitle;
- (UILabel *)showSpinner:(requestSignalType)aType Title:(NSString *)aTitle;

@end
