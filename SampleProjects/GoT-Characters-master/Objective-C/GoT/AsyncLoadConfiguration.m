//
//  LoaderConfiguration.m
//  GoT
//
//  Created by Paciej on 24/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import "AsyncLoadConfiguration.h"

@interface AsyncLoadConfiguration ()

@property(nonatomic, copy, nonnull) id _Nullable (^parsingBlock)
(NSData *_Nonnull result);
@property(nonatomic, copy, nonnull) NSString *endpoint;
@property(nonatomic, copy, nullable) NSString *query;

@end

@implementation AsyncLoadConfiguration

- (nonnull instancetype)
initWithResponseParsingBlock:
(nonnull id _Nullable (^)(NSData *_Nonnull result))block
webserviceEndpoint:(nonnull NSString *)endpoint
webserviceQuery:(nullable NSString *)query {
    self = [super init];
    if (self) {
        self.parsingBlock = block;
        self.endpoint = endpoint;
        self.query = query;
    }
    return self;
}

- (nonnull id _Nullable (^)(NSData *_Nonnul))responseParsingBlock {
    return self.parsingBlock;
}

- (nonnull NSString *)webserviceEndpoint {
    return self.endpoint;
}

- (nullable NSString *)webserviceQuery {
    return self.query;
}

@end

@implementation AsyncLoadConfiguration (Article)
+ (nonnull instancetype)asyncLoadConfigurationFromArticle:
(nonnull Article *)article {
    return [[AsyncLoadConfiguration alloc]
            initWithResponseParsingBlock:^id _Nullable(NSData *_Nonnull result) {
                NSData *data;
                if ([result isKindOfClass:[NSData class]] &&
                    [UIImage imageWithData:result]) {
                    data = (NSData *)result;
                }
                return data;
            } webserviceEndpoint:article.thumbnailURLString
            webserviceQuery:nil];
}
@end