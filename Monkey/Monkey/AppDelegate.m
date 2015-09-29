//
//  AppDelegate.m
//  Monkey
//
//  Created by coderyi on 15/8/12.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"
@interface AppDelegate (){
    MainWindowController *mainWindow;
    
}

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate
- (IBAction)openWindow:(id)sender {
    if (!mainWindow) {
        mainWindow=[[MainWindowController alloc] initWithWindowNibName:@"MainWindowController"];
    }
    [mainWindow showWindow:self];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    if (!mainWindow) {
        mainWindow=[[MainWindowController alloc] initWithWindowNibName:@"MainWindowController"];
    }
    [mainWindow showWindow:self];
    self.apiEngine=[[YiNetworkEngine alloc] initWithDefaultSet];

}
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    if (!mainWindow) {
        mainWindow=[[MainWindowController alloc] initWithWindowNibName:@"MainWindowController"];
    }
    [mainWindow showWindow:self];
    return YES;
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
