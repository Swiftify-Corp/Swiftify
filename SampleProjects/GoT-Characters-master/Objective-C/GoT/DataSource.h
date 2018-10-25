//
//  DataSource.h
//  GoT
//
//  Created by piotrom1 on 26/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CellConfigureBlock)(UITableViewCell *_Nonnull cell,
                                   NSIndexPath *_Nonnull indexPath,
                                   id _Nonnull item);

@interface DataSource : NSObject <UITableViewDataSource>

@property(nonatomic, weak, nullable) UITableView *tableView;
@property(nonatomic, readonly, nonnull) NSString *cellReuseIdentifier;
@property(nonatomic, copy, nullable) CellConfigureBlock cellConfigureBlock;

- (nonnull instancetype)
initWithCellConfigureBlock:(nullable CellConfigureBlock)configureBlock
cellReuseIdentifier:(nonnull NSString *)reuseIdentifier;

- (void)addItems:(nonnull NSArray *)items; // reloads tableView on main queue
- (void)setItems:(nonnull NSArray *)items; // reloads tableView on main queue
- (nullable id)itemAtIndexPath:(nonnull NSIndexPath *)indexPath;

@end
