//
//  ArticlesRepository.h
//  GoT
//
//  Created by Paciej on 25/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

@interface ArticlesRepository : NSObject

- (nonnull instancetype)initWithDefaults:(nonnull NSUserDefaults *)defaults;
- (nonnull NSArray *)savedFavouritesArticles;
- (void)saveFavouriteArticle:(nonnull Article *)article;
- (void)removeFavouriteArticle:(nonnull Article *)article;
- (BOOL)isFavouriteArticle:(nonnull Article *)article;
- (void)storeArticlesTemporarily:(nonnull NSArray *)articles;
- (nonnull NSArray *)temporarilyStoredArticles;

@end
