//
//  DetailsViewController.m
//  GoT
//
//  Created by Paciej on 21/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIView+Additions.h"
#import <Masonry/Masonry.h>

/*Detail view is meant to display all above information about the selected Wiki
 * and enable the user to go to that wiki article in Safari using a button. User
 * should also see if a wiki is added to his favorite list or not.
 title
 thumbnail
 abstract - shortened to max 2 lines of description
 */
@interface DetailsViewController ()

@property(nonatomic, strong, nonnull) Article *article;
@property(nonatomic, strong, nonnull) UIImageView *imageView;
@property(nonatomic, strong, nonnull) UITextView *abstractTextView;
@property(nonatomic, strong, nonnull) UIButton *openButton;
@property(nonatomic, strong, nonnull) UILabel *favouriteInfoLabel;

@end

@implementation DetailsViewController

- (nonnull instancetype)initWithArticle:(nonnull Article *)article
                              favourite:(BOOL)favourite {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.article = article;
        self.title = article.title;
        self.view.backgroundColor = [UIColor whiteColor];
        self.imageView = [UIImageView autolayoutView];
        self.imageView.image = [article imageFromThumbnailData];
        self.abstractTextView = [UITextView autolayoutView];
        self.abstractTextView.editable = NO;
        self.abstractTextView.text = article.abstract;
        self.abstractTextView.font =
        [UIFont systemFontOfSize:[UIFont systemFontSize]];
        self.favouriteInfoLabel = [UILabel autolayoutView];
        self.favouriteInfoLabel.text = favourite
        ? @"This is your favourite article"
        : @"This is not your favourite article";
        self.favouriteInfoLabel.textAlignment = NSTextAlignmentCenter;
        self.favouriteInfoLabel.font =
        [UIFont systemFontOfSize:[UIFont systemFontSize]];
        self.openButton = [UIButton autolayoutView];
        [self.openButton setTitle:@"Open in Safari" forState:UIControlStateNormal];
        [self.openButton addTarget:self
                            action:@selector(openButtonTapped:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.openButton setTitleColor:[UIColor grayColor]
                              forState:UIControlStateNormal];
        [self.openButton setTitleColor:[UIColor lightGrayColor]
                              forState:UIControlStateHighlighted];
        [self.view addSubview:self.imageView];
        [self.view addSubview:self.abstractTextView];
        [self.view addSubview:self.openButton];
        [self.view addSubview:self.favouriteInfoLabel];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imageView.superview);
            make.top.equalTo(self.imageView.superview).offset(10);
            make.width.height.equalTo(@100);
        }];
        
        [self.abstractTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(10);
            make.left.equalTo(self.abstractTextView.superview).offset(10);
            make.right.equalTo(self.abstractTextView.superview).offset(-10);
            make.bottom.equalTo(self.favouriteInfoLabel.mas_top).offset(-10);
        }];
        
        [self.favouriteInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
            make.bottom.equalTo(self.openButton.mas_top).offset(10);
            make.left.right.equalTo(self.abstractTextView);
        }];
        
        [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
            make.left.right.equalTo(self.abstractTextView);
            make.bottom.equalTo(self.openButton.superview).offset(-10);
        }];
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)openButtonTapped:(UIButton *)sender {
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:self.article.urlString]];
}

@end
