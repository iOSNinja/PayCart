//
//  ProductRepositoryTests.swift
//  PayCartTests
//
//  Created by Ravi Doddi on 5/16/26.
//

import XCTest
@testable import PayCart

final class ProductRepositoryTests: XCTestCase {
    var apiClient: MockAPIClient!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        
        apiClient = MockAPIClient()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        apiClient = nil
        try super.tearDownWithError()
    }

    func testFetchProductDetails_UsesCorrectURL() {
        apiClient.resultToReturn = MockProduct.make(
            id: 5,
            title: "Test",
            description: "Desc",
            price: 10,
            image: "",
            category: "Cat"
        )

        let repository = ProductRepository(apiClient: apiClient)

        repository.fetchProductDetails(productId: 5) { _ in }

        XCTAssertEqual(
            apiClient.requestedUrl,
            "https://fakestoreapi.com/products/5"
        )
    }

}
