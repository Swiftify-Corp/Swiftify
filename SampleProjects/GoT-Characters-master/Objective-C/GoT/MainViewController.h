//
//  MainViewController.h
//  GoT
//
//  Created by Paciej on 21/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loader.h"
#import "DataSource.h"
#import "ArticlesRepository.h"

@interface MainViewController : UIViewController

- (nonnull instancetype)
initWithLoader:(nonnull Loader *)loader
asyncLoadConfiguration:(nonnull AsyncLoadConfiguration *)configuration
dataSource:(nonnull DataSource *)dataSource
articlesRepository:(nonnull ArticlesRepository *)articlesRepository;

@end
