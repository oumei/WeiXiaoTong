//
//  NSString+RegularExpressionTest.h
//  DuanQoo
//
//  Created by 5000 on 13-9-9.
//  Copyright (c) 2013年 5000. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegularExpressionTest)

+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidateMobile:(NSString *)mobile;
@end
