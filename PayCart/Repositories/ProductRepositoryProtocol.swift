//
//  ProductRepositoryProtocol.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import Foundation

// Data Layer

protocol ProductRepositoryProtocol {
    func fetchProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void)
    func fetchProductDetails(productId: Int, completion: @escaping (Result<Product, NetworkError>) -> Void)
}
