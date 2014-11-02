//
//  ViddlerManager.h
//  NiVo
//
//  Created by Milan Miletic on 7/23/14.
//  Copyright (c) 2014 NiVo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViddlerManager : NSObject

- (void)login;
- (void)postVideo:(NSURL*)url withSuccess:(void(^)(NSString*))successBlock;

+ (ViddlerManager*)instance;

@end
