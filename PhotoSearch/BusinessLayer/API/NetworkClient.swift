//
//  NetworkClient.swift
//  CombineUIKit
//
//  Created by Rahul Gunjote on 1/2/2022.
//

import Foundation
import Combine

struct NetworkClient {
    
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    static func publisher(for request: URLRequest) -> AnyPublisher<Data, URLError> {
        URLSession.shared
            .dataTaskPublisher(for: request)
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
