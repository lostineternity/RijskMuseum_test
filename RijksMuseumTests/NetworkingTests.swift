//
//  RijksMuseumTests.swift
//  RijksMuseumTests
//
//  Created by Sokol Vadym on 5/10/21.
//

import XCTest
@testable import RijksMuseum

class RijksMuseumNetworkingTests: XCTestCase {
    
    private var requestService: RequestService!
    private var previewNetworkServiceUnderTest: PreviewNetworkService!
    private var detailNetworkServiceUnderTest: DetailNetworkService!
    private var previewItemNetworkServiceUnderTest: PreviewItemNetworkService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        requestService = RequestServiceImpl()
        previewNetworkServiceUnderTest = PreviewNetworkServiceImpl(requestService: requestService)
        detailNetworkServiceUnderTest = DetailNetworkServiceImpl(requestService: requestService)
        previewItemNetworkServiceUnderTest = PreviewItemNetworkServiceImpl(requestService: requestService)
    }

    override func tearDownWithError() throws {
        requestService = nil
        previewNetworkServiceUnderTest = nil
        detailNetworkServiceUnderTest = nil
        previewItemNetworkServiceUnderTest = nil
        try super.setUpWithError()
    }

    func testCollectionDataFetching() throws {
        let promise = expectation(description: "Fetched collection data")
        previewNetworkServiceUnderTest.fetchCollectionData(page: 1) { response in
            switch response {
            case .success(let items):
                if items.artObjects.count == Int(PreviewDataSettings.itemsPerPage) {
                    promise.fulfill()
                } else {
                    XCTFail("Wrong items count")
                }
            case .failure:
                XCTFail("Failed network request")
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testCollectionItemHeaderImageDataLoading() throws {
        let promise = expectation(description: "Fetched image data")
        let urlString = "https://lh3.googleusercontent.com/YjKvOkkf3epcceNunYHLeCrDFYNfADyeWnx_TkKyF1tzWPhotNzQaLztgeyfujmhgLG1LSBUv_oOtGL0bTWmgYxBEw=s0"
        previewItemNetworkServiceUnderTest.loadImageData(with: urlString) { response in
            switch response {
            case .success:
                promise.fulfill()
            case .failure:
                XCTFail("Failed loading image data")
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testDetailItemDataFetching() throws {
        let promise = expectation(description: "Fetched collection data")
        let itemId = "SK-A-4100"
        detailNetworkServiceUnderTest.fetchDetailItemData(with: itemId) { response in
            switch response {
            case .success:
                promise.fulfill()
            case .failure:
                XCTFail("Failed fetching item data")
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testDetailItemImageDataLoading() throws {
        let promise = expectation(description: "Fetched image data")
        let urlString = "https://lh3.googleusercontent.com/vkoS9jmZLZWuWH1LNIG3eJUVI6W7XqOUKmFf_lcuB4m1nJydWPXZGggi3XGwmirNj1wLdiO7sH6x5fJ60XJnH2expg=s0"
        detailNetworkServiceUnderTest.loadItemHeaderImage(with: urlString) { response in
            switch response {
            case .success:
                promise.fulfill()
            case .failure:
                XCTFail("Failed loading image data")
            }
        }
        wait(for: [promise], timeout: 5)
    }

}
