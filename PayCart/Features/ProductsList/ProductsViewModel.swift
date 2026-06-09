//
//  ProductsViewModel.swift
//  PayCart
//
//  Created by Ravi Doddi on 5/15/26.
//

import Foundation

final class ProductsViewModel {
    private var productRepository: ProductRepositoryProtocol
    private(set) var products: [Product] = [] // seting to be done only by VM class not from outside, hence giving only read access to outsiders
    
    // Delegate closures to outsiders
    var onLoadingChanged: ((Bool) -> Void)?
    var onProductsLoaded: (() -> Void)?
    var onError: ((String) -> Void)?
    var onProductSelected: ((Int) -> Void)?
    
    init(productRepository: ProductRepositoryProtocol) {
        self.productRepository = productRepository
    }
    
    func loadProducts() {
        onLoadingChanged?(true)
        
        productRepository.fetchProducts { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.onLoadingChanged?(false)
                
                switch result {
                case .success(let products):
                    self.products = products
                    self.onProductsLoaded?()
                case .failure(let error):
                    self.onError?(self.message(for: error))
                }
            }
        }
    }
    
    func numberOfProducts() -> Int {
        return products.count
    }
    
    func product(at index: Int) -> Product {
        return products[index]
    }
    
    func didSelectProduct(at index: Int) {
        let product = products[index]
        onProductSelected?(product.id)
    }
    
    private func message(for error: NetworkError) -> String {
        switch error {
        case .invalidURL:
            return "Invalid URL."
        case .noData:
            return "No data received."
        case .decodingFailed:
            return "Unable to process product data."
        case .serverError:
            return "Server error. Please try again."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
