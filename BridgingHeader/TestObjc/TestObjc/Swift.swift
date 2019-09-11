//
//  File.swift
//  TestObjc
//
//  Created by Ivan Kh on 11/09/2019.
//  Copyright © 2019 Swiftify. All rights reserved.
//

@objc class SwiftTest : NSObject {
    override init() {
        NSLog("Swift test")
        _ = ObjcInSwiftTest()
    }
}
