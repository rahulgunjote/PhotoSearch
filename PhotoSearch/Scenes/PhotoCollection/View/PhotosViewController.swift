//
//  PhotosViewController.swift
//  PhotoSearch
//
//  Created by Rahul Gunjote on 1/2/2022.
//

import UIKit
import Combine
import CombineCocoa
import CombineDataSources

final class PhotosViewController: UIViewController {
    
    //MARK: Properties
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var activityView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.tintColor = .black
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .black
        searchController.searchBar.delegate = nil
        return searchController
    }()
    
    
    var viewModel:PhotosViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.drawCollectionLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // Have the collection view re-layout its cells.
        coordinator.animate(
            alongsideTransition: { _ in
                self.drawCollectionLayout()
            },
            completion: { _ in }
        )
        super.viewWillTransition(to: size, with: coordinator)

    }
}

//MARK: Combine data bindings
extension PhotosViewController {
    func setupDataBindings() {
        
        viewModel.bind(searchQuery: searchController.searchBar.textDidChangePublisher)
        viewModel.bind(emptyString: searchController.searchBar.cancelButtonClickedPublisher)
        
        viewModel
            .$photos
            .bind(subscriber: collectionView.itemsSubscriber(cellIdentifier: PhotoCell.reuseIdentifier, cellType: PhotoCell.self, cellConfig: { cell, _, photo in
                cell.bind(photo)
              }))
              .store(in: &subscriptions)
        

        viewModel
            .reachedToBottom(publisher: collectionView.reachedBottomPublisher())
        
        viewModel
            .$searching
            .sink { [weak activityView] searching in
                searching ? activityView?.startAnimating() : activityView?.stopAnimating()
            }
            .store(in: &subscriptions)
        
        searchController
            .searchBar
            .searchButtonClickedPublisher
            .sink { [weak self] in
                self?.searchController.searchBar.resignFirstResponder()
            }
            .store(in: &subscriptions)
    }
}

//MARK: UI setup
extension PhotosViewController {
    
    private func setupUI() {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = .label
        self.navigationController?.navigationBar.isTranslucent = true
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        // Place the search bar in the navigation item's title view.
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false

        self.view.addSubview(collectionView)
        self.view.addSubview(activityView)
                
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
    }
    
    private func drawCollectionLayout() {
        let numberOfItemPerRow:CGFloat = 3
        let lineSpacing:CGFloat = 5
        let interItemSpacing:CGFloat = 5
        
        let width = (collectionView.frame.width - (numberOfItemPerRow ) * interItemSpacing) / numberOfItemPerRow
        let height = width
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: width, height: height)
        collectionViewLayout.sectionInset = .zero
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumLineSpacing = lineSpacing
        collectionViewLayout.minimumInteritemSpacing = interItemSpacing
        self.collectionView.setCollectionViewLayout(collectionViewLayout, animated: true)
    }
    
    
}
