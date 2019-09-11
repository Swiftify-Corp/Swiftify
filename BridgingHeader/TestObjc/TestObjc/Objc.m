//
//  Objc.m
//  TestObjc
//
//  Created by Ivan Kh on 11/09/2019.
//  Copyright © 2019 Swiftify. All rights reserved.
//

#import "Objc.h"

@implementation ObjcTest

- (instancetype)init {
    self = [super init];
    NSLog(@"Objc test");
    return self;
}

@end


@implementation ObjcInSwiftTest

- (instancetype)init {
    self = [super init];
    NSLog(@"Objc in swift test");
    return self;
}

@end

