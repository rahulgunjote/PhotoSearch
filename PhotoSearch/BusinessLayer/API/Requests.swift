//
//  Requests.swift
//  CombineUIKit
//
//  Created by Greg Price on 30/03/2021.
//

import Foundation
import Combine

extension URLComponents {
    
    static func flickrSearch(path: String, queryItems: [String: String]) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = path
        components.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components
    }
}

extension URLRequest {
    
    static func searchPhotos(query: String, pageNumber: Int = 1) -> URLRequest {
        let url = URLComponents
            .flickrSearch(path: "/services/rest",
                      queryItems: [
                        "method": "flickr.photos.search",
                        "api_key":  apiKey,
                        "text":  query,
                        "format": "json",
                        "nojsoncallback": "1",
                        "safe_search": "\(pageNumber)"
                      ]).url!
        var request = URLRequest(url: url)
        request.setValue("v1", forHTTPHeaderField: "Accept-Version")
        return request
    }
    static var apiKey: String {
        return "96358825614a5d3b1a1c3fd87fca2b47"
        //return "66da51cd10617837f2ef218c1fe31c16"
    }
}
