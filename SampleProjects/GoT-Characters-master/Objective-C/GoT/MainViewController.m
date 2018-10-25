//
//  MainViewController.m
//  GoT
//
//  Created by Paciej on 21/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

#import "MainViewController.h"
#import "DetailsViewController.h"
#import "FavouriteTableViewCell.h"
#import "Article.h"
#import "Configurator.h"

#import <Masonry/Masonry.h>

static NSString *kFavourite = @"Favourite";
static NSString *kAll = @"All";

@interface MainViewController () <UITableViewDelegate>

@property(nonatomic, strong, nonnull) Loader *loader;
@property(nonatomic, strong, nonnull) AsyncLoadConfiguration *configuration;
@property(nonatomic, strong, nonnull) DataSource *dataSource;
@property(nonatomic, strong, nonnull) ArticlesRepository *articlesRepository;
@property(nonatomic, strong, nonnull) UITableView *tableView;
@property(nonatomic, strong, nonnull) NSArray *tableViewDataSource;
@property(nonatomic) BOOL filterEnabled;
@end

@implementation MainViewController

- (nonnull instancetype)
initWithLoader:(nonnull Loader *)loader
asyncLoadConfiguration:(nonnull AsyncLoadConfiguration *)configuration
dataSource:(nonnull DataSource *)dataSource
articlesRepository:(nonnull ArticlesRepository *)articlesRepository {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.loader = loader;
        self.configuration = configuration;
        self.dataSource = dataSource;
        self.articlesRepository = articlesRepository;
        self.title = @"Characters";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithTitle:kFavourite
                                                  style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(rightBarButtonItemTapped:)];
        self.filterEnabled = false;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTableView];
    [self loadArticlesFromWebservice];
}

- (void)loadTableView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                      style:UITableViewStylePlain];
        self.tableView.dataSource = self.dataSource;
        self.tableView.delegate = self;
        [self.tableView registerClass:[FavouriteTableViewCell class]
               forCellReuseIdentifier:self.dataSource.cellReuseIdentifier];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.tableView.superview);
        }];
        self.dataSource.tableView = self.tableView;
        __weak __typeof__(self) __weakSelf = self;
        self.dataSource.cellConfigureBlock = ^(UITableViewCell *_Nonnull cell,
                                               NSIndexPath *_Nonnull indexPath,
                                               id _Nonnull item) {
            FavouriteTableViewCell *favCell = (FavouriteTableViewCell *)cell;
            if ([item isKindOfClass:[Article class]]) {
                Article *article = (Article *)item;
                favCell.titleLabel.text = article.title;
                favCell.abstractLabel.text = article.abstract;
                favCell.tag = indexPath.row;
                favCell.favouriteButton.tag = indexPath.row;
                if (article.thumbnailData) {
                    favCell.imageView.image = [article imageFromThumbnailData];
                }
                __strong __typeof__(__weakSelf) strongSelf = __weakSelf;
                if (strongSelf) {
                    [favCell.favouriteButton addTarget:strongSelf
                                                action:@selector(favouriteButtonTapped:)
                                      forControlEvents:UIControlEventTouchUpInside];
                    favCell.favouriteButton.selected =
                    [strongSelf.articlesRepository isFavouriteArticle:article];
                    ;
                }
            }
        };
    });
}

- (void)loadArticlesFromWebservice {
    [self.loader
     loadAsynchronously:self.configuration
     callback:^(id _Nullable result) {
         if ([result isKindOfClass:[NSArray class]]) {
             [self.articlesRepository storeArticlesTemporarily:result];
             [self.dataSource
              addItems:result]; // reloads table view on main queue
         }
     }];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    __block Article *article = [self.dataSource itemAtIndexPath:indexPath];
    
    if (!article.thumbnailData) {
        __block FavouriteTableViewCell *favouriteCell;
        __block NSInteger tag = indexPath.row;
        if ([cell isKindOfClass:[FavouriteTableViewCell class]]) {
            favouriteCell = (FavouriteTableViewCell *)cell;
        }
        AsyncLoadConfiguration *configuration =
        [AsyncLoadConfiguration asyncLoadConfigurationFromArticle:article];
        [self.loader loadAsynchronously:configuration
                               callback:^(id _Nullable result) {
                                   if ([result isKindOfClass:[NSData class]]) {
                                       article.thumbnailData = result;
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                            if (favouriteCell.tag == tag) {
                                                favouriteCell.imageView.image =
                                                [article imageFromThumbnailData];
                                                [favouriteCell setNeedsDisplay];
                                            }
                                       });
                                   }
                               }];
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Article *article = [self.dataSource itemAtIndexPath:indexPath];
    BOOL favourite = [self.articlesRepository isFavouriteArticle:article];
    DetailsViewController *viewController =
    [Configurator configuredDetailsViewControllerWithArticle:article
                                                   favourite:favourite];
    [self showViewController:viewController sender:self];
}

- (void)favouriteButtonTapped:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    Article *article = [self.dataSource itemAtIndexPath:indexPath];
    if ([self.articlesRepository isFavouriteArticle:article]) {
        [self.articlesRepository removeFavouriteArticle:article];
    } else {
        [self.articlesRepository saveFavouriteArticle:article];
    }
    sender.selected = !sender.selected;
    [sender setNeedsDisplay];
}

- (void)rightBarButtonItemTapped:(UIBarButtonItem *)sender {
    self.filterEnabled = !self.filterEnabled;
    sender.title = (self.filterEnabled) ? kAll : kFavourite;
    if (self.filterEnabled) {
        [self.dataSource
         setItems:[self.articlesRepository savedFavouritesArticles]];
    } else {
        [self.dataSource
         setItems:[self.articlesRepository temporarilyStoredArticles]];
    }
}

@end
