//
//  FavouriteTableViewCell.m
//  GoT
//
//  Created by piotrom1 on 26/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import "FavouriteTableViewCell.h"
#import "UIView+Additions.h"
#import <Masonry/Masonry.h>

@interface FavouriteTableViewCell ()

@property(nonatomic, strong, nonnull) UILabel *privateTitleLabel;
@property(nonatomic, strong, nonnull) UILabel *privateAbstractLabel;
@property(nonatomic, strong, nonnull) UIButton *privateFavouriteButton;

@end

@implementation FavouriteTableViewCell

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style
                      reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.image = [FavouriteTableViewCell avatarImage];
        self.privateTitleLabel = [UILabel autolayoutView];
        self.privateAbstractLabel = [UILabel autolayoutView];
        self.privateAbstractLabel.numberOfLines = 2;
        self.privateFavouriteButton = [UIButton autolayoutView];
        [self.privateFavouriteButton
         setImage:[FavouriteTableViewCell favouriteOffImage]
         forState:UIControlStateNormal];
        [self.privateFavouriteButton
         setImage:[FavouriteTableViewCell favouriteOnImage]
         forState:UIControlStateSelected];
        [self.contentView addSubview:self.privateTitleLabel];
        [self.contentView addSubview:self.privateAbstractLabel];
        [self.contentView addSubview:self.privateFavouriteButton];
        [self.privateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(10);
            make.right.equalTo(self.privateFavouriteButton.mas_left).offset(-10);
            make.top.equalTo(self.privateTitleLabel.superview).offset(10);
        }];
        [self.privateAbstractLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.privateTitleLabel.mas_bottom).offset(10);
            make.left.right.equalTo(self.privateTitleLabel);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        [self.privateFavouriteButton
         mas_makeConstraints:^(MASConstraintMaker *make) {
             make.width.and.height.equalTo(@40);
             make.right.equalTo(self.privateFavouriteButton.superview).offset(-10);
             make.centerY.equalTo(self.privateFavouriteButton.superview);
         }];
    }
    return self;
}

+ (UIImage *)avatarImage {
    static UIImage *avatarImage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        avatarImage = [UIImage imageNamed:@"avatar"];
    });
    return avatarImage;
}

+ (UIImage *)favouriteOnImage {
    static UIImage *image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        image = [UIImage imageNamed:@"fav_on"];
    });
    return image;
}

+ (UIImage *)favouriteOffImage {
    static UIImage *image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        image = [UIImage imageNamed:@"fav_off"];
    });
    return image;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = [FavouriteTableViewCell avatarImage];
    self.textLabel.text = @"";
    self.detailTextLabel.text = @"";
    self.titleLabel.text = @"";
    self.abstractLabel.text = @"";
    self.privateFavouriteButton.selected = NO;
}

- (UILabel *)titleLabel {
    return self.privateTitleLabel;
}

- (UILabel *)abstractLabel {
    return self.privateAbstractLabel;
}

- (UIButton *)favouriteButton {
    return self.privateFavouriteButton;
}

@end
