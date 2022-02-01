//
//  PhotosCoordinator.swift
//  PhotoSearch
//
//  Created by Rahul Gunjote on 1/2/2022.
//

import UIKit

protocol PhotosCoordinator {
    //navigation to other screens
}

class PhotosCoordinatorImplementation: Coordinator, PhotosCoordinator {
    unowned let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let photosViewController = PhotosViewController()
        let photosViewModel = PhotosViewModel(
            //photosService: FlickrPhotosService(),
            coordinator: self
        )
        photosViewController.viewModel = photosViewModel
        
        navigationController
            .pushViewController(photosViewController, animated: true)
    }
}

