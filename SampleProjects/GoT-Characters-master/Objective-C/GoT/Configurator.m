//
//  Configurator.m
//  GoT
//
//  Created by Paciej on 25/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import "Configurator.h"
#import "AsyncLoadConfiguration.h"
#import "Loader.h"
#import "FavouriteTableViewCell.h"
#import "NSData+JSON.h"

static NSString *kItems = @"items";
static NSString *kId = @"id";
static NSString *kTitle = @"title";
static NSString *kAbstract = @"abstract";
static NSString *kThumbnailURL = @"thumbnail";
static NSString *kArticleBaseURL = @"basepath";
static NSString *kArticleURL = @"url";

static NSString *kCellReuseIdentifier = @"MainViewControllerCell";

@implementation Configurator

+ (nonnull MainViewController *)configuredMainViewController {
    AsyncLoadConfiguration *asyncLoadConfiguration =
    [Configurator configuredCharactersAsyncLoadConfiguration];
    Loader *loader = [Configurator configuredLoader];
    ArticlesRepository *repository = [Configurator configuredArticlesRepository];
    DataSource *dataSource = [Configurator configuredArticlesDataSource];
    
    return [[MainViewController alloc] initWithLoader:loader
                               asyncLoadConfiguration:asyncLoadConfiguration
                                           dataSource:dataSource
                                   articlesRepository:repository];
}

+ (nonnull DetailsViewController *)
configuredDetailsViewControllerWithArticle:(nonnull Article *)article
favourite:(BOOL)favourite {
    return [[DetailsViewController alloc] initWithArticle:article
                                                favourite:favourite];
}

+ (nonnull ArticlesRepository *)configuredArticlesRepository {
    return [[ArticlesRepository alloc]
            initWithDefaults:[NSUserDefaults standardUserDefaults]];
}

+ (nonnull DataSource *)configuredArticlesDataSource {
    return [[DataSource alloc] initWithCellConfigureBlock:nil
                                      cellReuseIdentifier:kCellReuseIdentifier];
}

+ (nonnull Loader *)configuredLoader {
    NSURLSession *session = [NSURLSession
                             sessionWithConfiguration:[NSURLSessionConfiguration
                                                       defaultSessionConfiguration]];
    return [[Loader alloc] initWithWebserviceURLString:@"" session:session];
}

+ (nonnull AsyncLoadConfiguration *)configuredCharactersAsyncLoadConfiguration {
    return [[AsyncLoadConfiguration alloc]
            initWithResponseParsingBlock:^id(NSData *result) {
                id JSON = result.JSONObject;
                if (!JSON) {
                    NSLog(@"loadAsynchronously error: cannot create JSON object from "
                          @"server response.");
                    return nil;
                }
                NSString *basePath = [JSON objectForKey:kArticleBaseURL];
                NSArray *items = [JSON objectForKey:kItems];
                NSMutableArray *articles =
                [[NSMutableArray alloc] initWithCapacity:items.count];
                for (NSDictionary *item in items) {
                    @autoreleasepool {
                        Article *article = [[Article alloc]
                                            initWithIdentifier:item[kId]
                                            title:item[kTitle]
                                            abstract:item[kAbstract]
                                            urlString:[NSString stringWithFormat:@"%@%@", basePath,
                                                       item[kArticleURL]]
                                            thumbnailURLString:item[kThumbnailURL]];
                        [articles addObject:article];
                    }
                }
                return articles;
            } webserviceEndpoint:@"http://gameofthrones.wikia.com/api/v1/Articles/Top"
            webserviceQuery:@"?expand=1&category=Characters&limit=75"];
}

@end
