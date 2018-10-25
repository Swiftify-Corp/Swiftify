//
//  MainViewController.swift
//  GoT
//
//  Created by Paciej on 21/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

import Masonry
import UIKit

private var kFavourite = "Favourite"
private var kAll = "All"

class MainViewController: UIViewController, UITableViewDelegate {
    private var loader: Loader!
    private var configuration: AsyncLoadConfiguration!
    private var dataSource: DataSource!
    private var articlesRepository: ArticlesRepository!
    private var tableView: UITableView!
    private var tableViewDataSource: [Any] = []
    private var filterEnabled = false

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(loader: Loader, asyncLoadConfiguration configuration: AsyncLoadConfiguration, dataSource: DataSource, articlesRepository: ArticlesRepository) {
        super.init(nibName: nil, bundle: nil)
        
        self.loader = loader
        self.configuration = configuration
        self.dataSource = dataSource
        self.articlesRepository = articlesRepository
        title = "Characters"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: kFavourite, style: .plain, target: self, action: #selector(MainViewController.rightBarButtonItemTapped(_:)))
        filterEnabled = false
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableView()
        loadArticlesFromWebservice()
    }

    func loadTableView() {
        var onceToken: Int = 0
        // TODO: use a static variable (`dispatch_once` is deprecated)
    if (onceToken == 0) {
            self.tableView = UITableView(frame: CGRect.zero, style: .plain)
            self.tableView.dataSource = self.dataSource
            self.tableView.delegate = self
            self.tableView.register(FavouriteTableViewCell.self, forCellReuseIdentifier: self.dataSource.cellReuseIdentifier)
            self.view.addSubview(self.tableView)
            self.tableView.mas_makeConstraints({ make in
                _ = make?.edges.equalTo()(self.tableView.superview)
            })
            self.dataSource.tableView = self.tableView
            weak var __weakSelf: MainViewController? = self
            self.dataSource.cellConfigureBlock = { cell, indexPath, item in
                let favCell = cell as? FavouriteTableViewCell
                if (item is Article) {
                    let article = item as? Article
                    favCell?.titleLabel.text = article?.title
                    favCell?.abstractLabel.text = article?.abstract
                    favCell?.tag = indexPath.row
                    favCell?.favouriteButton.tag = indexPath.row
                    if article?.thumbnailData != nil {
                        favCell?.imageView?.image = article?.imageFromThumbnailData()
                    }
                    let strongSelf: MainViewController? = __weakSelf
                    if strongSelf != nil {
                        favCell?.favouriteButton.addTarget(strongSelf, action: #selector(MainViewController.favouriteButtonTapped(_:)), for: .touchUpInside)
                        if let anArticle = article {
                            favCell?.favouriteButton.isSelected = strongSelf?.articlesRepository.isFavouriteArticle(anArticle) ?? false
                        }
                    }
                }
            }
        }
    onceToken = 1
    }

    func loadArticlesFromWebservice() {
        loader.loadAsynchronously(configuration, callback: { result in
            if (result is [Any]) {
                if let aResult = result as? [Any] {
                    self.articlesRepository.storeArticlesTemporarily(aResult)
                }
                if let aResult = result as? [Any] {
                    self.dataSource.addItems(aResult)
                } // reloads table view on main queue
            }
        })
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let article = dataSource.item(at: indexPath) as? Article

        if article?.thumbnailData == nil {
            var favouriteCell: FavouriteTableViewCell?
            let tag: Int = indexPath.row
            if (cell is FavouriteTableViewCell) {
                favouriteCell = cell as? FavouriteTableViewCell
            }
            var configuration: AsyncLoadConfiguration? = nil
            if let anArticle = article {
                configuration = AsyncLoadConfiguration(fromArticle: anArticle) as? AsyncLoadConfiguration
            }
            if let aConfiguration = configuration {
                loader.loadAsynchronously(aConfiguration, callback: { result in
                    if (result is Data) {
                        article?.thumbnailData = result as? Data
                        DispatchQueue.main.async(execute: {
                            if favouriteCell?.tag == tag {
                                favouriteCell?.imageView?.image = article?.imageFromThumbnailData()
                                favouriteCell?.setNeedsDisplay()
                            }
                        })
                    }
                })
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = dataSource.item(at: indexPath) as? Article
        var favourite: Bool? = nil
        if let anArticle = article {
            favourite = articlesRepository.isFavouriteArticle(anArticle)
        }
        var viewController: DetailsViewController? = nil
        if let anArticle = article {
            viewController = Configurator.configuredDetailsViewController(with: anArticle, favourite: favourite ?? false)
        }
        if let aController = viewController {
            show(aController, sender: self)
        }
    }

    @objc func favouriteButtonTapped(_ sender: UIButton?) {
        let indexPath = IndexPath(row: sender?.tag ?? 0, section: 0)
        let article = dataSource.item(at: indexPath) as? Article
        if let anArticle = article {
            if articlesRepository.isFavouriteArticle(anArticle) {
                articlesRepository.removeFavouriteArticle(anArticle)
            } else {
                articlesRepository.saveFavouriteArticle(anArticle)
            }
        }
        sender?.isSelected = !(sender?.isSelected ?? false)
        sender?.setNeedsDisplay()
    }

    @objc func rightBarButtonItemTapped(_ sender: UIBarButtonItem?) {
        filterEnabled = !filterEnabled
        sender?.title = (filterEnabled) ? kAll : kFavourite
        if filterEnabled {
            dataSource.setItems(articlesRepository.savedFavouritesArticles())
        } else {
            dataSource.setItems(articlesRepository.temporarilyStoredArticles())
        }
    }
}