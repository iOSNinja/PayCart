//
//  MockProductRepository.swift
//  PayCartTests
//
//  Created by Ravi Doddi on 5/16/26.
//

import Foundation
@testable import PayCart

final class MockProductRepository: ProductRepositoryProtocol {
    var shouldReturnError = false
    
    var fetchProductsCalled = false
    var fetchProductDetailsCalled = false
    var requestedProductId: Int?
    
    var mockProduct = MockProduct.make(
        id: 1,
        title: "Harry Potter Book1",
        description: "The Beginning of the Magical World!",
        price: 25.00,
        image: "",
        category: "Novels")
    
    func fetchProducts(completion: @escaping (Result<[PayCart.Product], PayCart.NetworkError>) -> Void) {
        fetchProductsCalled = true
        
        if shouldReturnError {
            completion(.failure(.serverError))
        } else {
            // return mock response
            completion(.success([mockProduct]))
        }
    }
    
    func fetchProductDetails(productId: Int, completion: @escaping (Result<PayCart.Product, PayCart.NetworkError>) -> Void) {
        requestedProductId = productId
        fetchProductDetailsCalled = true
        
        if shouldReturnError {
            completion(.failure(.serverError))
        } else {
            // return mock response
            completion(.success(mockProduct))
        }
    }
}
