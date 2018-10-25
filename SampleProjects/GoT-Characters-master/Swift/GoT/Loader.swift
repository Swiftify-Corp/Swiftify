//
//  Loader.swift
//  GoT
//
//  Created by Paciej on 21/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

import Foundation

class Loader: NSObject {
    private var webserviceURLString = ""
    private var session: URLSession!

    init(webserviceURLString urlString: String, session: URLSession) {
        super.init()
        
        webserviceURLString = urlString
        self.session = session
    
    }

    func loadAsynchronously(_ configuration: AsyncLoadConfiguration, callback: ((_ result: Any?) -> Void)? = nil) {
        let urlString = "\(webserviceURLString)\(configuration.webserviceEndpoint)\(configuration.webserviceQuery ?? "")" //TODO: use NSURLQueryItem  https://littlebitesofcocoa.com/128-nsurlqueryitem-nsurlcomponents
        let components = URLComponents(string: urlString)
        var task: URLSessionDataTask? = nil
        if let anURL = components?.url {
            task = session.dataTask(with: anURL, completionHandler: { data, response, error in
                if error != nil {
                    print("loadAsynchronously error: \(error.debugDescription)")
                    callback?(nil)
                    return
                }
                let parsedObject = configuration.responseParsingBlock?(data!)
                callback?(parsedObject)
            })
        }
        task?.resume()
    }
}