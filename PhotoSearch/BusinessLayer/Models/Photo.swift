//
//  Photo.swift
//  CombineUIKit
//
//  Created by Greg Price on 30/03/2021.
//

import Foundation

// MARK: - FlickerResponseDto
struct SearchResult: Codable {
    
    let photoResult: PhotoResult?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case photoResult = "photos"
        case status = "stat"
    }
}


// MARK: - Photos
struct PhotoResult: Codable {
    let currentPage: Int?
    let totalPages: Int?
    let perPageLimit: Int?
    let totalPhotos: Int?
    let photos: [Photo]?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case totalPages = "pages"
        case perPageLimit = "perpage"
        case totalPhotos = "total"
        case photos = "photo"
    }
}
extension PhotoResult {
    static var emptyResults: PhotoResult {
        PhotoResult(currentPage: 0, totalPages: 0, perPageLimit: 0, totalPhotos: 0, photos: [])
    }
}
// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String?
    let farm: Int?
    let title: String?
    let ispublic, isfriend, isfamily: Int?
}


extension Photo {
    
    var imageURL: URL? {
        guard let farm = self.farm,
              let server = self.server,
              let photoID = self.id,
              let secret = self.secret else {
                  return nil
              }
            
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret).jpg")
    }
}


//struct SearchPhotos: Decodable {
//    let results: [Photo]
//}
//
//extension SearchPhotos {
//    static var emptyResults: SearchPhotos {
//        SearchPhotos(results: [])
//    }
//}
//
//struct Photo: Decodable {
//    let id: String
//    let urls: PhotoUrls
//}
//
//struct PhotoUrls: Decodable {
//    let raw: String
//    let full: String
//    let regular: String
//    let small: String
//    let thumb: String
//}

extension Photo: Hashable, Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }
}

//extension PhotoUrls: Hashable, Equatable {
//    static func == (lhs: PhotoUrls, rhs: PhotoUrls) -> Bool {
//        lhs.raw == rhs.raw
//    }
//}
