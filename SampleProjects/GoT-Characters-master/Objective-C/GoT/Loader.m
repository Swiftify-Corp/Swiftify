//
//  Loader.m
//  GoT
//
//  Created by Paciej on 21/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import "Loader.h"
#import "NSData+JSON.h"

@interface Loader ()

@property(nonatomic, strong, nonnull) NSString *webserviceURLString;
@property(nonatomic, strong, nonnull) NSURLSession *session;

@end

@implementation Loader

- (nonnull instancetype)
initWithWebserviceURLString:(nonnull NSString *)urlString
session:(nonnull NSURLSession *)session {
    self = [super init];
    if (self) {
        self.webserviceURLString = urlString;
        self.session = session;
    }
    return self;
}

- (void)loadAsynchronously:(nonnull AsyncLoadConfiguration *)configuration
                  callback:(nullable void (^)(id _Nullable result))callback {
    NSString *urlString =
    [NSString stringWithFormat:@"%@%@%@", self.webserviceURLString,
     configuration.webserviceEndpoint,
     configuration.webserviceQuery]; //TODO: use NSURLQueryItem  https://littlebitesofcocoa.com/128-nsurlqueryitem-nsurlcomponents
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:urlString];
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:components.URL
                completionHandler:^(NSData *_Nullable data,
                                    NSURLResponse *_Nullable response,
                                    NSError *_Nullable error) {
                    if (error) {
                        NSLog(@"loadAsynchronously error: %@",
                              error.debugDescription);
                        callback(nil);
                        return;
                    }
                    id parsedObject = configuration.responseParsingBlock(data);
                    callback(parsedObject);
                }];
    [task resume];
}

@end
