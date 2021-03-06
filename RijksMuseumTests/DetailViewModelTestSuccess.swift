//
//  DetailViewModelTest.swift
//  RijksMuseumTests
//
//  Created by Sokol Vadym on 5/14/21.
//

import XCTest
@testable import RijksMuseum

class DetailViewModelTestSuccess: XCTestCase {
    private var modelUnderTest: DetailViewModelImpl!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let testItemId = "SK-A-4100"
        modelUnderTest = DetailViewModelImpl(with: testItemId,
                                             networkService: fakeDetailNetworkService())
    }

    override func tearDownWithError() throws {
        modelUnderTest = nil
        try super.tearDownWithError()
    }

    func testSuccessCase() throws {
        configureTestEnviromentSuccessCase()
    }
    
    private func configureTestEnviromentSuccessCase() {
        let fakeViewModelDelegate = fakeViewModelDelegateImplSuccessCase()
        fakeViewModelDelegate.promise = expectation(description: "Fetched and decoded item data into model")
        modelUnderTest.delegate = fakeViewModelDelegate
        modelUnderTest.fetchData()
        wait(for: [fakeViewModelDelegate.promise], timeout: 10)
    }
}

fileprivate class fakeViewModelDelegateImplSuccessCase: DetailViewModelDelegate {
    
    var promise: XCTestExpectation!
 
    func fetchingProcessing() {}
    
    func successFetching(with item: DetailItem) {
        XCTAssertNotNil(item.image, "Missed image data")
        if let section = item.itemInfo.first(where: { $0.sectionName == "General information"}) {
            XCTAssertNotNil(section.sectionInfo.first(where: {$0.name == "Obj. number"}), "Missed data")
            XCTAssertNotNil(section.sectionInfo.first(where: {$0.name == "Title"}), "Missed data")
            XCTAssertNotNil(section.sectionInfo.first(where: {$0.name == "Additional"}), "Missed data")
        } else {
            XCTFail("Missed info section data")
        }
        if let section = item.itemInfo.first(where: { $0.sectionName == "Creation info"}) {
            XCTAssertNotNil(section.sectionInfo.first(where: {$0.name == "Creator"}), "Missed data")
            XCTAssertNotNil(section.sectionInfo.first(where: {$0.name == "Estimate creation date"}), "Missed data")
            XCTAssertNotNil(section.sectionInfo.first(where: {$0.name == "Type"}), "Missed data")
            XCTAssertNotNil(section.sectionInfo.first(where: {$0.name == "Materials"}), "Missed data")
            
            XCTAssertNil(section.sectionInfo.first(where: {$0.name == "Techniques"}), "Exhausted data")
        } else {
            XCTFail("Missed info section data")
        }
        if let section = item.itemInfo.first(where: { $0.sectionName == "Acquisition info"}) {
            XCTAssertNotNil(section.sectionInfo.first(where: {$0.name == "Method"}), "Missed data")
            
            XCTAssertNil(section.sectionInfo.first(where: {$0.name == "Credit line"}), "Exhausted data")
        } else {
            XCTFail("Missed info section data")
        }
        promise.fulfill()
    }
    
    func failureFetching(with errorDescription: String) {
        XCTFail("Error fetching data")
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
        let path = Bundle.main.path(forResource: "mockSuccessItem", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        let fakeObject = try! JSONDecoder().decode(ArtObjectDetailCover.self, from: data)
        completionHandler(.success(fakeObject))
    }
    
    func loadItemHeaderImage(with urlString: String, completionHandler: @escaping DetailItemImageComletionHandler) {
        completionHandler(.success(Data()))
    }
}
