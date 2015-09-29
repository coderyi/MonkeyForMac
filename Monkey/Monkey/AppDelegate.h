//
//  AppDelegate.h
//  Monkey
//
//  Created by coderyi on 15/8/12.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YiNetworkEngine.h"
@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (nonatomic,strong) YiNetworkEngine *apiEngine;

@end

