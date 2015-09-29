//
//  main.m
//  Monkey
//
//  Created by coderyi on 15/8/12.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, const char * argv[]) {
    NSApplication *app = [NSApplication sharedApplication];
    id delegate = [[AppDelegate alloc] init];
    app.delegate = delegate;
    
    return NSApplicationMain(argc, argv);
}
