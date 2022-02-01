//
//  Extensions.swift
//  PhotoSearch
//
//  Created by Rahul Gunjote on 1/2/2022.
//

import UIKit

protocol ReuseIdentifiable: AnyObject {
    
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    
    static var reuseIdentifier: String { .init(describing: self) }
}

extension UICollectionViewCell: ReuseIdentifiable {
    
}

