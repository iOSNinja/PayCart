//
//  ProductDetailsViewModelTests.swift
//  PayCartTests
//
//  Created by Ravi Doddi on 5/16/26.
//

import XCTest
@testable import PayCart

final class ProductDetailsViewModelTests: XCTestCase {
    
    var repository: MockProductRepository!
    var cartService: MockCartService!
    var productDetailsVM: ProductDetailsViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        
        // Global Arrange
        repository = MockProductRepository()
        cartService = MockCartService()
        productDetailsVM = ProductDetailsViewModel(productId: 1, repository: repository!, cartService: cartService!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        repository = nil
        cartService = nil
        productDetailsVM = nil
        
        try super.tearDownWithError()
    }

    func testLoadProductDetails_WhenSuccess_StoresProduct() {
        
        // Act
        let expectation = expectation(description: "to have Product Loaded.")
        
        productDetailsVM?.onProductLoaded = {
            expectation.fulfill()
        }
        
        productDetailsVM?.loadProductDetails()
        wait(for: [expectation], timeout: 1.0)
        
        // Assert
        /*
         var mockProduct = Product(
             id: 1,
             title: "Harry Potter Book1",
             description: "The Beginning of the Magical World!",
             price: 25.00,
             image: "",
             category: "Novels")
         */
        XCTAssertTrue(repository.fetchProductDetailsCalled)
        XCTAssertEqual(repository.requestedProductId, 1)
        XCTAssertEqual(productDetailsVM.titleText(), "Harry Potter Book1")
        XCTAssertEqual(productDetailsVM.descriptionText(), "The Beginning of the Magical World!")
        XCTAssertEqual(productDetailsVM.priceText(), "$25.0")
        XCTAssertEqual(productDetailsVM.categoryText(), "Novels")
    }
    
    func testLoadProductDetails_WhenFailure_ShowsError() {
        repository.shouldReturnError = true

        let expectation = expectation(description: "Error shown")
        productDetailsVM.onError = { message in
            XCTAssertEqual(message, "Unable to load product details.")
            expectation.fulfill()
        }

        productDetailsVM.loadProductDetails()

        wait(for: [expectation], timeout: 1.0)
    }

    func testAddToCart_WhenProductIsLoaded_AddsProductToCart() {
        let loadExpectation = expectation(description: "Product loaded")

        productDetailsVM.onProductLoaded = {
            loadExpectation.fulfill()
        }

        productDetailsVM.loadProductDetails()

        wait(for: [loadExpectation], timeout: 1.0)

        let addExpectation = expectation(description: "Added to cart")

        productDetailsVM.onAddToCartSuccess = { message in
            XCTAssertEqual(message, "Added to cart.")
            addExpectation.fulfill()
        }

        productDetailsVM.addToCart()

        wait(for: [addExpectation], timeout: 1.0)

        XCTAssertTrue(cartService.addProductCalled)
        XCTAssertEqual(cartService.addedProduct?.id, 1)
        XCTAssertEqual(cartService.items.count, 1)
        XCTAssertEqual(cartService.items.first?.quantity, 1)
    }

    func testAddToCart_WhenProductIsNotLoaded_ShowsError() {
        let expectation = expectation(description: "Error shown")

        productDetailsVM.onError = { message in
            XCTAssertEqual(message, "Product details are not loaded yet.")
            expectation.fulfill()
        }

        productDetailsVM.addToCart()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertFalse(cartService.addProductCalled)
        XCTAssertTrue(cartService.items.isEmpty)
    }
}
