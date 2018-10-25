//
//  ArticlesRepository.swift
//  GoT
//
//  Created by Paciej on 25/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

import Foundation

private var kSavedArticles = "SavedArticles"

class ArticlesRepository: NSObject {
    private var defaults: UserDefaults!
    private var articles: Set<AnyHashable> = []
    private var temporaryArticles: Set<AnyHashable> = []

    init(defaults: UserDefaults) {
        super.init()
        
        self.defaults = defaults
        articles = getFavouriteArticlesFromDefaults()
        temporaryArticles = Set<AnyHashable>()
    
    }

    func savedFavouritesArticles() -> [Any] {
        return Array(articles)
    }

    func saveFavouriteArticle(_ article: Article) {
        articles.insert(article)
        saveFavouriteArticlesToDefaults()
    }

    func removeFavouriteArticle(_ article: Article) {
        articles.remove(article)
        saveFavouriteArticlesToDefaults()
    }

    func isFavouriteArticle(_ article: Article) -> Bool {
        return articles.filter { NSPredicate(format: "identifier == %@", article.identifier).evaluate(with: $0) }.count > 0 // This could cause a perfromance issue for large data
        // sets!? TODO: verify and find better solution
    }

    func storeArticlesTemporarily(_ articles: [Any]) {
        temporaryArticles.formUnion(Set(articles.map { $0 as! AnyHashable }))
    }

    func temporarilyStoredArticles() -> [Any] {
        return Array(temporaryArticles)
    }

    func saveFavouriteArticlesToDefaults() {
        let archivedArticles = NSKeyedArchiver.archivedData(withRootObject: articles)
        defaults.set(archivedArticles, forKey: kSavedArticles)
        defaults.synchronize()
    }

    func getFavouriteArticlesFromDefaults() -> Set<AnyHashable> {
        let archivedArticles = defaults.object(forKey: kSavedArticles) as? Data
        var `set`: Set<AnyHashable>? = nil
        if let anArticles = archivedArticles {
            `set` = NSKeyedUnarchiver.unarchiveObject(with: anArticles) as? Set<AnyHashable>
        }
        if `set` == nil {
            `set` = Set<AnyHashable>()
        }
        return `set` ?? []
    }
}