//
//  AppDelegate.m
//  TestObjc
//
//  Created by Ivan Kh on 11/09/2019.
//  Copyright © 2019 Swiftify. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [ObjcTest new];
    [SwiftTest new];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
