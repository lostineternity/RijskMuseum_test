//
//  DetailViewModelTest.swift
//  RijksMuseumTests
//
//  Created by Sokol Vadym on 5/14/21.
//

import XCTest
@testable import RijksMuseum

class DetailViewModelTestError: XCTestCase {
    private var modelUnderTest: DetailViewModelImpl!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        modelUnderTest = DetailViewModelImpl(with: "testItemId",
                                             networkService: fakeDetailNetworkService())
    }

    override func tearDownWithError() throws {
        modelUnderTest = nil
        try super.tearDownWithError()
    }

    func testErrorCase() throws {
        configureTestEnviromentSuccessCase()
    }

    private func configureTestEnviromentSuccessCase() {
        let fakeViewModelDelegate = fakeViewModelDelegateImplErrorCase()
        fakeViewModelDelegate.promise = expectation(description: "Fetched and translated item data to model")
        modelUnderTest.delegate = fakeViewModelDelegate
        modelUnderTest.fetchData()
        wait(for: [fakeViewModelDelegate.promise], timeout: 10)
    }
}

fileprivate class fakeViewModelDelegateImplErrorCase: DetailViewModelDelegate {
    
    var promise: XCTestExpectation!
    
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
