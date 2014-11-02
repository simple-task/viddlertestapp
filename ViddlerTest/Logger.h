//
//  Logger.h
//  NiVo
//
//  Created by Milan Miletic on 10/23/14.
//  Copyright (c) 2014 NiVo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LogInfo(...) [Logger log:__PRETTY_FUNCTION__ line:__LINE__ string:__VA_ARGS__]

@interface Logger : NSObject

+ (void)startLogging;
+ (void)finishLogging;

+ (void)log:(const char *)function line:(int)line string:(NSString *)format, ...;


@end
