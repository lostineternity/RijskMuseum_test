//
//  CollectionViewModelTest.swift
//  RijksMuseumTests
//
//  Created by Sokol Vadym on 5/14/21.
//

import XCTest
@testable import RijksMuseum

class PreviewViewModelTest: XCTestCase, PreviewViewModelDelegate {
    private var modelUnderTest: PreviewViewModelImpl!
    private var promise: XCTestExpectation!
    private var pageNumber: Int!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let collectionNetworkService = PreviewNetworkServiceImpl(requestService: RequestServiceImpl())
        modelUnderTest = PreviewViewModelImpl(with: collectionNetworkService,
                                                 router: PreviewRouterImpl(context: UIViewController()))
        modelUnderTest.delegate = self
    }

    override func tearDownWithError() throws {
        modelUnderTest = nil
        try super.tearDownWithError()
    }

    func testPreviewViewModel() throws {
        promise = expectation(description: "Fetched and translated collection data to model items")
        pageNumber = modelUnderTest.currentPage
        modelUnderTest.fetchData(page: nil)
        wait(for: [promise], timeout: 10)
    }

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
        XCTFail("Error while fetching data occured")
        XCTAssertEqual(modelUnderTest.isFetching, false, "Error fetching status")
    }
    
}
