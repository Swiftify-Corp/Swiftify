//
//  DetailsViewController.h
//  GoT
//
//  Created by Paciej on 21/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface DetailsViewController : UIViewController

- (nonnull instancetype)initWithArticle:(nonnull Article *)article
                              favourite:(BOOL)favourite;

@end
