//
//  CollectionViewModelTest.swift
//  RijksMuseumTests
//
//  Created by Sokol Vadym on 5/14/21.
//

import XCTest
@testable import RijksMuseum

class PreviewViewModelTest: XCTestCase {
    private var modelUnderTest: PreviewViewModelImpl!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let collectionNetworkService = PreviewNetworkServiceImpl(requestService: RequestServiceImpl())
        modelUnderTest = PreviewViewModelImpl(with: collectionNetworkService,
                                                 router: PreviewRouterImpl(context: UIViewController()))
    }

    override func tearDownWithError() throws {
        modelUnderTest = nil
        try super.tearDownWithError()
    }

    func testPreviewViewModel() throws {
        configureTestEnviromentSuccessCase()
    }

    private func configureTestEnviromentSuccessCase() {
        let fakeViewModelDelegate = fakeViewModelDelegateImplSuccessCase()
        fakeViewModelDelegate.modelUnderTest = modelUnderTest
        fakeViewModelDelegate.promise = expectation(description: "Fetched and decoded collection data into model items")
        fakeViewModelDelegate.pageNumber = modelUnderTest.currentPage
        modelUnderTest.delegate = fakeViewModelDelegate
        modelUnderTest.fetchData(page: nil)
        wait(for: [fakeViewModelDelegate.promise], timeout: 10)
    }
}

fileprivate class fakeViewModelDelegateImplSuccessCase: PreviewViewModelDelegate {
    var modelUnderTest: PreviewViewModelImpl!
    var promise: XCTestExpectation!
    var pageNumber: Int!
    
    func fetchingProcessing() {
        XCTAssertEqual(modelUnderTest.isFetching, true, "Error fetching status")
    }
    
    func successFetching(with items: [ArtObjectPreview]) {
        let expectedItemCount = Int(PreviewDataSettings.itemsPerPage)!*pageNumber
        XCTAssertEqual(items.count, expectedItemCount, "Error items count")
        XCTAssertEqual(modelUnderTest.currentPage, pageNumber + 1, "Error page number update")
        XCTAssertEqual(modelUnderTest.isFetching, false, "Error fetching status")
        promise.fulfill()
    }
    
    func failureFetching(with errorDescription: String) {
        XCTFail("Error fetching data")
        XCTAssertEqual(modelUnderTest.isFetching, false, "Error fetching status")
    }
}
