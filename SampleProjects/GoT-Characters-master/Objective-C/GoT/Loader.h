//
//  Loader.h
//  GoT
//
//  Created by Paciej on 21/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncLoadConfiguration.h"

@interface Loader : NSObject

- (nonnull instancetype)
initWithWebserviceURLString:(nonnull NSString *)urlString
session:(nonnull NSURLSession *)session;

- (void)loadAsynchronously:(nonnull AsyncLoadConfiguration *)configuration
                  callback:(nullable void (^)(id _Nullable result))callback;

@end
