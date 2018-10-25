//
//  Configurator.swift
//  GoT
//
//  Created by Paciej on 25/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

import Foundation

private var kItems = "items"
private var kId = "id"
private var kTitle = "title"
private var kAbstract = "abstract"
private var kThumbnailURL = "thumbnail"
private var kArticleBaseURL = "basepath"
private var kArticleURL = "url"
private var kCellReuseIdentifier = "MainViewControllerCell"

class Configurator: NSObject {
    class func configuredMainViewController() -> MainViewController {
        let asyncLoadConfiguration = Configurator.configuredCharactersAsyncLoadConfiguration()
        let loader = Configurator.configuredLoader()
        let repository = Configurator.configuredArticlesRepository()
        let dataSource = Configurator.configuredArticlesDataSource()

        return MainViewController(loader: loader, asyncLoadConfiguration: asyncLoadConfiguration, dataSource: dataSource, articlesRepository: repository)
    }

    class func configuredDetailsViewController(with article: Article, favourite: Bool) -> DetailsViewController {
        return DetailsViewController(article: article, favourite: favourite)
    }

    class func configuredArticlesRepository() -> ArticlesRepository {
        return ArticlesRepository(defaults: UserDefaults.standard)
    }

    class func configuredArticlesDataSource() -> DataSource {
        return DataSource(cellConfigureBlock: nil, cellReuseIdentifier: kCellReuseIdentifier)
    }

    class func configuredLoader() -> Loader {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        return Loader(webserviceURLString: "", session: session)
    }

    class func configuredCharactersAsyncLoadConfiguration() -> AsyncLoadConfiguration {
        return AsyncLoadConfiguration(responseParsingBlock: { result in
            let JSON = result.jsonObject
            if JSON == nil {
                print("""
                loadAsynchronously error: cannot create JSON object from \
                server response.
                """)
                return nil
            }
            let basePath = (JSON as? [AnyHashable : Any])?[kArticleBaseURL] as? String
            let items = (JSON as? [AnyHashable : Any])?[kItems] as? [Any]
            var articles = [AnyHashable](repeating: 0, count: items?.count ?? 0)
            for item: [AnyHashable : Any]? in items as? [[AnyHashable : Any]?] ?? [] {
                autoreleasepool {
                    let article = Article(identifier: item?[kId] as? String ?? "", title: item?[kTitle] as? String ?? "", abstract: item?[kAbstract] as? String ?? "", urlString: "\(basePath ?? "")\(item?[kArticleURL])", thumbnailURLString: item?[kThumbnailURL] as? String ?? "") as? Article
                    if let anArticle = article {
                        articles.append(anArticle)
                    }
                }
            }
            return articles
        }, webserviceEndpoint: "http://gameofthrones.wikia.com/api/v1/Articles/Top", webserviceQuery: "?expand=1&category=Characters&limit=75")
    }
}