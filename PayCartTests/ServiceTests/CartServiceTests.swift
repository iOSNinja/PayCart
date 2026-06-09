//
//  CartServiceTests.swift
//  PayCartTests
//
//  Created by Ravi Doddi on 5/16/26.
//

import XCTest
@testable import PayCart

final class CartServiceTests: XCTestCase {
    
    private var cartService: CartService?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // init cartService
        cartService = CartService()
    }
    
    // MARK: - Test Cases for CartService methods
    func testAddProduct_WhenCartisEmpty_AddsNewItem() {
        // Arrange
        // Setup data & inject dependencies as needed
        let product1 = MockProduct.make(id: 1, title: "Harry Potter Book1", description: "The Beginning of the Magical World!", price: 25.00, image: "", category: "Novels")
        let product2 = MockProduct.make(id: 2, title: "Harry Potter Book2", description: "The wizard kids...", price: 35.65, image: "", category: "Novels")
        let product3 = MockProduct.make(id: 3, title: "Harry Potter Book3", description: "The master and his kids...", price: 45.99, image: "", category: "Novels")
        
        // Act
        cartService?.add(product: product1)
        cartService?.add(product: product2)
        cartService?.add(product: product3)
        
        // Assert
        XCTAssertEqual(cartService?.items.count, 3)
        XCTAssertTrue(cartService?.items.first?.product.description == "The Beginning of the Magical World!")
        XCTAssertEqual(cartService?.items.last?.product.price, 45.99)
    }
    
    func testAddProduct_WhenSameProductAddedAgain_IncreaseQuantity() {
        // Arrange
        let product1 = MockProduct.make(id: 1, title: "Harry Potter Book1", description: "The Beginning of the Magical World!", price: 25.00, image: "", category: "Novels")
        let product2 = MockProduct.make(id: 1, title: "Harry Potter Book1", description: "The Beginning of the Magical World!", price: 25.00, image: "", category: "Novels")
        
        // Act
        cartService?.add(product: product1)
        cartService?.add(product: product2)
        
        // Assert
        XCTAssertEqual(cartService?.items.first?.quantity, 2)
        XCTAssertEqual(cartService?.items.first?.totalPrice, 50)
        XCTAssertEqual(cartService?.items.count, 1)
    }
    
    func testRemoveProduct_RemoveMatchingProduct() {
        // Arrange
        // Setup data & inject dependencies as needed
        let product1 = MockProduct.make(id: 1, title: "Harry Potter Book1", description: "The Beginning of the Magical World!", price: 25.00, image: "", category: "Novels")
        let product2 = MockProduct.make(id: 2, title: "Harry Potter Book2", description: "The wizard kids...", price: 35.65, image: "", category: "Novels")
        let product3 = MockProduct.make(id: 3, title: "Harry Potter Book3", description: "The master and his kids...", price: 45.99, image: "", category: "Novels")
        
        // Act
        cartService?.add(product: product1)
        cartService?.add(product: product2)
        cartService?.add(product: product3)
        
        XCTAssertEqual(cartService?.items.count, 3)
        
        cartService?.remove(productId: product3.id)
        
        // Assert
        XCTAssertEqual(cartService?.items.count, 2)
        XCTAssertEqual(cartService?.items.last?.product.id, 2)
    }
    
    func testUpdateQuantity_WhenQuantityIsPositive_IncrementsQuantity() {
        // Arrange
        let product1 = MockProduct.make(id: 1, title: "Harry Potter Book1", description: "The Beginning of the Magical World!", price: 25.00, image: "", category: "Novels")
        let product2 = MockProduct.make(id: 2, title: "Harry Potter Book2", description: "The wizard kids...", price: 35.65, image: "", category: "Novels")
        let product3 = MockProduct.make(id: 3, title: "Harry Potter Book3", description: "The master and his kids...", price: 45.99, image: "", category: "Novels")
        
        // Act
        cartService?.add(product: product1)
        cartService?.add(product: product2)
        cartService?.add(product: product3)
        
        cartService?.updateQuantity(productId: 1, quantity: 10)
        cartService?.updateQuantity(productId: 3, quantity: 100)
        
        // Assert
        XCTAssertEqual(cartService?.items.first?.quantity, 10)
        XCTAssertEqual(cartService?.items.first?.totalPrice, 250.00)
        XCTAssertEqual(cartService?.items.last?.quantity, 100)
        XCTAssertEqual(cartService?.items[1].quantity, 1)
        XCTAssertEqual(cartService?.items.count, 3)
    }
    
    func testUpdateQuantity_WhenQuantityIsPositive_DecrementsQuantity() {
        
    }
    
    override func tearDownWithError() throws {
        // reset before each test case
        cartService = nil
        try super.tearDownWithError()
    }
}
