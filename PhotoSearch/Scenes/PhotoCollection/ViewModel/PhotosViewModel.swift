//
//  PhotosViewModel.swift
//  PhotoSearch
//
//  Created by Rahul Gunjote on 1/2/2022.
//

import Foundation
import Combine

final class PhotosViewModel {
    
    // MARK: - Private Properties
    private let coordinator: PhotosCoordinator
    
    @Published var photos: [Photo] = []
    @Published var searching: Bool = false
    
    private var subscriptions = Set<AnyCancellable>()

    init(coordinator: PhotosCoordinator) {
        self.coordinator = coordinator
    }
    func reachedToBottom(publisher: AnyPublisher<Void, Never>) {
        
        //TODO: Implement pagination here
        
    }
    func bind(emptyString: AnyPublisher<Void, Never>) {
        emptyString.sink {
            self.photos = []
        }.store(in: &subscriptions)
    }
    func bind(searchQuery: AnyPublisher<String, Never>) {
    
        let search = searchQuery
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.global())
            .print()
            .map {
                URLRequest.searchPhotos(query: $0)
            }
            .share()

        let photos = search
            .map { NetworkClient.publisher(for: $0) }
            .switchToLatest()
            .decode(type: SearchResult.self, decoder: NetworkClient.jsonDecoder)
            .map {
                $0.photoResult
            }
            .replaceError(with: .emptyResults)
            .share()

        photos
            .compactMap(\.?.photos)
            .receive(on: DispatchQueue.main)
            .assign(to: &$photos)

        search
            .map { _ in true }
            .merge(with: photos
                    .map { _ in false }
                    .delay(for: .seconds(0.5), scheduler: DispatchQueue.global()))
            .replaceError(with: false)
            .receive(on: DispatchQueue.main)
            .assign(to: &$searching)
    }
}
