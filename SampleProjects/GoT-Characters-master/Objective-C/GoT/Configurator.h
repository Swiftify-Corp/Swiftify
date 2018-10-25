//
//  Configurator.h
//  GoT
//
//  Created by Paciej on 25/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"
#import "DetailsViewController.h"
#import "Article.h"
#import "ArticlesRepository.h"

@interface Configurator : NSObject

+ (nonnull MainViewController *)configuredMainViewController;
+ (nonnull DetailsViewController *)
configuredDetailsViewControllerWithArticle:(nonnull Article *)article
favourite:(BOOL)favourite;
+ (nonnull ArticlesRepository *)configuredArticlesRepository;

@end
