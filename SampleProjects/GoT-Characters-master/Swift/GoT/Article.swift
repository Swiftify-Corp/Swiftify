//
//  Article.swift
//  GoT
//
//  Created by Paciej on 25/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

import UIKit

private var kArticleIdentifier = "privateIdentifier"
private var kArticleTitle = "privateTitle"
private var kArticleAbstract = "privateAbstract"
private var kArticleThumbnailURL = "privateThumbnailURLString"
private var kArticleThumbnailData = "thumbnailData"

class Article: NSObject, NSCoding {
    var title: String {
        return privateTitle
    }
    var identifier: String {
        return privateIdentifier
    }
    var abstract: String {
        return privateAbstract
    }
    var urlString: String {
        return privateUrlString
    }
    var thumbnailURLString: String {
        return privateThumbnailURLString
    }
    var thumbnailData: Data?

    private var privateIdentifier = ""
    private var privateTitle = ""
    private var privateAbstract = ""
    private var privateThumbnailURLString = ""
    private var privateUrlString = ""

    init(identifier: String, title: String, abstract: String, urlString: String, thumbnailURLString: String) {
        super.init()
        
        privateIdentifier = identifier
        privateTitle = title
        privateAbstract = abstract
        privateUrlString = urlString
        privateThumbnailURLString = thumbnailURLString
    
    }

    func imageFromThumbnailData() -> UIImage? {
        if let aData = thumbnailData {
            return UIImage(data: aData)
        }
        return nil
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(privateIdentifier, forKey: kArticleIdentifier)
        aCoder.encode(privateTitle, forKey: kArticleTitle)
        aCoder.encode(privateAbstract, forKey: kArticleAbstract)
        aCoder.encode(privateThumbnailURLString, forKey: kArticleThumbnailURL)
        aCoder.encode(thumbnailData, forKey: kArticleThumbnailData)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        privateIdentifier = aDecoder.decodeObject(forKey: kArticleIdentifier) as? String ?? ""
        privateTitle = aDecoder.decodeObject(forKey: kArticleTitle) as? String ?? ""
        privateAbstract = aDecoder.decodeObject(forKey: kArticleAbstract) as? String ?? ""
        privateThumbnailURLString = aDecoder.decodeObject(forKey: kArticleThumbnailURL) as? String ?? ""
        thumbnailData = aDecoder.decodeObject(forKey: kArticleThumbnailData) as? Data
    
    }
}