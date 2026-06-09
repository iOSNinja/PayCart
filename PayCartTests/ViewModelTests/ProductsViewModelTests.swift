//
//  ProductsViewModelTests.swift
//  PayCartTests
//
//  Created by Ravi Doddi on 5/16/26.
//

import XCTest
@testable import PayCart

final class ProductsViewModelTests: XCTestCase {

    func testLoadProductsSuccessUpdatesProducts() {
        let mockRepository = MockProductRepository()
        let viewModel = ProductsViewModel(productRepository: mockRepository)

        let expectation = expectation(description: "Products loaded")

        viewModel.onProductsLoaded = {
            expectation.fulfill()
        }

        viewModel.loadProducts()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.numberOfProducts(), 1)
        XCTAssertEqual(viewModel.product(at: 0).title, "Harry Potter Book1")
    }

    func testLoadProductsFailureShowsError() {
        let mockRepository = MockProductRepository()
        mockRepository.shouldReturnError = true

        let viewModel = ProductsViewModel(productRepository: mockRepository)

        let expectation = expectation(description: "Error shown")

        viewModel.onError = { message in
            XCTAssertEqual(message, "Server error. Please try again.")
            expectation.fulfill()
        }

        viewModel.loadProducts()

        wait(for: [expectation], timeout: 1.0)
    }
}
