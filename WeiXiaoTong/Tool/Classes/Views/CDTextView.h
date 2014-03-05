//
//  CDTextView.h
//  ChineseDictionary
//
//  Created by 3014 on 13-10-9.
//  Copyright (c) 2013年 3014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDTextView : UITextView
{
    NSString *_placeholder;
    UITextAutocorrectionType _originalCorrection;
    UIColor *_placeholderColor;
    UIColor *_originalTextColor;
    NSString *_lastText;
    BOOL _usingPlaceholder;
    BOOL _settingPlaceholder;
}

@property(nonatomic,retain)NSString *placeholder;
@property(nonatomic,assign)UITextAutocorrectionType originalCorrection;
@property(nonatomic,retain)UIColor *placeholderColor;
@property(nonatomic,retain)UIColor *originalTextColor;
@property(nonatomic,retain)NSString *lastText;
@property(nonatomic,getter = isUsingPlaceholder)BOOL usingPlaceholder;
@property(nonatomic,getter = isSettingPlaceholder)BOOL settingPlaceholder;
- (void)_init;

@end
