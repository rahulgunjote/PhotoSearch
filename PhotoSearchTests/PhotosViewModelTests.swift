//
//  PhotosViewModelTests.swift
//  PhotoSearchTests
//
//  Created by Rahul Gunjote on 1/2/2022.
//

import XCTest
import Combine
@testable import PhotoSearch

class PhotosViewModelTests: XCTestCase {
    
    private var sut: PhotosViewModel!
    private var rootNavigationController: UINavigationController!
    private var subscriptions:Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        rootNavigationController = UINavigationController()
        sut = PhotosViewModel(coordinator:
                                PhotosCoordinatorImplementation(navigationController: rootNavigationController))
        subscriptions = Set<AnyCancellable>()
        
    }
    override func tearDownWithError() throws {
        rootNavigationController = nil
        sut = nil
        subscriptions = nil
    }
    

    func testWhenPhotosArePopulated() throws {
        
        let photos = [
            Photo(id: "1", owner: "Flickr", secret: "123", server: "XYZ", farm: 0, title: "", ispublic: 1, isfriend: 1, isfamily: 1),
            Photo(id: "2", owner: "Flickr", secret: "456", server: "ABC", farm: 1, title: "", ispublic: 1, isfriend: 1, isfamily: 1),
            Photo(id: "3", owner: "Flickr", secret: "789", server: "EFG", farm: 3, title: "", ispublic: 1, isfriend: 1, isfamily: 1)
        ]
        sut.photos = photos
        
        let expectation = XCTestExpectation(description: "State is set to populated")
        
        sut.$photos.sink { value in
            XCTAssertEqual(value.count, 3)
            expectation.fulfill()
        }.store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 5)

    }
    
    func testWhenPhotosAreEmpty() throws {
        
        let expectation = XCTestExpectation(description: "State is set to Empty")
        
        sut.$photos.sink { value in
            XCTAssertEqual(value.count, 0)
            expectation.fulfill()
        }.store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 5)

    }

    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
