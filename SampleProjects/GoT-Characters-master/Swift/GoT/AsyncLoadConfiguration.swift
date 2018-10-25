//
//  AsyncLoadConfiguration.swift
//  GoT
//
//  Created by Paciej on 24/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

//
//  LoaderConfiguration.m
//  GoT
//
//  Created by Paciej on 24/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

import Foundation

class AsyncLoadConfiguration: NSObject {
    var responseParsingBlock: ((_ result: Data) -> Any?)? {
        return parsingBlock ?? { _ in return  }
    }
    var webserviceEndpoint: String {
        return endpoint
    }
    var webserviceQuery: String? {
        return query
    }

    private var parsingBlock: ((_ result: Data) -> Any?)!
    private var endpoint = ""
    private var query: String?

    init(responseParsingBlock block: @escaping (_ result: Data) -> Any?, webserviceEndpoint endpoint: String, webserviceQuery query: String?) {
        super.init()
        
        parsingBlock = block
        self.endpoint = endpoint
        self.query = query
    
    }
}

extension AsyncLoadConfiguration {
    convenience init(fromArticle article: Article) {
        self.init(responseParsingBlock: { result in
            var data: Data?
            if (result is Data) && UIImage(data: result) != nil {
                data = result
            }
            return data
        }, webserviceEndpoint: article.thumbnailURLString, webserviceQuery: nil)
    }
}