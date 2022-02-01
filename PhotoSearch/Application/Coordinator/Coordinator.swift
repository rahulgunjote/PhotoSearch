//
//  Coordinator.swift
//  PhotoSearch
//
//  Created by Rahul Gunjote on 1/2/2022.
//

import Foundation

protocol Coordinator {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}
