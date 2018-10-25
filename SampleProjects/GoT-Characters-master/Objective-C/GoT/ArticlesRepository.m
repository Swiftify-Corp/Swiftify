//
//  ArticlesRepository.m
//  GoT
//
//  Created by Paciej on 25/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import "ArticlesRepository.h"

@interface ArticlesRepository ()
@property(nonatomic, strong, nonnull) NSUserDefaults *defaults;
@property(nonatomic, strong, nonnull) NSMutableSet *articles;
@property(nonatomic, strong, nonnull) NSMutableSet *temporaryArticles;
@end

static NSString *kSavedArticles = @"SavedArticles";

@implementation ArticlesRepository
- (nonnull instancetype)initWithDefaults:(nonnull NSUserDefaults *)defaults {
    self = [super init];
    if (self) {
        self.defaults = defaults;
        self.articles = [self getFavouriteArticlesFromDefaults];
        self.temporaryArticles = [[NSMutableSet alloc] init];
    }
    return self;
}

- (nonnull NSArray *)savedFavouritesArticles {
    return self.articles.allObjects;
}

- (void)saveFavouriteArticle:(nonnull Article *)article {
    [self.articles addObject:article];
    [self saveFavouriteArticlesToDefaults];
}

- (void)removeFavouriteArticle:(nonnull Article *)article {
    [self.articles removeObject:article];
    [self saveFavouriteArticlesToDefaults];
}

- (void)saveFavouriteArticlesToDefaults {
    NSData *archivedArticles =
    [NSKeyedArchiver archivedDataWithRootObject:self.articles];
    [self.defaults setObject:archivedArticles forKey:kSavedArticles];
    [self.defaults synchronize];
}

- (nonnull NSMutableSet *)getFavouriteArticlesFromDefaults {
    NSData *archivedArticles = [self.defaults objectForKey:kSavedArticles];
    NSMutableSet *set =
    [NSKeyedUnarchiver unarchiveObjectWithData:archivedArticles];
    if (!set) {
        set = [[NSMutableSet alloc] init];
    }
    return set;
}

- (BOOL)isFavouriteArticle:(nonnull Article *)article {
    return
    [self.articles
     filteredSetUsingPredicate:[NSPredicate
                                predicateWithFormat:@"identifier == %@",
                                article.identifier]]
    .count > 0; // This could cause a perfromance issue for large data
    // sets!? TODO: verify and find better solution
}

- (void)storeArticlesTemporarily:(nonnull NSArray *)articles {
    [self.temporaryArticles addObjectsFromArray:articles];
}

- (nonnull NSArray *)temporarilyStoredArticles {
    return self.temporaryArticles.allObjects;
}

@end
