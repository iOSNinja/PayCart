//
//  ProductRepository.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import Foundation

final class ProductRepository: ProductRepositoryProtocol {
    private var apiClient: APIClientProtocol
    private var baseURL: String = "https://fakestoreapi.com"
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        apiClient.fetch(urlString: "\(baseURL)/products", completion: completion)
    }
    
    func fetchProductDetails(productId: Int, completion: @escaping (Result<Product, NetworkError>) -> Void) {
        apiClient.fetch(urlString: "\(baseURL)/products/\(productId)", completion: completion)
    }
}
