//
//  PhotoCell.swift
//  PhotoSearch
//
//  Created by Rahul Gunjote on 1/2/2022.
//

import UIKit
import Combine




final class PhotoCell: UICollectionViewCell {
    
    //@IBOutlet weak var imageView: UIImageView!
    // MARK: - Properties
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    @Published private var image: UIImage? = nil
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscriptions = Set<AnyCancellable>()
    }
    
    func bind(_ photo: Photo) {
        guard let url = photo.imageURL else {
            imageView.image = nil
            print("Invalid image URL")
            return
        }
        print(url.absoluteString)
        
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .map { UIImage(data: $0) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: &$image)
        
        $image
            .sink { [weak self] image in
                self?.imageView.image = image
            }
            .store(in: &subscriptions) 
    }
}

// MARK: - UI Setup
extension PhotoCell {
    private func setupUI() {
        self.contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
}
