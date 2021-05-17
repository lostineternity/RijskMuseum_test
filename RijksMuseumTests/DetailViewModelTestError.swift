//
//  DetailViewModelTest.swift
//  RijksMuseumTests
//
//  Created by Sokol Vadym on 5/14/21.
//

import XCTest
@testable import RijksMuseum

class DetailViewModelTestError: XCTestCase, DetailViewModelDelegate{
    private var modelUnderTest: DetailViewModelImpl!
    private var promise: XCTestExpectation!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let testItemId = "SK-A-4100"
        modelUnderTest = DetailViewModelImpl(with: testItemId,
                                             networkService: fakeDetailNetworkService())
        modelUnderTest.delegate = self
    }

    override func tearDownWithError() throws {
        modelUnderTest = nil
        try super.tearDownWithError()
    }

    func testErrorCase() throws {
        promise = expectation(description: "Fetched and translated item data to model")
        modelUnderTest.fetchData()
        wait(for: [promise], timeout: 10)
    }

    func fetchingProcessing() {}
    
    func successFetching(with item: DetailItem) {
        XCTFail("Error while fetching data occured - fetching succeed")
    }
    
    func failureFetching(with errorDescription: String) {
        XCTAssertNotEqual(errorDescription, "", NetworkError.decodingError.errorDerscription)
        promise.fulfill()
    }

}

fileprivate struct fakeDetailNetworkService: DetailNetworkService {
    var requestService: RequestService
    
    init() {
        self.requestService = RequestServiceImpl()
    }
  
    typealias DetailItemComletionHandler = (Result<ArtObjectDetailCover, NetworkError>)->()
    typealias DetailItemImageComletionHandler = (Result<Data, NetworkError>)->()
    
    func fetchDetailItemData(with itemId: String, completionHandler: @escaping DetailItemComletionHandler) {
        completionHandler(.failure(.decodingError))
    }
    
    func loadItemHeaderImage(with urlString: String, completionHandler: @escaping DetailItemImageComletionHandler) {
        completionHandler(.success(Data()))
    }
}
