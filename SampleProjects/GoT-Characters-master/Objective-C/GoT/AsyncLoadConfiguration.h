//
//  AsyncLoadConfiguration.h
//  GoT
//
//  Created by Paciej on 24/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncLoadConfiguration : NSObject

@property(nonatomic, readonly, nonnull) id _Nullable (^responseParsingBlock)
(NSData *_Nonnull result);
@property(nonatomic, readonly, nonnull) NSString *webserviceEndpoint;
@property(nonatomic, readonly, nullable) NSString *webserviceQuery;

- (nonnull instancetype)
initWithResponseParsingBlock:
(nonnull id _Nullable (^)(NSData *_Nonnull result))block
webserviceEndpoint:(nonnull NSString *)endpoint
webserviceQuery:(nullable NSString *)query;

@end

#import "Article.h"

@interface AsyncLoadConfiguration (Article)
+ (nonnull instancetype)asyncLoadConfigurationFromArticle:
(nonnull Article *)article;
@end