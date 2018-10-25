//
//  FavouriteTableViewCell.h
//  GoT
//
//  Created by piotrom1 on 26/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouriteTableViewCell : UITableViewCell
@property(nonatomic, readonly, nonnull) UILabel *titleLabel;
@property(nonatomic, readonly, nonnull) UILabel *abstractLabel;
@property(nonatomic, readonly, nonnull) UIButton *favouriteButton;
@end
