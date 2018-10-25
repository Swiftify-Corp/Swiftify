//
//  DataSource.m
//  GoT
//
//  Created by piotrom1 on 26/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import "DataSource.h"

@interface DataSource ()
@property(nonatomic, copy, nonnull) NSString *reuseIdentifier;
@property(nonatomic, strong, nonnull) NSMutableArray *mutableItems;
@end

@implementation DataSource

- (nonnull instancetype)
initWithCellConfigureBlock:(nullable CellConfigureBlock)configureBlock
cellReuseIdentifier:(nonnull NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        self.cellConfigureBlock = configureBlock;
        self.reuseIdentifier = reuseIdentifier;
        self.mutableItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (nonnull NSString *)cellReuseIdentifier {
    return self.reuseIdentifier;
}

- (void)addItems:(nonnull NSArray *)items {
    [self.mutableItems addObjectsFromArray:items];
    [self.mutableItems sortUsingDescriptors:@[
                                              [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                            ascending:YES]
                                              ]]; // Hack for sorting Articles by their title. Crash if anything other than
    // Article stored as item. Solution: use objc generics and protocol -
    // func keyForSorting -> String
    if (self.tableView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)setItems:(nonnull NSArray *)items {
    [self.mutableItems removeAllObjects];
    [self addItems:items];
}

- (nullable id)itemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    id item;
    NSInteger index = indexPath.row;
    if (index < self.mutableItems.count) {
        item = self.mutableItems[index];
    }
    return item;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.mutableItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:self.cellReuseIdentifier
                                    forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    if (item) {
        self.cellConfigureBlock(cell, indexPath, item);
    }
    return cell;
}

@end
